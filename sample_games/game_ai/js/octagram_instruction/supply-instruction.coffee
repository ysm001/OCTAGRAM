
class SupplyInstruction extends ActionInstruction
  ###
    Shot Instruction
  ###

  constructor: (@robot) ->
    super
    @tipInfo = new TipInfo((labels) -> "現在いるマスからエネルギーを最大#{labels[0]}補給します。<br>#{labels[0]}未満しか残っていない場合はその分補給します。<br>(消費エネルギー 0 消費フレーム #{labels[0]}フレーム)")
    column = "エネルギー量"
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    @energyParam = new TipParameter(column, 1, 1, Robot.MAX_STEAL_ENERGY, 1)
    @energyParam.id = "energy"
    @energyParam.value = 1
    labels = []
    for i in [1..Robot.MAX_STEAL_ENERGY]
      labels[String(i)] = i
    @addParameter(@energyParam)
    @tipInfo.addParameter(@energyParam.id, column, labels, 1)
    @icon = new Icon(Game.instance.assets[R.TIP.LIFE], 32, 32)
    @setAsynchronous(true)

  action : () ->
    ret = @robot.supply(() => @onComplete())
    @setAsynchronous(ret != false)

  clone : () ->
    obj = @copy(new SupplyInstruction(@robot))
    obj.energyParam.value = @energyParam.value
    return obj

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
        



