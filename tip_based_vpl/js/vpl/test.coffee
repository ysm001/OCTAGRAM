# test data
counter = 0
sprite = null

initializeTester = (sx, sy) ->
  sprite = new Sprite(48, 48)
  sprite.image = Resources.get("testObject")
  sprite.x = 640 - 48 
  sprite.y = 240
  LayerUtil.setOrder(sprite, 31)
  #Game.instance.currentScene.addChild(sprite)

  ###
  action = new CustomInstructionActionTip(new CounterIncrementInstruction())
  branch = new CustomInstructionBranchTip(new CounterBranchInstruction())
  actionTip = TipFactory.createActionTip(action)
  branchTip = TipFactory.createBranchTip(branch)
  returnTip = TipFactory.createReturnTip(sx, sy)
  stopTip   = TipFactory.createStopTip() 

  actionTip.description = "カウンタを1進めます。"
  branchTip.description = "カウンタが10未満であれば青矢印に進みます。</br>カウンタが10以上であれば赤矢印に進みます。"

  TipTable.addInstruction(new MoveUpInstruction(), "オブジェクトを上に動かします。", Resources.get("iconUp"))
  TipTable.addInstruction(new MoveDownInstruction(), "オブジェクトを下に動かします。", Resources.get("iconDown"))
  TipTable.addTip(actionTip)
  TipTable.addTip(branchTip)
  TipTable.addInstruction(new RandomBranchInstruction(), "50%の確率で青矢印に進みます。</br>50%の確率で赤矢印に進みます。", Resources.get("iconRandom"))
  TipTable.addTip(returnTip)
  TipTable.addTip(stopTip)

  for i in [0...5] then TipTable.addTip(stopTip)
  ###

generateTestCode = () ->
    action = new CustomInstructionActionTip(new CounterIncrementInstruction())#new CounterActionTip(null)
    branch = new CustomInstructionBranchTip(new CounterBranchInstruction())#new CounterIfTip(null)
    #action = new CounterActionTip(null)
    #branch = new CounterIfTip(null)
    actionTip = new SingleTransitionCodeTip(action)
    actionTip.description = "カウンタを1進めます"
    branchTip = new BranchTransitionCodeTip(branch)
    branchTip.description = "カウンタが10未満であれば青矢印に進みます。</br>カウンタが10以上であれば赤矢印に進みます。"
    stopTip = new CodeTip(new StopTip())
    #stopTip2 = new StopCodeTip(0,0,32,32,"test")
    board.putTip(4, 0, Direction.right, actionTip)
    board.putBranchTip(5,0,Direction.up,Direction.right,branchTip)
    board.putSingleTip(6,0,stopTip)
    #board.putSingleTip(6,0,stopTip2)

executeTestCode = () ->
  executer.execute()


class CounterIncrementInstruction extends ActionInstruction
  constructor : () ->
    super()
    @setAsynchronous(true)

  action : () -> 
    counter++
    console.log("increment : " + counter)
    setTimeout(@onComplete, 100)

  clone : () -> new CounterIncrementInstruction()

class MoveUpInstruction extends ActionInstruction
  constructor : () ->
    super()
    @setAsynchronous(true)

  action : () -> 
    console.log("moveup ")
    sprite.tl.setTimeBased()
    sprite.tl.moveBy(0,-100, 1000).then(() => @onComplete())

  clone : () -> new MoveUpInstruction()

class MoveLeftInstruction extends ActionInstruction
  constructor : () ->
    super()
    @setAsynchronous(true)

  action : () -> 
    console.log("moveleft ")
    sprite.tl.setTimeBased()
    sprite.tl.moveBy(-100,0, 1000).then(() => @onComplete())

  clone : () -> new MoveLeftInstruction()

class MoveDownInstruction extends ActionInstruction
  constructor : () ->
    super()
    @setAsynchronous(true)

  action : () -> 
    console.log("moveleft ")
    sprite.tl.setTimeBased()
    sprite.tl.moveBy(0,100, 1000).then(() => @onComplete())

  clone : () -> new MoveDownInstruction()

class CounterBranchInstruction extends BranchInstruction
  constructor : () -> super()
  action : () -> 
    console.log("if counter < 10 : ", counter < 10)
    counter < 10

  clone : () -> new CounterBranchInstruction()

class RandomBranchInstruction extends BranchInstruction
  constructor : () -> 
    super()
    @threthold = 50
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    parameter = new TipParameter("確率", 50, 0, 100, 1)

    @addParameter(parameter)

  action : () -> 
    r = Math.random()
    console.log("if random val < " + @threthold, r*100 < @threthold)
    r*100 < @threthold

  clone : () -> 
    obj = @copy(new RandomBranchInstruction())
    obj.threthold = @threthold
    obj

  onParameterChanged : (parameter) -> @threthold = parameter.value

  mkDescription : () ->
    @threthold + "%の確率で青矢印に進みます。</ br>" + (100 - @threthold) + "%の確率で赤矢印に進みます。"
