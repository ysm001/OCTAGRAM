class InstrCommon

  class RobotDirect
    constructor : (@value, @frame) ->

  directs = [
    Direct.RIGHT
    Direct.RIGHT | Direct.DOWN
    Direct.LEFT | Direct.DOWN
    Direct.LEFT
    Direct.LEFT | Direct.UP
    Direct.RIGHT | Direct.UP
  ]

  frame = [
    0, 5, 7, 2, 6, 4
  ]
  @getRobotDirect : (i) ->
    new RobotDirect(directs[i], frame[i])

  @getDirectSize : () ->
    directs.length

  @getDirectIndex : (direct) ->
    directs.indexOf(direct)

  @getFrame : (direct) ->
    for i in [0..directs.length]
      if directs[i] == direct
        return frame[i]
    return 0

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


class RandomMoveInstruction extends ActionInstruction
  ###
    Random Move Instruction
  ###

  constructor : (@robot) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

  action : () ->
    ret = false
    # get random direct
    while !ret
      rand = Random.nextInt() % InstrCommon.getDirectSize()
      direct = InstrCommon.getRobotDirect(rand)
      ret = @robot.move(direct.value, () => @onComplete())
    @setAsynchronous(ret != false)
    # @robot.onCmdComplete(RobotInstruction.MOVE, ret)

  clone : () ->
    obj = @copy(new RandomMoveInstruction(@robot))
    return obj

  mkDescription: () ->
    "移動可能なマスにランダムに移動します。"

  getIcon: () ->
    @icon.frame = 0
    return @icon

class ApproachInstruction extends ActionInstruction
  ###
    Approach Instruction
  ###

  constructor : (@robot, @enemy) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

  action : () ->
    ret = false
    enemyPos = @enemy.pos
    robotPos = @robot.pos
    robotPos.sub(enemyPos)

    direct = Direct.NONE
    if robotPos.x > 0
     direct |=  Direct.LEFT
    else if robotPos.x < 0
     direct |=  Direct.RIGHT

    if robotPos.y > 0
      direct |=  Direct.UP
      if robotPos.x == 0
        direct |= Direct.RIGHT
    else if robotPos.y < 0
      direct |=  Direct.DOWN
      if robotPos.x == 0
        direct |= Direct.LEFT

    if direct != Direct.NONE and direct != Direct.UP and direct != Direct.DOWN
      ret = @robot.move(direct, () => @onComplete())
    if ret == false
      @onComplete()

  clone : () ->
    obj = @copy(new ApproachInstruction(@robot, @enemy))
    return obj

  mkDescription: () ->
    "敵に近づくように移動します。"

  getIcon: () ->
    @icon.frame = 0
    return @icon

class LeaveInstruction extends ActionInstruction
  ###
    Leave Instruction
  ###

  constructor : (@robot, @enemy) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

  action : () ->
    ret = false
    enemyPos = @enemy.pos
    robotPos = @robot.pos
    robotPos.sub(enemyPos)

    direct = Direct.NONE
    if robotPos.x >= 0
     direct |=  Direct.RIGHT
    else if robotPos.x < 0
     direct |=  Direct.LEFT

    if robotPos.y >= 0
      direct |=  Direct.DOWN
      if robotPos.x == 0
        direct |= Direct.LEFT
    else if robotPos.y < 0
      direct |=  Direct.UP
      if robotPos.x == 0
        direct |= Direct.RIGHT

    if direct != Direct.NONE and direct != Direct.UP and direct != Direct.DOWN
      ret = @robot.move(direct, () => @onComplete())
    if ret == false
      @onComplete()

  clone : () ->
    obj = @copy(new LeaveInstruction(@robot, @enemy))
    return obj

  mkDescription: () ->
    "敵から離れるように移動します。"

  getIcon: () ->
    @icon.frame = 0
    return @icon


class EnemyDistanceInstruction extends BranchInstruction

  constructor : (@robot, @enemy) ->
    super
    @setAsynchronous(true)

    @tipInfo = new TipInfo((labels) ->
      "敵との距離が#{labels[0]}の場合青い矢印に進みます。<br>そうでなければ、赤い矢印に進みます。
      "
    )
    # parameter 1
    column = "距離"
    labels = ["近距離", "中距離", "遠距離"]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @distanceParam = new TipParameter(column, 0, 0, 2, 1)
    @distanceParam.id = "distance"
    @addParameter(@distanceParam)
    @tipInfo.addParameter(@distanceParam.id, column, labels, 0)

    @icon = new Icon(Game.instance.assets[R.TIP.SEARCH_ENEMY], 32, 32)

  action : () ->
    true

  clone : () ->
    obj = @copy(new EnemyDistanceInstruction(@robot, @enemy))
    obj.distanceParam.value = @distanceParam.value
    return obj

  onParameterChanged : (parameter) ->
    @distanceParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    return @icon

class MoveInstruction extends ActionInstruction
  ###
    Move Instruction
  ###

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
    @tipInfo = new TipInfo((labels) -> "#{labels[0]}に1マス移動します。")
    @tipInfo.addParameter(@directParam.id, column, labels, 0)

    @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

  action : () ->
    ret = true
    direct = InstrCommon.getRobotDirect(@directParam.value)
    ret = @robot.move(direct.value, () => @onComplete())
    @setAsynchronous(ret != false)
    # @robot.onCmdComplete(RobotInstruction.MOVE, ret)

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
 Turn Enemy Scan
###
class TurnEnemyScanInstruction extends BranchInstruction

  constructor : (@robot, @opponent) ->
    super
    @setAsynchronous(true)

    @tipInfo = new TipInfo((labels) ->
      "#{labels[0]}に#{labels[1]}回ターンします。<br>その途中に所持している弾丸の射程圏内に入っていれば、<br>青い矢印に進みます。<br>そうでなければ赤い矢印に進みます。<br>(消費フレーム 1回転当たり5フレーム)
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
    labels = [0..5]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @lengthParam = new TipParameter(column, 0, 0, 5, 1)
    @lengthParam.id = "length"
    @addParameter(@lengthParam)
    @tipInfo.addParameter(@lengthParam.id, column, labels, 0)

    @icon = new Icon(Game.instance.assets[R.TIP.SEARCH_ENEMY], 32, 32)

  action : () ->
    count = @lengthParam.value + 1
    i = 0
    turnOnComplete = (robot) =>
      if i < count
        for k, v of @robot.bulletQueue
          if v.size() > 0
            bullet = v.index(0)
            if bullet.withinRange(@robot, @opponent, @robot.direct)
              @onComplete(true)
              return
        i+=1
        @robot.turn(turnOnComplete)
      else
        @onComplete(false)
    setTimeout((() =>
      turnOnComplete(@robot)),
      Util.toMillisec(15)
    )

  clone : () ->
    obj = @copy(new TurnEnemyScanInstruction(@robot, @opponent))
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

###
  scan item -> go
###
class ItemScanMoveInstruction extends ActionInstruction

  constructor : (@robot) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.SEARCH_BARRIER], 32, 32)

  action : () ->
    setTimeout((() =>
      ret = false
      target = null
      targetDirect = null
      Map.instance.eachSurroundingPlate @robot.currentPlate, (plate, direct) =>
        if target is null and plate.spot?
          target = plate
          targetDirect = direct
      if target?
        ret = @robot.move(targetDirect, () => @onComplete())
        # @robot.onCmdComplete(RobotInstruction.MOVE, ret)
      else
        @onComplete())
    ,Util.toMillisec(PlayerRobot.UPDATE_FRAME))

  clone : () ->
    obj = @copy(new ItemScanMoveInstruction(@robot))
    return obj

  mkDescription: () ->
    "周囲1マスを探索し、弾丸を見つけた場合、そのマスへ進みます。<br>  (消費フレーム 40フレーム)"

  getIcon: () ->
    return @icon


class EnemyScanInstructon extends BranchInstruction

  constructor: (@robot, @opponent) ->
    super
    @tipInfo = new TipInfo((labels) ->
      "#{labels[0]}バレットが射程圏内に入っていれば、青矢印に進みます。<br>そうでなければ赤い矢印に進みます"
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
    bullet = BulletFactory.create(@typeParam.value, @robot)
    if bullet?
      return bullet.withinRange(@robot, @opponent, @robot.direct)
    else
      return false

  clone : () ->
    obj = @copy(new EnemyScanInstructon(@robot, @opponent))
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
      "#{labels[0]}バレットを撃ちます。<br>射程距離:前方方向に距離5<br>"
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
    ret = @robot.shot(@typeParam.value, () => @onComplete())
    @setAsynchronous(ret != false)

  onComplete: () ->
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

class HpBranchInstruction extends BranchInstruction
  constructor : (@robot) ->
    super
    @tipInfo = new TipInfo((labels) ->
      "HPが#{labels[0]}以上の時青矢印に進みます。<br>#{labels[0]}未満の時は赤矢印に進みます。"
    )
     # parameter 2
    column = "HP"
    labels = {}
    for i in [1..Robot.MAX_HP]
      labels[String(i)] = i
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @hpParam = new TipParameter(column, 1, 1, Robot.MAX_HP, 1)
    @hpParam.id = "size"
    @addParameter(@hpParam)
    @tipInfo.addParameter(@hpParam.id, column, labels, 1)

    @icon = new Icon(Game.instance.assets[R.TIP.LIFE], 32, 32)

  action : () ->
    @hpParam.value <= @robot.hp

  clone : () ->
    obj = @copy(new HpBranchInstruction(@robot))
    obj.hpParam.value = @hpParam.value
    obj

  onParameterChanged : (parameter) ->
    if parameter.id == @hpParam.id
      @hpParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    return @icon


class HoldBulletBranchInstruction extends BranchInstruction

  constructor: (@robot) ->
    super
    @tipInfo = new TipInfo((labels) ->
      "#{labels[0]}バレッドの保有弾数が#{labels[1]}以上の時青矢印に進みます。<br>#{labels[1]}未満の時は赤矢印に進みます。"
    )
    # parameter 1
    column = "弾丸の種類"
    labels = {"1":"ストレート","2":"ワイド","3":"デュアル"}
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @typeParam = new TipParameter(column, 1, 1, 3, 1)
    @typeParam.id = "type"
    @addParameter(@typeParam)
    @tipInfo.addParameter(@typeParam.id, column, labels, 1)

    # parameter 2
    column = "保有弾数"
    labels = [0..5]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @sizeParam = new TipParameter(column, 0, 0, 5, 1)
    @sizeParam.id = "size"
    @addParameter(@sizeParam)
    @tipInfo.addParameter(@sizeParam.id, column, labels, 0)

    @icon = new Icon(Game.instance.assets[R.TIP.REST_BULLET], 32, 32)

  action: () ->
    switch @typeParam.value
      when BulletType.NORMAL
        bltQueue = @robot.bulletQueue.normal
      when BulletType.WIDE
        bltQueue = @robot.bulletQueue.wide
      when BulletType.DUAL
        bltQueue = @robot.bulletQueue.dual
    if bltQueue.size() >= @sizeParam.value
      return true
    else
      return false

  clone : () ->
    obj = @copy(new HoldBulletBranchInstruction(@robot))
    obj.typeParam.value = @typeParam.value
    obj.sizeParam.value = @sizeParam.value
    return obj

  onParameterChanged : (parameter) ->
    if parameter.id == @typeParam.id
      @typeParam = parameter
    else if parameter.id == @sizeParam.id
      @sizeParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    return @icon
