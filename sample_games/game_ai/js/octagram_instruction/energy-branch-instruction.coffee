
class EnergyBranchInstruction extends BranchInstruction
  constructor : (@robot) ->
    super
    @tipInfo = new TipInfo((labels) ->
      "プレイヤーのエネルギー残量が#{labels[0]}以上の時青矢印に進みます。<br>#{labels[0]}未満の時は赤矢印に進みます。"
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

    @icon = new Icon(Game.instance.assets[R.TIP.REST_ENERGY_PLAYER], 32, 32)

  action : () ->
    @energyParam.value <= @robot.energy

  clone : () ->
    obj = @copy(new EnergyBranchInstruction(@robot))
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
