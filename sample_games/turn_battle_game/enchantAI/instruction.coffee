class RobotInstruction
    @MOVE = "move"
    @SHOT = "shot"
    @PICKUP = "pickup"
    @SEARCH = "search"
    @GET_HP = "getHp"
    @GET_BULLET_QUEUE_SIZE = "getBulletQueueSize"
    @END = "end"

    constructor: (@id, @func)->

class MoveInstruction extends RobotInstruction
    constructor: (id, func) ->
        super id, func

    @move: (plate, instr) ->
        ret = false
        @prevPlate = @currentPlate
        if plate? and plate.lock == false
            pos = plate.getAbsolutePos()
            @tl.moveTo(pos.x, pos.y, PlayerRobot.UPDATE_FRAME).then(() -> instr.onComplete())
            @currentPlate = plate
            ret = new Point plate.ix, plate.iy
        else
            ret = false
        return ret

class MovingInstruction extends ActionInstruction
    constructor : (@robot, @direct, @frame, @instrClass) ->
        super
        @setAsynchronous(true)

    action : () -> 
        ret = true
        @robot.frame = @frame
        Debug.log @frame
        plate = @robot.map.getTargetPoision(@robot.currentPlate, @direct)
        ret = MoveInstruction.move.call(@robot, plate, @)
        @setAsynchronous(ret != false)
        @ret = ret

    onComplete: () ->
        @robot.onAnimateComplete()
        @robot.onCmdComplete(RobotInstruction.MOVE, @ret)
        super

    clone : () -> 
        instr = new @instrClass(@robot)
        return instr


class MoveRightInstruction extends MovingInstruction
    constructor : (@robot) ->
        super(@robot, Direct.RIGHT, 0, MoveRightInstruction)

    mkDescription: () ->
        "MoveRightInstruction"

class MoveLeftInstruction extends MovingInstruction
    constructor : (@robot) ->
        super(@robot, Direct.LEFT, 2, MoveLeftInstruction)

    mkDescription: () ->
        "MoveLeftInstruction"

class MoveRightUpInstruction extends MovingInstruction
    constructor : (@robot) ->
        super(@robot, Direct.RIGHT | Direct.UP, 4, MoveRightUpInstruction)

    mkDescription: () ->
        "MoveRightUpInstruction"

class MoveRightDownInstruction extends MovingInstruction
    constructor : (@robot) ->
        super(@robot, Direct.RIGHT | Direct.DOWN, 5, MoveRightDownInstruction)

    mkDescription: () ->
        "MoveRightDownInstruction"

class MoveLeftUpInstruction extends MovingInstruction
    constructor : (@robot) ->
        super(@robot, Direct.LEFT | Direct.UP, 6, MoveLeftUpInstruction)

    mkDescription: () ->
        "MoveLeftUpInstruction"

class MoveLeftDownInstruction extends MovingInstruction
    constructor : (@robot) ->
        super(@robot, Direct.LEFT | Direct.DOWN, 7, MoveLeftDownInstruction)

    mkDescription: () ->
        "MoveLeftDownInstruction"


class ShotInstruction extends ActionInstruction
    constructor : (@robot, @bltQueue, @instrClass) ->
        super
        @setAsynchronous(true)

    action : () -> 
        ret = false
        unless @bltQueue.empty()
            for b in @bltQueue.dequeue()
                b.shot(@robot.x, @robot.y, @robot.getDirect())
                @robot.scene.world.bullets.push b
                @robot.scene.world.insertBefore b, @robot
                b.setOnDestoryEvent(() => @onComplete())
                ret = b
        @setAsynchronous(ret != false)
        @ret = ret

    onComplete: () ->
        @robot.onAnimateComplete()
        @robot.onCmdComplete(RobotInstruction.SHOT ,@ret)
        super

    clone : () -> 
        instr = new @instrClass(@robot)
        return instr

class NormalShotInstruction extends ShotInstruction
    constructor: (robot) ->
        super robot, robot.bltQueue, NormalShotInstruction

    mkDescription: () ->
        "NormalShotInstruction"

class WideShotInstruction extends ShotInstruction
    constructor: (robot) ->
        super robot, robot.wideBltQueue, WideShotInstruction

    mkDescription: () ->
        "WideShotInstruction"

class DualShotInstruction extends ShotInstruction
    constructor: (robot) ->
        super robot, robot.dualBltQueue, DualShotInstruction

    mkDescription: () ->
        "DualShotInstruction"

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
        @ret = ret

    onComplete: () ->
        @robot.onAnimateComplete()
        @robot.onCmdComplete(RobotInstruction.PICKUP, @ret)
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
