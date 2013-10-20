class CustomInstructionActionTip extends ActionTip
  constructor : (@instruction, next) ->
    super(next)

  action : () -> @instruction.execute()
  isAsynchronous : () -> @instruction.isAsynchronous 
  mkDescription : () -> @instruction.mkDescription()
  getIcon : () -> @instruction.getIcon()

  clone : () -> 
    @copy(new CustomInstructionActionTip(@instruction.clone(), @getNext()))

  serialize : () -> 
    serialized = super
    serialized["instruction"] = @instruction.serialize()
    serialized

  deserialize : (serializedVal) ->
    super(serializedVal)
    @instruction.deserialize(serializedVal.instruction)

class CustomInstructionBranchTip extends BranchTip
  constructor : (@instruction, conseq, alter) -> 
    super(conseq, alter)

  condition : () -> @instruction.execute()
  mkDescription : () -> @instruction.mkDescription()
  isAsynchronous : () -> @instruction.isAsynchronous 
  getIcon : () -> @instruction.getIcon()

  clone : () -> 
    @copy(new CustomInstructionBranchTip(@instruction.clone(), @getConseq, @getAlter()))

  serialize : () -> 
    serialized = super
    serialized["instruction"] = @instruction.serialize()
    serialized

  deserialize : (serializedVal) ->
    super(serializedVal)
    @instruction.deserialize(serializedVal.instruction)

octagram.CustomInstructionActionTip = CustomInstructionActionTip
octagram.CustomInstructionBranchTip = CustomInstructionBranchTip
