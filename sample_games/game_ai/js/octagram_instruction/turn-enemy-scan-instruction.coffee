
class TurnEnemyScanInstruction extends BranchInstruction
  ###
    Turn Enemy Scan Instruction
  ###

  constructor : (@robot, @opponent) ->
    super
    @setAsynchronous(true)

    @tipInfo = new TipInfo((labels) ->
      "#{labels[0]}に#{labels[1]}回ターンします。<br>その途中に射程圏内に入っていれば、<br>青い矢印に進みます。<br>そうでなければ赤い矢印に進みます。<br>(消費エネルギー 1ターン当たり#{Config.Energy.TURN} 消費フレーム 1ターン当たり#{Config.Frame.ROBOT_TURN}フレーム)
      "
    )
    # parameter 1
    column = "回転方向"
    labels = ["時計回り", "反時計回り"]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @rotateParam = new TipParameter(column, 0, 0, 1, 1)
    @rotateParam.id = "rotate"
    @addParameter(@rotateParam)
    @tipInfo.addParameter(@rotateParam.id, column, labels, 1)

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
    count = @lengthParam.value
    i = 0
    turnOnComplete = (robot) =>
      bullet = BulletFactory.create(BulletType.NORMAL, @robot)
      if bullet.withinRange(@robot, @opponent, @robot.direct)
          @onComplete(true)
          return
      if i < count
        i+=1
        @robot.turn((@rotateParam.value+1), turnOnComplete)
      else
        @onComplete(false)
    @robot.tl.delay(Config.Frame.ROBOT_TURN).then () =>
      turnOnComplete(@robot)

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
