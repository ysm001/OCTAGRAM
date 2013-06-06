#####################################################
# Customチップ
#####################################################
class Instruction
  constructor : () -> 
    @isAsynchronous = false

  onComplete : () ->
    evt = document.createEvent('UIEvent', false)
    evt.initUIEvent('completeExecution', true, true)
    evt.tip = this
    document.dispatchEvent(evt)

  action : () ->
  execute : () -> @action()
  setAsynchronous : (async = true) -> @isAsynchronous = async

  clone : () -> new Instruction()

class ActionInstruction extends Instruction
  constructor : () ->
    super()
  clone : () -> new ActionInstruction()

class BranchInstruction extends Instruction
  constructor : () -> super()
  action : () -> false
  clone : () -> new BranchInstruction()

class CustomInstructionActionTip extends ActionTip
  constructor : (@instruction, next) -> super(next)
  action : () -> @instruction.execute()
  isAsynchronous : () -> @instruction.isAsynchronous 

  clone : () -> 
    @copy(new CustomInstructionActionTip(@instruction.clone(), @getNext()))

class CustomInstructionBranchTip extends BranchTip
  constructor : (@instruction, conseq, alter) -> super(conseq, alter)
  condition : () -> @instruction.execute()
  isAsynchronous : () -> @instruction.isAsynchronous 

  clone : () -> 
    @copy(new CustomInstructionBranchTip(@instruction.clone(), @getConseq, @getAlter()))
