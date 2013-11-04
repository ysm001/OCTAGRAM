
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
    @tipInfo = new TipInfo((labels) -> "#{labels[0]}に1マス移動します。<br>(消費エネルギー #{Config.Energy.MOVE} 消費フレーム #{Config.Frame.ROBOT_MOVE})")
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
