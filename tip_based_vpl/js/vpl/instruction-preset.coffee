class RandomBranchInstruction extends BranchInstruction
  constructor : () -> 
    super()
    @threthold = 50
    # sliderタイトル, 初期値, 最小値, 最大値, 増大値
    parameter = new TipParameter("確率", 50, 0, 100, 1)

    @addParameter(parameter)

    #@setAsynchronous(true)

  action : () -> 
    r = Math.random()
    #func = () =>@onComplete(r*100 < @threthold) 
    #setTimeout(func, 500)
    r*100 < @threthold

  clone : () -> 
    obj = @copy(new RandomBranchInstruction())
    obj.threthold = @threthold
    obj

  onParameterChanged : (parameter) -> @threthold = parameter.value

  getIcon : () -> 
    new Icon(Resources.get("iconRandom"))
    
  mkDescription : () ->
    @threthold + "%の確率で青矢印に進みます。<br>" + (100 - @threthold) + "%の確率で赤矢印に進みます。"
