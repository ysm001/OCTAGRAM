
class SupplyInstruction extends ActionInstruction
  ###
    Shot Instruction
  ###

  constructor: (@robot) ->
    super
    @icon = new Icon(Game.instance.assets[R.TIP.LIFE], 32, 32)
    @setAsynchronous(true)

  action : () ->
    ret = @robot.supply(() => @onComplete())
    @setAsynchronous(ret != false)

  clone : () ->
    obj = @copy(new SupplyInstruction(@robot))
    return obj

  mkDescription: () ->
     "現在いるマスからエネルギーを最大#{Robot.STEAL_ENERGY_UNIT}補給します。<br>#{Robot.STEAL_ENERGY_UNIT}未満しか残っていない場合はその分補給します。<br>(消費エネルギー 0 消費フレーム #{Config.Frame.SUPPLY}フレーム)"

  mkLabel: (parameter) ->
    @tipInfo.getLabel(parameter.id)

  getIcon: () ->
    return @icon
        



