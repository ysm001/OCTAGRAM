
class EnemyDistanceInstruction extends BranchInstruction
  ###
    Enemy Distance Instruction
  ###

  constructor : (@robot, @enemy) ->
    super

    @tipInfo = new TipInfo((labels) ->
      "敵機との距離が#{labels[0]}の場合青い矢印に進みます。<br>そうでなければ、赤い矢印に進みます。
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

    @conditions = [
      () => 0 < @_distance() <= 3,
      () => 3 < @_distance() <= 7,
      () => 7 < @_distance(),
    ]

  _distance: () ->
    enemyPos = @enemy.pos
    robotPos = @robot.pos
    robotPos.sub(enemyPos)
    robotPos.length()

  action : () ->
    (@conditions[@distanceParam.value])()

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
