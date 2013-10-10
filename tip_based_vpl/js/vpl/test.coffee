generateTestCode = () ->
    player = Game.instance.scene.world.player
    # instructions
    moveInstruction = new MoveInstruction(player)
    moveRightInstruction = moveInstruction.clone()
    moveRightInstruction._id = 0

    moveRightUpInstruction = moveInstruction.clone()
    moveRightUpInstruction._id = 1

    moveRightDownInstruction = moveInstruction.clone()
    moveRightDownInstruction._id = 2

    moveLeftInstruction = moveInstruction.clone()
    moveLeftInstruction._id = 3

    moveLeftUpInstruction = moveInstruction.clone()
    moveLeftUpInstruction._id = 4

    moveLeftDownInstruction = moveInstruction.clone()
    moveLeftDownInstruction._id = 5

    pickupInstruction = new PickupInstruction(player)
    pickupNormalInstruction = pickupInstruction.clone()
    pickupNormalInstruction._id = 0

    pickupWideInstruction = pickupInstruction.clone()
    pickupWideInstruction._id = 1

    pickupDualInstruction = pickupInstruction.clone()
    pickupDualInstruction._id = 2

    shotInstruction = new ShotInstruction(player)
    shotNormalInstruction = shotInstruction.clone()
    shotNormalInstruction._id = 0

    searchDirectRobotBranchInstruction = new SearchDirectRobotBranchInstruction(player)
    searchDirectLeftRobotBranchInstruction = searchDirectRobotBranchInstruction.clone()
    searchDirectLeftRobotBranchInstruction._id = 3
    searchDirectLeftRobotBranchInstruction.lenght = 4

    currentDirectBranchInstruction = new CurrentDirectBranchInstruction(player)
    currentDirectLeftBranchInstruction = currentDirectBranchInstruction.clone()
    currentDirectLeftBranchInstruction._id = 3

    holdBulletBranchInstruction = new HoldBulletBranchInstruction(player)
    holdBullet1BranchInstruction = holdBulletBranchInstruction.clone()
    holdBullet1BranchInstruction._id = 0
    holdBullet1BranchInstruction.bulletSize = 1

    # tips
    left1Tip = TipFactory.createInstructionTip(moveLeftInstruction.clone())
    left2Tip = TipFactory.createInstructionTip(moveLeftInstruction.clone())

    leftUpTip = TipFactory.createInstructionTip(moveLeftUpInstruction.clone())

    rightUpTip = TipFactory.createInstructionTip(moveRightUpInstruction.clone())

    rightDownTip = TipFactory.createInstructionTip(moveRightDownInstruction.clone())

    randomBranchInstruction = new RandomBranchInstruction()
    randomBranchInstruction.threthold = 5 
    random1Tip = TipFactory.createInstructionTip(randomBranchInstruction)
    randomBranchInstruction = randomBranchInstruction.clone()
    randomBranchInstruction.threthold = 80
    random2Tip = TipFactory.createInstructionTip(randomBranchInstruction)
    randomBranchInstruction = randomBranchInstruction.clone()
    randomBranchInstruction.threthold = 80
    random3Tip = TipFactory.createInstructionTip(randomBranchInstruction)
    randomBranchInstruction = randomBranchInstruction.clone()
    randomBranchInstruction.threthold = 90
    random4Tip = TipFactory.createInstructionTip(randomBranchInstruction)

    pickupNormalTip = TipFactory.createInstructionTip(pickupNormalInstruction.clone())

    shotNormalTip = TipFactory.createInstructionTip(shotNormalInstruction.clone())

    returnTip1 = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    returnTip2 = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    returnTip3 = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    returnTip4 = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    returnTip5 = TipFactory.createReturnTip(Environment.startX, Environment.startY)

    searchLeftTip = TipFactory.createInstructionTip(searchDirectLeftRobotBranchInstruction.clone())
    currentLeftTip = TipFactory.createInstructionTip(currentDirectLeftBranchInstruction.clone())
    holdTip = TipFactory.createInstructionTip(holdBullet1BranchInstruction.clone())

    # 条件分岐チップの設定
    # x, y, 進行方向(true), 進行方向(false), チップ
    Game.instance.vpl.vm.cpu.putBranchTip(4,0,Direction.leftDown,Direction.rightDown,searchLeftTip)
    Game.instance.vpl.vm.cpu.putBranchTip(3,1,Direction.leftDown,Direction.rightDown,currentLeftTip)
    Game.instance.vpl.vm.cpu.putBranchTip(2,2,Direction.leftDown,Direction.rightDown,holdTip)
    Game.instance.vpl.vm.cpu.putTip(4, 2, Direction.down, left1Tip)
    Game.instance.vpl.vm.cpu.putTip(3, 3, Direction.right, pickupNormalTip)
    Game.instance.vpl.vm.cpu.putSingleTip(4, 3,returnTip4)
    Game.instance.vpl.vm.cpu.putTip(1, 3, Direction.down, shotNormalTip)
    Game.instance.vpl.vm.cpu.putSingleTip(1, 4,returnTip5)

    Game.instance.vpl.vm.cpu.putBranchTip(5,1,Direction.right,Direction.down,random1Tip)
    Game.instance.vpl.vm.cpu.putBranchTip(5,2,Direction.right,Direction.down,random2Tip)
    Game.instance.vpl.vm.cpu.putBranchTip(5,3,Direction.right,Direction.down,random3Tip)
    Game.instance.vpl.vm.cpu.putBranchTip(5,4,Direction.right,Direction.down,random4Tip)

    Game.instance.vpl.vm.cpu.putTip(6, 1, Direction.rightDown, left2Tip)
    Game.instance.vpl.vm.cpu.putSingleTip(7, 2,returnTip1)
    Game.instance.vpl.vm.cpu.putTip(6, 2, Direction.right, leftUpTip)
    Game.instance.vpl.vm.cpu.putTip(6, 3, Direction.rightUp, rightUpTip)
    Game.instance.vpl.vm.cpu.putTip(6, 4, Direction.right, rightDownTip)
    Game.instance.vpl.vm.cpu.putSingleTip(7, 4,returnTip2)
    Game.instance.vpl.vm.cpu.putSingleTip(5, 5,returnTip3)
    # 遷移先の無いチップの設定
    # x, y, チップ
    #Game.instance.vpl.vm.cpu.putSingleTip(6,0,stopTip)

executeTestCode = () -> Game.instance.vpl.vm.executer.execute()

saveTestCode = () -> Game.instance.vpl.vm.cpu.save("test")
loadTestCode = () -> Game.instance.vpl.vm.cpu.load("test")
