class RobotInstruction
  @MOVE      = "move"
  @TURN_SCAN = "turnscan"
  @SHOT      = "shot"
  @PICKUP    = "pickup"


class RobotDirect
  constructor : (@value, @frame) ->

class InstrCommon

  # direct = [
  #   Direct.RIGHT
  #   Direct.RIGHT | Direct.UP
  #   Direct.RIGHT | Direct.DOWN
  #   Direct.LEFT
  #   Direct.LEFT | Direct.UP
  #   Direct.LEFT | Direct.DOWN
  # ]
  directs = [
    Direct.RIGHT
    Direct.RIGHT | Direct.DOWN
    Direct.LEFT | Direct.DOWN
    Direct.LEFT
    Direct.LEFT | Direct.UP
    Direct.RIGHT | Direct.UP
  ]

  # frame = [
  #   0, 4, 5, 2, 6, 7
  # ]
  frame = [
    0, 5, 7, 2, 6, 4
  ]
  @getRobotDirect : (i) ->
    new RobotDirect(directs[i], frame[i])

  @getDirectSize : () ->
    directs.length

  @getDirectIndex : (direct) ->
    directs.indexOf(direct)

class AbstractMoveInstruction extends ActionInstruction

  constructor : () ->
    super

  _move: (plate) ->
    ret = false
    @robot.prevPlate = @robot.currentPlate
    # plate is exists and not locked
    if plate? and plate.lock == false
      pos = plate.getAbsolutePos()
      @robot.tl.moveTo(pos.x, pos.y,
        PlayerRobot.UPDATE_FRAME).then(() => @onComplete())
      @robot.currentPlate = plate
      ret = new Point plate.ix, plate.iy
    else
      ret = false
    return ret

  onComplete: () ->
    @robot.onAnimateComplete()
    super

class TipInfo

  constructor: (@description) ->
    @params = {}
    @labels = {}

  addParameter : (id, column, labels, value) ->
    param =
      column : column
      labels : labels
    @labels[id] = param.labels[value]
    @params[id] = param

  changeLabel : (id, value) ->
    @labels[id] = @params[id].labels[value]

  getLabel : (id) ->
    @labels[id]
    
  getDescription : () ->
    values = (v for k, v of @labels)
    @description(values)


###
  Random Move
###
class RandomMoveInstruction extends AbstractMoveInstruction

  constructor : (@robot) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

  action : () ->
    ret = true
    # get random direct
    rand = Random.nextInt() % InstrCommon.getDirectSize()
    direct = InstrCommon.getRobotDirect(rand)
    @robot.frame = direct.frame
    plate = @robot.map.getTargetPoision(@robot.currentPlate, direct.value)
    ret = @_move plate
    @setAsynchronous(ret != false)
    @robot.onCmdComplete(RobotInstruction.MOVE, ret)

  clone : () ->
    obj = @copy(new RandomMoveInstruction(@robot))
    return obj

  mkDescription: () ->
    "ランダムに移動します"

  getIcon: () ->
    @icon.frame = 0
    return @icon

###
  Move
###
class MoveInstruction extends AbstractMoveInstruction

  constructor : (@robot) ->
    super
    @setAsynchronous(true)

    # parameter 1
    column = "移動方向"
    labels = ["右", "右下", "左下", "左", "左上", "右上"]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @directParam = new TipParameter(column, 0, 0, 5, 1)
    @directParam.id = "direct"
    @addParameter(@directParam)
    @tipInfo = new TipInfo((labels) -> "#{labels[0]}に1マス移動します")
    @tipInfo.addParameter(@directParam.id, column, labels, 0)

    @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

  action : () ->
    ret = true
    direct = InstrCommon.getRobotDirect(@directParam.value)
    @robot.frame = direct.frame
    plate = @robot.map.getTargetPoision(@robot.currentPlate, direct.value)
    ret = @_move plate
    @setAsynchronous(ret != false)
    @robot.onCmdComplete(RobotInstruction.MOVE, ret)

  clone : () ->
    obj = @copy(new MoveInstruction(@robot))
    obj.directParam.value = @directParam.value
    return obj

  onParameterChanged : (parameter) ->
    if parameter.id == @directParam.id
      @directParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    @icon.frame = @directParam.value
    return @icon

###
 Turn Scan
###
class TurnScanInstruction extends BranchInstruction

  constructor : (@robot, @opponent) ->
    super
    @setAsynchronous(true)

    @tipInfo = new TipInfo((labels) ->
      "#{labels[0]}に#{labels[1]}回ターンします。<br>その途中に所持している弾丸の射程圏内に入っていれば、<br>青い矢印に進む。そうでなければ赤い矢印に進む。<br>(消費フレーム 1回転当たり5フレーム)
      "
    )
    # parameter 1
    column = "回転方向"
    labels = ["時計回り", "反時計回り"]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @rotateParam = new TipParameter(column, 0, 0, 1, 1)
    @rotateParam.id = "rotate"
    @addParameter(@rotateParam)
    @tipInfo.addParameter(@rotateParam.id, column, labels, 0)

    # parameter 2
    column = "回転回数"
    labels = [0..6]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @lengthParam = new TipParameter(column, 0, 0, 6, 1)
    @lengthParam.id = "length"
    @addParameter(@lengthParam)
    @tipInfo.addParameter(@lengthParam.id, column, labels, 0)

    @icon = new Icon(Game.instance.assets[R.TIP.SEARCH_ENEMY], 32, 32)

  _turn : (directIndex, i, count) =>
    if i < count
      direct = InstrCommon.getRobotDirect(directIndex)
      @robot.frame = direct.frame
      for k, v of @robot.bulletQueue
        if v.size() > 0
          bullet = v.index(0)
          if bullet.withinRange(@robot, @opponent, direct.value)
            Debug.log "find out opponent"
            @onComplete(true)
            return
      setTimeout(@_turn
        (1000*15)/30, (directIndex + 1) % InstrCommon.getDirectSize()
        i + 1
        count)
    else
      @onComplete(false)

  action : () ->
    count = @lengthParam.value + 1
    console.log count
    directIndex = InstrCommon.getDirectIndex(@robot.getDirect())
    setTimeout(@_turn, (1000*15)/30, directIndex, 0, count)

  clone : () ->
    obj = @copy(new TurnScanInstruction(@robot, @opponent))
    obj.rotateParam.value = @rotateParam.value
    obj.lengthParam.value = @lengthParam.value
    return obj

  onParameterChanged : (parameter) ->
    if parameter.id == @rotateParam.id
      @rotateParam = parameter
    else if parameter.id == @lengthParam.id
      @lengthParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    return @icon

class ScanInstructon extends BranchInstruction

  constructor: (@robot, @opponent) ->
    super
    @tipInfo = new TipInfo((labels) ->
      "#{labels[0]}バレットが射程圏内に入っていれば、青矢印に進む。<br>そうでなければ赤い矢印に進む"
    )
    # parameter 1
    column = "弾丸の種類"
    labels = {"1":"ストレート","2":"ワイド","3":"デュアル"}
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @typeParam = new TipParameter(column, 1, 1, 3, 1)
    @typeParam.id = "type"
    @addParameter(@typeParam)
    @tipInfo.addParameter(@typeParam.id, column, labels, 1)

    @icon = new Icon(Game.instance.assets[R.TIP.SEARCH_ENEMY], 32, 32)

  action : () ->
    switch @typeParam.value
      when BulletType.NORMAL
        bltQueue = @robot.bulletQueue.normal
      when BulletType.WIDE
        bltQueue = @robot.bulletQueue.wide
      when BulletType.DUAL
        bltQueue = @robot.bulletQueue.dual

    if bltQueue? and bltQueue.size() > 0
      blt = bltQueue.index(0)
      return blt.withinRange(@robot, @opponent, @robot.getDirect())
    else
      return false

  clone : () ->
    obj = @copy(new ScanInstructon(@robot, @opponent))
    obj.typeParam.value = @typeParam.value
    obj

  onParameterChanged : (parameter) ->
    @typeParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    return @icon

class ShotInstruction extends ActionInstruction

  constructor: (@robot) ->
    super
    @tipInfo = new TipInfo((labels) ->
      "#{labels[0]}バレットを撃つ"
    )
    # parameter 1
    column = "弾丸の種類"
    labels = {"1":"ストレート","2":"ワイド","3":"デュアル"}
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @typeParam = new TipParameter(column, 1, 1, 3, 1)
    @typeParam.id = "type"
    @addParameter(@typeParam)
    @tipInfo.addParameter(@typeParam.id, column, labels, 1)

    @icon = new Icon(Game.instance.assets[R.TIP.SHOT_BULLET], 32, 32)
    @setAsynchronous(true)

  action : () ->
    ret = false
    switch @typeParam.value
      when BulletType.NORMAL
        bltQueue = @robot.bulletQueue.normal
      when BulletType.WIDE
        bltQueue = @robot.bulletQueue.wide
      when BulletType.DUAL
        bltQueue = @robot.bulletQueue.dual

    unless bltQueue.empty()
      for b in bltQueue.dequeue()
        b.shot(@robot.x, @robot.y, @robot.getDirect())
        @robot.scene.world.bullets.push b
        @robot.scene.world.insertBefore b, @robot
        b.setOnDestoryEvent(() => @onComplete())
        ret = b
    @setAsynchronous(ret != false)
    @robot.onCmdComplete(RobotInstruction.SHOT ,ret)

  onComplete: () ->
    @robot.onAnimateComplete()
    super()

  clone : () ->
    obj = @copy(new ShotInstruction(@robot))
    obj.typeParam.value = @typeParam.value
    return obj

  onParameterChanged : (parameter) ->
    @typeParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    @icon.frame = @typeParam.value - 1
    return @icon

class PickupInstruction extends ActionInstruction

  constructor: (@robot) ->
    super
    @tipInfo = new TipInfo((labels) ->
      "#{labels[0]}バレットを一つ溜める"
    )
    # parameter 1
    column = "弾丸の種類"
    labels = {"1":"ストレート","2":"ワイド","3":"デュアル"}
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @typeParam = new TipParameter(column, 1, 1, 3, 1)
    @typeParam.id = "type"
    @addParameter(@typeParam)
    @tipInfo.addParameter(@typeParam.id, column, labels, 1)

    @icon = new Icon(Game.instance.assets[R.TIP.PICKUP_BULLET], 32, 32)
    @setAsynchronous(true)

  action: () ->
    ret = false
    type = @typeParam.value
    blt = BulletFactory.create(type, @robot)
    switch @typeParam.value
      when BulletType.NORMAL
        bltQueue = @robot.bulletQueue.normal
        itemClass = NormalBulletItem
      when BulletType.WIDE
        bltQueue = @robot.bulletQueue.wide
        itemClass = WideBulletItem
      when BulletType.DUAL
        bltQueue = @robot.bulletQueue.dual
        itemClass = DualBulletItem
    ret = bltQueue.enqueue(blt) if bltQueue?
    if ret != false
      item = new itemClass(@robot.x, @robot.y)
      @robot.scene.world.addChild item
      @robot.scene.world.items.push item
      item.setOnCompleteEvent(() => @onComplete())
      ret = blt
    @setAsynchronous(ret != false)
    @robot.onCmdComplete(RobotInstruction.PICKUP, ret)

  onComplete: () ->
    @robot.onAnimateComplete()
    super()

  clone : () ->
    obj = @copy(new PickupInstruction(@robot))
    return obj

  onParameterChanged : (parameter) ->
    @typeParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    @icon.frame = @typeParam.value - 1
    return @icon

class HpBranchInstruction extends BranchInstruction
  constructor : (@robot) ->
    super()
    # タイトル, 初期値, 最小値, 最大値, 増大値
    parameter = new TipParameter(HpStr.colnum(), 1, 1, 4, 1)
    @icon = new Icon(Game.instance.assets[R.TIP.LIFE], 32, 32)
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

  getIcon: () ->
    @icon.frame = @_id
    return @icon
