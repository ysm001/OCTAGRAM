
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
