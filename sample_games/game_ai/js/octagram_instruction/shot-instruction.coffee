
class ShotInstruction extends ActionInstruction
  ###
    Shot Instruction
  ###

  constructor: (@robot) ->
    super
    @icon = new Icon(Game.instance.assets[R.TIP.SHOT_BULLET], 32, 32)
    @setAsynchronous(true)

  action : () ->
    ret = @robot.shot(() => @onComplete())
    @setAsynchronous(ret != false)

  clone : () ->
    obj = @copy(new ShotInstruction(@robot))
    return obj

  mkDescription: () ->
     "ストレートバレットを撃ちます。<br>射程距離:前方方向に距離5<br>(消費エネルギー #{Config.Energy.SHOT} 消費フレーム #{Config.Frame.BULLET}フレーム)"

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    return @icon
