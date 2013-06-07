#####################################################
# Customチップ
#####################################################
class Instruction
  constructor : () -> 
    @isAsynchronous = false
    @parameters = []

  onComplete : () ->
    evt = document.createEvent('UIEvent', false)
    evt.initUIEvent('completeExecution', true, true)
    evt.tip = this
    document.dispatchEvent(evt)

  action : () ->
  execute : () -> @action()
  setAsynchronous : (async = true) -> @isAsynchronous = async

  addParameter : (param) -> 
    param.onValueChanged = () => @onParameterChanged(param)
    param.onParameterComplete = () => @onParameterComplete(param)
    param.mkLabel = () => @mkLabel(param)
    @parameters.push(param)

  mkDescription : () ->
  mkLabel : (value) -> value
  getIcon : () -> 

  onParameterChanged : (parameter) ->
  onParameterComplete : (parameter) ->

  copy : (obj) ->
    obj.isAsynchronous = @isAsynchronous
    obj.parameters = []
    for param in @parameters then obj.addParameter(param.clone())
    obj

  clone : () -> @copy(new Instruction())

class ActionInstruction extends Instruction
  constructor : () ->
    super()
  clone : () -> @copy(new ActionInstruction())

class BranchInstruction extends Instruction
  constructor : () -> super()
  action : () -> false
  clone : () -> @copy(new BranchInstruction())

class CustomInstructionActionTip extends ActionTip
  constructor : (@instruction, next) ->
    super(next)

  action : () -> @instruction.execute()
  isAsynchronous : () -> @instruction.isAsynchronous 
  mkDescription : () -> @instruction.mkDescription()
  getIcon : () -> @instruction.getIcon()

  clone : () -> 
    @copy(new CustomInstructionActionTip(@instruction.clone(), @getNext()))

class CustomInstructionBranchTip extends BranchTip
  constructor : (@instruction, conseq, alter) -> 
    super(conseq, alter)

  condition : () -> @instruction.execute()
  mkDescription : () -> @instruction.mkDescription()
  isAsynchronous : () -> @instruction.isAsynchronous 
  getIcon : () -> @instruction.getIcon()

  clone : () -> 
    @copy(new CustomInstructionBranchTip(@instruction.clone(), @getConseq, @getAlter()))
