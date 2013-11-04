
class EnemyDistanceInstruction extends BranchInstruction
  ###
    Enemy Distance Instruction
  ###

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
