
class TurnInstruction extends ActionInstruction
  ###
     StraightMove Instruction
  ###

  constructor : (@player) ->
    super
    @setAsynchronous(true)
    # parameter 1
    column = "回転方向"
    labels = ["右", "左"]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @directParam = new TipParameter(column, 0, 0, 1, 1)
    @directParam.id = "direct"
    @addParameter(@directParam)
    @tipInfo = new TipInfo((labels) -> "#{labels[0]}に回転します")
    @tipInfo.addParameter(@directParam.id, column, labels, 0)
    @icon = new Icon(Game.instance.assets[R.TIP.TURN], 32, 32)

  action : () ->
    ret = false
    if @directParam.value == 0
      @player.turnRight()
    else
      @player.turnLeft()
    @setAsynchronous(ret != false)
    # @robot.onCmdComplete(RobotInstruction.MOVE, ret)

  clone : () ->
    obj = @copy(new TurnInstruction(@player))
    obj.directParam = @directParam
    return obj

  onParameterChanged : (parameter) ->
    if parameter.id == @directParam.id
      @directParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  generateCode: () ->
    if @directParam.value == 0
      "turnRight"
    else
      "turnLeft"

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    @icon.frame = @directParam.value
    return @icon
