#####################################################
# Customチップ
#####################################################
class Instruction extends EventTarget
  constructor : () -> 
    super()
    @isAsynchronous = false
    @parameters = []

  onComplete : (result = null) ->
    @dispatchEvent(new InstructionEvent('completeExecution', {tip: this, result: result}))
    
  action : () ->
  execute : () -> @action()
  setAsynchronous : (async = true) -> @isAsynchronous = async

  addParameter : (param) -> 
    param.onParameterComplete = () => @onParameterComplete(param)
    param.onValueChanged = () => @onParameterChanged(param)
    param.mkLabel = () => @mkLabel(param)
    @parameters.push(param)

  mkDescription : () ->
  mkLabel : (value) -> value
  getIcon : () -> 

  setConstructorArgs : (args...) -> @constructorArgs = args

  onParameterChanged : (parameter) ->
  onParameterComplete : (parameter) ->

  copy : (obj) ->
    obj.isAsynchronous = @isAsynchronous
    obj.parameters = []
    for param in @parameters then obj.addParameter(param.clone())
    obj

  clone : () -> @copy(new Instruction())

  serialize : () -> {
    name: @constructor.name
    parameters : (param.serialize() for param in @parameters)
  }
  deserialize : (serializedVal) ->
    for param in serializedVal.parameters
      (target for target in @parameters when target.valueName == param.valueName)[0].deserialize(param)

class ActionInstruction extends Instruction
  constructor : () ->
    super()
  clone : () -> @copy(new ActionInstruction())

class BranchInstruction extends Instruction
  constructor : () -> super()
  action : () -> false
  clone : () -> @copy(new BranchInstruction())

octagram.Instruction = Instruction
octagram.ActionInstruction = ActionInstruction
octagram.BranchInstruction = BranchInstruction

