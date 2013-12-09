
class CheckMapInstruction extends BranchInstruction
  ###
     CheckMap Instruction
  ###

  constructor : (@player) ->
    super
    # parameter 1
    column = "回転方向"
    labels = [ "前", "右", "左"]
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @directParam = new TipParameter(column, 0, 0, 2, 1)
    @directParam.id = "direct"
    @addParameter(@directParam)
    @tipInfo = new TipInfo((labels) -> "#{labels[0]}に進めるなら青い矢印に進みます。そうでなければ赤い矢印に進みます。")
    @tipInfo.addParameter(@directParam.id, column, labels, 0)
    @icon = new Icon(Game.instance.assets[R.TIP.SEARCH_BARRIER], 32, 32)

  action : () ->
    ret = false
    if @directParam.value == 0
      ret = @player.isThrough(Direction.UP)
    else if @directParam.value == 1
      ret = @player.isThrough(Direction.RIGHT)
    else if @directParam.value == 2
      ret = @player.isThrough(Direction.LEFT)
    ret
    # @robot.onCmdComplete(RobotInstruction.MOVE, ret)

  clone : () ->
    obj = @copy(new CheckMapInstruction(@player))
    obj.directParam = @directParam
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
    @icon.frame = 0
    return @icon
        



