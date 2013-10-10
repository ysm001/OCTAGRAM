class TipFactory
  @createReturnTip : (sx, sy) ->
    tip = new JumpTransitionCodeTip(new ReturnTip()) 
    tip.setNext(sx, sy) 
    tip

  @createWallTip   : (sx, sy) ->
    tip = new JumpTransitionCodeTip(new WallTip()) 
    tip.setNext(sx, sy) 
    tip

  @createStartTip   : () -> new SingleTransitionCodeTip(new StartTip())
  @createStopTip    : (sx, sy) -> new CodeTip(new StopTip())
  @createEmptyTip   : (sx, sy) -> new CodeTip(new EmptyTip())
  @createActionTip  : (code) -> new SingleTransitionCodeTip(code)
  @createBranchTip  : (code) -> new BranchTransitionCodeTip(code)
  @createThinkTip   : (code) -> new SingleTransitionCodeTip(code)
  @createNopTip : () -> TipFactory.createThinkTip(new NopTip())
  @createInstructionTip : (inst) -> 
    if inst instanceof ActionInstruction
      TipFactory.createActionTip(new CustomInstructionActionTip(inst))
    else if inst instanceof BranchInstruction
      TipFactory.createBranchTip(new CustomInstructionBranchTip(inst))
    else console.log("error : invalid instruction type.")
