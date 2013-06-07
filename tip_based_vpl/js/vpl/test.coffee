# test data
counter = 0

generateTestCode = () ->
  actionTip = TipFactory.createInstructionTip(new MoveInstruction()) 
  branchTip = TipFactory.createInstructionTip(new RandomBranchInstruction()) 
  stopTip   = TipFactory.createStopTip() 

  # アクションチップの設定
  # x, y, 進行方向、チップ
  Game.instance.vpl.cpu.putTip(4, 0, Direction.right, actionTip)

  # 条件分岐チップの設定
  # x, y, 進行方向(true), 進行方向(false), チップ
  Game.instance.vpl.cpu.putBranchTip(5,0,Direction.up,Direction.right,branchTip)

  # 遷移先の無いチップの設定
  # x, y, チップ
  Game.instance.vpl.cpu.putSingleTip(6,0,stopTip)

executeTestCode = () -> Game.instance.vpl.executer.execute()
