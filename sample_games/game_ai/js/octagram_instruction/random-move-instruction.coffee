        
class RandomMoveInstruction extends ActionInstruction
  ###
    Random Move Instruction
  ###

  constructor : (@robot) ->
    super
    @setAsynchronous(true)
    @icon = new Icon(Game.instance.assets[R.TIP.RANDOM_MOVE], 32, 32)

  action : () ->
    ret = false
    plate = null
    # get random direct
    while plate == null
      rand = Random.nextInt() % InstrCommon.getDirectSize()
      direct = InstrCommon.getRobotDirect(rand)
      plate = Map.instance.getTargetPoision(@robot.currentPlate, direct.value)
    ret = @robot.move(direct.value, () => @onComplete())
    @setAsynchronous(ret != false)
    # @robot.onCmdComplete(RobotInstruction.MOVE, ret)

  clone : () ->
    obj = @copy(new RandomMoveInstruction(@robot))
    return obj

  mkDescription: () ->
    "移動可能なマスにランダムに移動します。<br>(消費エネルギー #{Config.Energy.MOVE} 消費フレーム #{Config.Frame.ROBOT_MOVE})"

  getIcon: () ->
    @icon.frame = 0
    return @icon
