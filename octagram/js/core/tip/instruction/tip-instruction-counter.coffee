class Counter
  constructor : () -> @value = 0
  inc : (amount = 1)  -> @value += amount
  dec : (amount = -1) -> @value -= amount
  clone : () -> 
    obj = new Counter()
    obj.value = @value
    obj

class CounterIncrementInstruction extends ActionInstruction
  constructor : (@counters) ->
    super()
    @id = 0 
    @step = 1
    idParam = new TipParameter("カウンターID", 0, 0, @counters.length, 1)
    stepParam = new TipParameter("増加量", 1, 1, 100, 1)
    
    idParam.id = "id"
    stepParam.id = "step"

    @addParameter(idParam)
    @addParameter(stepParam)

  action : () -> @counters[@id].inc(@step)

  onParameterChanged : (parameter) -> 
    if parameter.id == "id" then @id = parameter.value
    else if parameter.id == "step" then @step =  parameter.value

  getIcon : () -> new Icon(Resources.get("iconRandom"))
  mkDescription : () ->
    "カウンター" + @id + "を" + @step + "増加させます。"

  clone : () -> @copy(new CounterIncrementInstruction(@counters))

class CounterDecrementInstruction extends ActionInstruction
  constructor : (@counters) ->
    super()
    @id = 0
    @step = 1
    idParam = new TipParameter("カウンターID", 0, 0, @counters.length, 1)
    stepParam = new TipParameter("減少量", 1, 1, 100, 1)
    
    idParam.id = "id"
    stepParam.id = "step"

    @addParameter(idParam)
    @addParameter(stepParam)

  action : () -> @counters[@id].dec(@step)

  onParameterChanged : (parameter) -> 
    if parameter.id == "id" then @id = parameter.value
    else if parameter.id == "step" then @step =  parameter.value

  getIcon : () -> new Icon(Resources.get("iconRandom"))
  mkDescription : () ->
    "カウンター" + @id + "を" + @step + "減少させます。"

  clone : () -> @copy(new CounterDecrementInstruction(@counters))

class CounterBranchInstruction extends BranchInstruction
  constructor : (@counters) ->
    super()
    @id = 0
    @threthold = 0
    idParam = new TipParameter("カウンターID", 0, 0, @counters.length, 1)
    thretholdParam = new TipParameter("閾値", 0, -100, 100, 1)
    
    idParam.id = "id"
    thretholdParam.id = "threthold"

    @addParameter(idParam)
    @addParameter(thretholdParam)

  action : () -> @counters[@id].value >= @threthold

  onParameterChanged : (parameter) -> 
    if parameter.id == "id" then @id = parameter.value
    else if parameter.id == "threthold" then @threthold =  parameter.value

  getIcon : () -> new Icon(Resources.get("iconRandom"))
  mkDescription : () ->
    "カウンター" + @id + "が" + @threthold + "以上ならば青矢印に進みます。<br>" +  
    "カウンター" + @id + "が" + @threthold + "未満ならば赤矢印に進みます。" 

  clone : () -> @copy(new CounterBranchInstruction(@counters))

class CounterPushInstruction extends ActionInstruction
  constructor : (@counters, @stack) ->
    super()
    @id = 0
    idParam = new TipParameter("カウンターID", 0, 0, @counters.length, 1)
    
    @addParameter(idParam)

  action : () -> @stack.push(@counters[@id])

  onParameterChanged : (parameter) ->  @id = parameter.value

  getIcon : () -> new Icon(Resources.get("iconRandom"))
  mkDescription : () ->
    "カウンター" + @id + "の値を" + "スタックにプッシュします。"

  clone : () -> @copy(new CounterPushInstruction(@counters))

class CounterPopInstruction extends ActionInstruction
  constructor : (@counters, @stack) ->
    super()
    @id = 0 
    idParam = new TipParameter("カウンターID", 0, 0, @counters.length, 1)
    
    @addParameter(idParam)

  action : () -> @counters[@id] = @stack.pop()

  onParameterChanged : (parameter) ->  @id = parameter.value

  getIcon : () -> new Icon(Resources.get("iconRandom"))
  mkDescription : () ->
    "スタックからxをポップして, カウンター" + @id + "に代入します。"

  clone : () -> @copy(new CounterPushInstruction(@counters))

octagram.Counter = Counter
octagram.CounterIncrementInstruction = CounterIncrementInstruction
octagram.CounterDecrementInstruction = CounterDecrementInstruction
octagram.CounterBranchInstruction = CounterBranchInstruction
octagram.CounterPushInstruction = CounterPushInstruction
octagram.CounterPopInstruction = CounterPopInstruction
