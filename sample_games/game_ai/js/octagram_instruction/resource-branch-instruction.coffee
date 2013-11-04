
class ResourceBranchInstruction extends BranchInstruction
  constructor : (@robot) ->
    super
    @tipInfo = new TipInfo((labels) ->
      "現在いるマスにエネルギーが#{labels[0]}以上ある時青矢印に進みます。<br>#{labels[0]}未満の時は赤矢印に進みます。"
    )
     # parameter 2
    column = "エネルギー"
    labels = {}
    for i in [0..Robot.MAX_ENERGY]
      labels[String(i)] = i
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @energyParam = new TipParameter(column, 0, 0, Robot.MAX_ENERGY, 1)
    @energyParam.id = "size"
    @addParameter(@energyParam)
    @tipInfo.addParameter(@energyParam.id, column, labels, 1)

    @icon = new Icon(Game.instance.assets[R.TIP.LIFE], 32, 32)

  action : () ->
    @energyParam.value <= @robot.currentPlateEnergy

  clone : () ->
    obj = @copy(new ResourceBranchInstruction(@robot))
    obj.energyParam.value = @energyParam.value
    obj

  onParameterChanged : (parameter) ->
    if parameter.id == @energyParam.id
      @energyParam = parameter
    @tipInfo.changeLabel(parameter.id, parameter.value)

  mkDescription: () ->
    @tipInfo.getDescription()

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    return @icon
        



