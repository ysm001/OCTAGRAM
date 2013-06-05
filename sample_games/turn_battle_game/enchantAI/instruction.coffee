class Instruction
    @MOVE_LEFT_UP = "moveLeftUp"
    @MOVE_LEFT_DOWN = "moveLeftDown"
    @MOVE_RIGHT_UP = "moveRightUp"
    @MOVE_RIGHT_DOWN = "moveRightDown"
    @MOVE_LEFT = "moveLeft"
    @MOVE_RIGHT = "moveRight"
    @SHOT = "shot"
    @PICKUP = "pickup"
    @SEARCH = "search"
    @GET_HP = "getHp"
    @GET_BULLET_QUEUE_SIZE = "getBulletQueueSize"
    @END = "end"

    constructor: (@id, @func)->

class MoveInstruction extends Instruction
    constructor: (id, func) ->
        super id, func

    @move: (plate) ->
        ret = false
        @prevPlate = @currentPlate
        if plate? and plate.lock == false
            pos = plate.getAbsolutePos()
            @tl.moveTo(pos.x, pos.y, PlayerRobot.UPDATE_FRAME).then(() -> @onAnimateComplete())
            @currentPlate = plate
            ret = new Point plate.ix, plate.iy
        else
            ret = false
        return ret

class MoveRight extends MoveInstruction
    constructor:() ->
        super Instruction.MOVE_RIGHT, @func
    func:() ->
        ret = true
        @frame = 0
        plate = @map.getTargetPoision(@currentPlate, Direct.RIGHT)
        return MoveInstruction.move.call(@, plate)


class MoveLeftUp extends MoveInstruction
    constructor:() ->
        super Instruction.MOVE_LEFT_UP, @func
    func: () ->
        ret = true
        @frame = 6
        plate = @map.getTargetPoision(@currentPlate, Direct.UP | Direct.LEFT)
        return MoveInstruction.move.call(@, plate)


class MoveLeftDown extends MoveInstruction
    constructor:() ->
        super Instruction.MOVE_LEFT_DOWN, @func
    func:() ->
        ret = true
        @frame = 7
        plate = @map.getTargetPoision(@currentPlate, Direct.DOWN | Direct.LEFT)
        return MoveInstruction.move.call(@, plate)

class MoveRightUp extends MoveInstruction
    constructor:() ->
        super Instruction.MOVE_RIGHT_UP, @func
    func:() ->
        ret = true
        @frame = 4
        plate = @map.getTargetPoision(@currentPlate, Direct.UP | Direct.RIGHT)
        return MoveInstruction.move.call(@, plate)

class MoveRightDown extends Instruction
    constructor:() ->
        super Instruction.MOVE_RIGHT_DOWN, @func
    func:() ->
        ret = true
        @frame = 5
        plate = @map.getTargetPoision(@currentPlate, Direct.DOWN | Direct.RIGHT)
        return MoveInstruction.move.call(@, plate)

class MoveLeft extends Instruction
    constructor:() ->
        super Instruction.MOVE_LEFT, @func
    func:() ->
        ret = true
        @frame = 2
        plate = @map.getTargetPoision(@currentPlate, Direct.LEFT)
        return MoveInstruction.move.call(@, plate)

class Shot extends Instruction
    constructor: () ->
        super Instruction.SHOT, @func
    func: (bltQueue) ->
        unless bltQueue.empty()
            for b in bltQueue.dequeue()
                b.shot(@x, @y, @getDirect())
                @scene.world.bullets.push b
                @scene.world.insertBefore b, @
            return b
        return false

class Searching extends Instruction
    constructor:() ->
        super Instruction.SEARCH, @func
    func: () ->
        world = @scene.world
        robot = if @ == world.player then world.enemy else @
        return new Point(robot.x - @x, robot.y - @y)

class Pickup extends Instruction
    constructor:() ->
        super Instruction.PICKUP, @func
    func: (type, itemClass, queue) ->
        blt = BulletFactory.create(type, @)
        ret = queue.enqueue(blt)
        if ret != false
            item = new itemClass(@x, @y)
            @scene.world.addChild item
            @scene.world.items.push item
            ret = blt
        return ret

class GetHp extends Instruction
    constructor: () ->
        super Instruction.GET_HP, @func
    func: () ->
        return @hp

class GetBulletQueueSize extends Instruction
    constructor: () ->
        super Instruction.GET_BULLET_QUEUE_SIZE, @func
    func: () ->
        return @bltQueue.size()
