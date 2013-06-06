R = Config.R
MOVE_STR = R.String.INSTRUCTION.MOVE
SHOT_STR = R.String.INSTRUCTION.SHOT
PICKUP_STR = R.String.INSTRUCTION.PICKUP
HP_STR = R.String.INSTRUCTION.HP
HoldBulletStr = R.String.INSTRUCTION.HOLD_BULLEFT

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
        @_id = 0
        @setAsynchronous(true)
        # sliderタイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(MOVE_STR.colnum(), 0, 0, 5, 1)
        @addParameter(parameter)
        @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

    action : () -> 
        ret = true
        @robot.frame = MoveInstruction.frame[@_id]
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

    mkLabel: () ->
        MOVE_STR.label[@_id]()

    getIcon: () ->
        @icon.frame = @_id
        return @icon

class ShotInstruction extends ActionInstruction
    bltQueue = null
    constructor : (@robot) ->
        super
        if bltQueue == null
            bltQueue = [
                @robot.bltQueue
                @robot.wideBltQueue
                @robot.dualBltQueue
            ]
        # sliderタイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(SHOT_STR.colnum(), 0, 0, 2, 1)
        @_id = 0
        @addParameter(parameter)
        @setAsynchronous(true)

    action : () -> 
        ret = false
        queue = bltQueue[@_id]
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

    mkLabel: () ->
        SHOT_STR.label[@_id]()

    mkDescription: () ->
        SHOT_STR.description[@_id]()

class PickupInstruction extends ActionInstruction
    type = [
        BulletType.NORMAL
        BulletType.WIDE
        BulletType.DUAL
    ]
    itemClass = [
        NormalBulletItem,
        WideBulletItem,
        DualBulletItem
    ]
    bltQueue = null

    constructor: (@robot) ->
        super
        if bltQueue == null
            bltQueue = [
                @robot.bltQueue
                @robot.wideBltQueue
                @robot.dualBltQueue
            ]
        @setAsynchronous(true)
        # タイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(PICKUP_STR.colnum(), 0, 0, 2, 1)
        @_id = 0
        @addParameter(parameter)

    action: () ->
        blt = BulletFactory.create(type[@_id], @robot)
        ret = bltQueue[@_id].enqueue(blt)
        if ret != false
            item = new itemClass[@_id](@robot.x, @robot.y)
            @robot.scene.world.addChild item
            @robot.scene.world.items.push item
            item.setOnCompleteEvent(() => @onComplete())
            ret = blt
        @setAsynchronous(ret != false)
        @robot.onCmdComplete(RobotInstruction.PICKUP, ret)

    onComplete: () ->
        @robot.onAnimateComplete()
        super()

    onParameterChanged : (parameter) -> 
        @_id = parameter.value

    clone : () -> 
        obj = @copy(new PickupInstruction(@robot))
        obj._id = @_id
        return obj

    mkLabel: () ->
        PICKUP_STR.label[@_id]()

    mkDescription: () ->
        PICKUP_STR.description[@_id]()

class HpBranchInstruction extends BranchInstruction
    constructor : (@robot) ->
        super()
        # タイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(HP_STR.colnum(), 1, 1, 4, 1)
        @hp = 1
        @addParameter(parameter)

    action : () ->
        @hp <= @robot.hp

    clone : () ->
        obj = @copy(new HpBranchInstruction(@robot))
        obj.hp = @hp
        obj

    onParameterChanged : (parameter) ->
        @hp = parameter.value

    mkDescription : () ->
        HP_STR.description(@hp)

class HoldBulletBranchInstruction extends BranchInstruction

    bltQueue = null
    constructor: (@robot) ->
        super
        if bltQueue == null
            bltQueue = [
                @robot.bltQueue
                @robot.wideBltQueue
                @robot.dualBltQueue
            ]
        @_id = 0
        @bulletSize = 0
        # タイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(HoldBulletStr.colnum(HoldBulletStr.id.kind), 0, 0, 3, 1)
        parameter.id = HoldBulletStr.id.kind
        @addParameter(parameter)
        parameter = new TipParameter(HoldBulletStr.colnum(HoldBulletStr.id.size), 0, 0, 5, 1)
        parameter.id = HoldBulletStr.id.size
        @addParameter(parameter)

    action : () ->
        @bulletSize <= bltQueue[@_id].size()

    clone : () ->
        obj = @copy(new HoldBulletBranchInstruction(@robot))
        obj._id = @_id
        obj.bulletSize = @bulletSize
        obj

    onParameterChanged : (parameter) ->
        if parameter.id == HoldBulletStr.id.kind
            @_id = parameter.value
        else if parameter.id == HoldBulletStr.id.size
            @bulletSize = parameter.value

    mkLabel: (parameter) ->
        if parameter.id == HoldBulletStr.id.kind
            return HoldBulletStr.label[@_id]()
        else if parameter.id == HoldBulletStr.id.size
            return parameter.value

    mkDescription: () ->
        HoldBulletStr.description[@_id](@bulletSize)

class SearchingBranchInstruction extends BranchInstruction

    @direct = [
        Direct.RIGHT
        Direct.RIGHT | Direct.UP
        Direct.RIGHT | Direct.DOWN
        Direct.LEFT
        Direct.LEFT | Direct.UP
        Direct.LEFT | Direct.DOWN
    ]
    constructor: (@robot) ->
        super
        if bltQueues == null
            bltQueues = [
                @robot.bltQueue
                @robot.wideBltQueue
                @robot.dualBltQueue
            ]
        @_id = 0
        @bulletSize = 0
        # タイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(HoldBulletStr.colnum(HoldBulletStr.id.kind), 0, 0, 3, 1)
        parameter.id = HoldBulletStr.id.kind
        @addParameter(parameter)
        parameter = new TipParameter(HoldBulletStr.colnum(HoldBulletStr.id.size), 0, 0, 5, 1)
        parameter.id = HoldBulletStr.id.size
        @addParameter(parameter)

    action : () ->
        @bulletSize <= bltQueue[@_id].size()

    clone : () ->
        obj = @copy(new HoldBulletBranchInstruction(@robot))
        obj._id = @_id
        obj.bulletSize = @bulletSize
        obj

    onParameterChanged : (parameter) ->
        if parameter.id == HoldBulletStr.id.kind
            @_id = parameter.value
        else if parameter.id == HoldBulletStr.id.size
            @bulletSize = parameter.value

    mkLabel: (parameter) ->
        if parameter.id == HoldBulletStr.id.kind
            return HoldBulletStr.label[@_id]()
        else if parameter.id == HoldBulletStr.id.size
            return parameter.value

    mkDescription: () ->
        HoldBulletStr.description[@_id](@bulletSize)

class Searching extends RobotInstruction
    constructor:() ->
        super RobotInstruction.SEARCH, @func
    func: () ->
        world = @scene.world
        robot = if @ == world.player then world.enemy else @
        return new Point(robot.x - @x, robot.y - @y)

