R = Config.R
MoveStr = R.String.INSTRUCTION.Move
ShotStr = R.String.INSTRUCTION.Shot
PickupStr = R.String.INSTRUCTION.Pickup
HpStr = R.String.INSTRUCTION.Hp
HoldBulletStr = R.String.INSTRUCTION.HoldBulleft
SearchingDirectStr = R.String.INSTRUCTION.SearchingDirect

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
        parameter = new TipParameter(MoveStr.colnum(), 0, 0, 5, 1)
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
        MoveStr.description[@_id](1)

    mkLabel: () ->
        MoveStr.label[@_id]()

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
        parameter = new TipParameter(ShotStr.colnum(), 0, 0, 2, 1)
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
        ShotStr.label[@_id]()

    mkDescription: () ->
        ShotStr.description[@_id]()

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
        parameter = new TipParameter(PickupStr.colnum(), 0, 0, 2, 1)
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
        PickupStr.label[@_id]()

    mkDescription: () ->
        PickupStr.description[@_id]()

class HpBranchInstruction extends BranchInstruction
    constructor : (@robot) ->
        super()
        # タイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(HpStr.colnum(), 1, 1, 4, 1)
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
        HpStr.description(@hp)

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

class SearchingDirectBranchInstruction extends BranchInstruction

    direct = [
        Direct.RIGHT
        Direct.RIGHT | Direct.UP
        Direct.RIGHT | Direct.DOWN
        Direct.LEFT
        Direct.LEFT | Direct.UP
        Direct.LEFT | Direct.DOWN
    ]
    constructor: (@robot) ->
        super
        @_id = 0
        @lenght = 1
        # タイトル, 初期値, 最小値, 最大値, 増大値
        parameter = new TipParameter(SearchingDirectStr.colnum(SearchingDirectStr.id.direct), 0, 0, 5, 1)
        parameter.id = SearchingDirectStr.id.direct
        @addParameter(parameter)
        parameter = new TipParameter(SearchingDirectStr.colnum(SearchingDirectStr.id.lenght), 1, 1, 4, 1)
        parameter.id = SearchingDirectStr.id.lenght
        @addParameter(parameter)

    action : () ->
        Map.instance.isExistObject @robot.currentPlate, direct[@_id], @lenght

    clone : () ->
        obj = @copy(new SearchingDirectBranchInstruction(@robot))
        obj._id = @_id
        obj.lenght = @lenght
        obj

    onParameterChanged : (parameter) ->
        if parameter.id == SearchingDirectStr.id.direct
            Map.instance.eachPlate @robot.currentPlate, direct[@_id], (plate, i) =>
                plate.setState Plate.STATE_NORMAL if i > 0
            @_id = parameter.value
        else if parameter.id == SearchingDirectStr.id.lenght
            @lenght = parameter.value
        Map.instance.eachPlate @robot.currentPlate, direct[@_id], (plate, i) =>
            if i > 0 and i <= @lenght
                plate.setState Plate.STATE_SELECTED
            else if i > 0 and i > @lenght
                plate.setState Plate.STATE_NORMAL


    onParameterComplete : (parameter) ->
        Map.instance.eachPlate @robot.currentPlate, direct[@_id], (plate, i) ->
            if i > 0 and i < @lenght
                plate.setState Plate.STATE_NORMAL

    mkLabel: (parameter) ->
        if parameter.id == SearchingDirectStr.id.direct
            return SearchingDirectStr.label[@_id]()
        else if parameter.id == SearchingDirectStr.id.lenght
            return parameter.value

    mkDescription: () ->
        SearchingDirectStr.description[@_id](@lenght)
