
class ApproachInstruction extends ActionInstruction
  ###
    Approach Instruction
  ###

  constructor: (@robot, @enemy) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

  action: () ->
    ret = @robot.approach(@enemy, () => @onComplete())
    @setAsynchronous(ret != false)

  clone: () ->
    obj = @copy(new ApproachInstruction(@robot, @enemy))
    return obj

  mkDescription: () ->
    "敵に近づくように移動します。<br>(消費エネルギー #{Config.Energy.APPROACH} 消費フレーム #{Config.Frame.ROBOT_MOVE})"

  getIcon: () ->
    @icon.frame = 0
    return @icon
