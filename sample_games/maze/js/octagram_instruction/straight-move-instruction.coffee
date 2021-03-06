        
class StraightMoveInstruction extends ActionInstruction
  ###
     StraightMove Instruction
  ###

  constructor : (@player) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.ARROW], 32, 32)

  action : () ->
    ret = false
    ret = @player.move(() => @onComplete())
    @setAsynchronous(ret != false)
    # @robot.onCmdComplete(RobotInstruction.MOVE, ret)

  clone : () ->
    obj = @copy(new StraightMoveInstruction(@player))
    return obj

  generateCode: () -> "moveForward"

  mkDescription: () ->
    "1マス直進します。"

  getIcon: () ->
    return @icon
