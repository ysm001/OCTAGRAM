# test data
counter = 0

generateTestCode = () ->

executeTestCode = () -> Game.instance.vpl.executer.execute()

###
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
    r*100 < @threthold

  clone : () -> 
    obj = @copy(new RandomBranchInstruction())
    obj.threthold = @threthold
    obj

  onParameterChanged : (parameter) -> @threthold = parameter.value

  mkDescription : () ->
    @threthold + "%の確率で青矢印に進みます。</ br>" + (100 - @threthold) + "%の確率で赤矢印に進みます。"
###
