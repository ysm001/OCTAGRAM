
class LeaveInstruction extends ActionInstruction
  ###
    Leave Instruction
  ###

  constructor : (@robot, @enemy) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.MOVE_FROM_ENEMY], 32, 32)

  action : () ->
    ret = @robot.leave(@enemy, () => @onComplete())
    @setAsynchronous(ret != false)

  clone : () ->
    obj = @copy(new LeaveInstruction(@robot, @enemy))
    return obj

  mkDescription: () ->
    "敵機から離れるように移動します。<br>(消費エネルギー #{Config.Energy.LEAVE} 消費フレーム #{Config.Frame.ROBOT_MOVE})"

  getIcon: () ->
    @icon.frame = 0
    return @icon
