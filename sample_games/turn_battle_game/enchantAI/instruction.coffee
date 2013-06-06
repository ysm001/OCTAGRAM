R = Config.R
MOVE_STR = R.String.INSTRUCTION.MOVE
SHOT_STR = R.String.INSTRUCTION.SHOT

class RobotInstruction
    @MOVE = "move"
    @SHOT = "shot"
    @PICKUP = "pickup"
    @SEARCH = "search"
    @GET_HP = "getHp"
    @GET_BULLET_QUEUE_SIZE = "getBulletQueueSize"

class MoveInstruction extends ActionInstruction
    @direct = [
        Direct.RIGHT
        Direct.RIGHT | Direct.UP
        Direct.RIGHT | Direct.DOWN
        Direct.LEFT
        Direct.LEFT | Direct.UP
        Direct.LEFT | Direct.DOWN
    ]
    @frame = [
        0, 4, 5, 2, 6, 7
    ]
    constructor : (@robot) ->
        super
        @setAsynchronous(true)
        # sliderタイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(MOVE_STR.colnum(), 0, 0, 6, 1)
        @_id = 0
        @addParameter(parameter)

    action : () -> 
        ret = true
        @robot.frame = MoveInstruction.frame[@directId]
        plate = @robot.map.getTargetPoision(@robot.currentPlate, MoveInstruction.direct[@_id])
        ret = @_move plate
        @setAsynchronous(ret != false)
        @robot.onCmdComplete(RobotInstruction.MOVE, ret)

    _move: (plate) ->
        ret = false
        @robot.prevPlate = @robot.currentPlate
        if plate? and plate.lock == false
            pos = plate.getAbsolutePos()
            @robot.tl.moveTo(pos.x, pos.y, PlayerRobot.UPDATE_FRAME).then(() => @onComplete())
            @robot.currentPlate = plate
            ret = new Point plate.ix, plate.iy
        else
            ret = false
        return ret

    onComplete: () ->
        @robot.onAnimateComplete()
        super

    clone : () -> 
        obj = @copy(new MoveInstruction(@robot))
        obj._id = @_id
        return obj

    onParameterChanged : (parameter) -> 
        @_id = parameter.value

    mkDescription: () ->
        MOVE_STR.description[@_id](1)

class ShotInstruction extends ActionInstruction
    bltQueues = null
    constructor : (@robot) ->
        super
        if bltQueues == null
            bltQueues = [
                @robot.bltQueue
                @robot.wideBltQueue
                @robot.dualBltQueue
            ]
        # sliderタイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(MOVE_STR.colnum(), 0, 0, 2, 1)
        @_id = 0
        @addParameter(parameter)
        @setAsynchronous(true)

    action : () -> 
        ret = false
        queue = bltQueues[@_id]
        unless queue.empty()
            for b in queue.dequeue()
                b.shot(@robot.x, @robot.y, @robot.getDirect())
                @robot.scene.world.bullets.push b
                @robot.scene.world.insertBefore b, @robot
                b.setOnDestoryEvent(() => @onComplete())
                ret = b
        @setAsynchronous(ret != false)
        @robot.onCmdComplete(RobotInstruction.SHOT ,ret)

    onComplete: () ->
        @robot.onAnimateComplete()
        super

    onParameterChanged : (parameter) -> 
        @_id = parameter.value

    clone : () -> 
        obj = @copy(new ShotInstruction(@robot))
        obj._id = @_id
        return obj

    mkDescription: () ->
        SHOT_STR.description[@_id]()

class PickupInstruction extends ActionInstruction
    constructor: (@robot, @queue, @type, @itemClass, @instrClass) ->
        super
        @setAsynchronous(true)

    action: () ->
        blt = BulletFactory.create(@type, @robot)
        ret = @queue.enqueue(blt)
        if ret != false
            item = new @itemClass(@robot.x, @robot.y)
            @robot.scene.world.addChild item
            @robot.scene.world.items.push item
            item.setOnCompleteEvent(() => @onComplete())
            ret = blt
        @setAsynchronous(ret != false)
        @robot.onCmdComplete(RobotInstruction.PICKUP, ret)

    onComplete: () ->
        @robot.onAnimateComplete()
        super

    clone : () -> 
        instr = new @instrClass(@robot)
        return instr

class NormalPickupInstruction extends PickupInstruction
    constructor: (robot) ->
        super robot, robot.bltQueue, BulletType.NORMAL, NormalBulletItem, NormalPickupInstruction

    mkDescription: () ->
        "NormalPickupInstruction"

class WidePickupInstruction extends PickupInstruction
    constructor: (robot) ->
        super robot, robot.wideBltQueue, BulletType.WIDE, WideBulletItem, WidePickupInstruction

    mkDescription: () ->
        "WidePickupInstruction"

class DualPickupInstruction extends PickupInstruction
    constructor: (robot) ->
        super robot, robot.dualBltQueue, BulletType.DUAL, DualBulletItem, DualPickupInstruction

    mkDescription: () ->
        "DualPickupInstruction"

class Searching extends RobotInstruction
    constructor:() ->
        super RobotInstruction.SEARCH, @func
    func: () ->
        world = @scene.world
        robot = if @ == world.player then world.enemy else @
        return new Point(robot.x - @x, robot.y - @y)

class Pickup extends RobotInstruction
    constructor:() ->
        super RobotInstruction.PICKUP, @func
    func: (type, itemClass, queue) ->
        blt = BulletFactory.create(type, @)
        ret = queue.enqueue(blt)
        if ret != false
            item = new itemClass(@x, @y)
            @scene.world.addChild item
            @scene.world.items.push item
            ret = blt
        return ret

class GetHp extends RobotInstruction
    constructor: () ->
        super RobotInstruction.GET_HP, @func
    func: () ->
        return @hp

class GetBulletQueueSize extends RobotInstruction
    constructor: () ->
        super RobotInstruction.GET_BULLET_QUEUE_SIZE, @func
    func: () ->
        return @bltQueue.size()
