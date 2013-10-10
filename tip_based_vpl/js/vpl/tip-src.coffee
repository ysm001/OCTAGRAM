#####################################################
# チップ選択時のエフェクト
#####################################################
class SelectedEffect extends ImageSprite
  constructor : () ->
    super(Resources.get("selectedEffect"))
    @visible = false
    @touchEnabled = false

  show : (parent) ->
    @visible = true
    parent.addChild(this)

  hide : () ->
    @visible = false
    @parentNode.removeChild(this)

class ExecutionEffect extends ImageSprite
  @fadeTime = 400

  constructor : () ->
    super(Resources.get("execEffect"))
    @visible = false
    @busy = false
    @tl.setTimeBased()

  show : (parent) ->
    @tl.clear()
    @opacity = 1
    parent.addChild(this) if !@busy && !@visible
    @visible = true

  hide : () ->
    if @visible
      @tl.clear()
      @busy = true
      @tl.fadeOut(ExecutionEffect.fadeTime).then(@_hide)

  _hide : () =>
    @busy = false
    @visible = false
    @parentNode.removeChild(this)

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

#####################################################
# Icon 
#####################################################
class Icon extends Sprite
  constructor : (icon, width, height) ->
    w = if width? then width else icon.width
    h = if height? then height else icon.height
    super(w, h)

    @image = icon
    @parent = null
    @hidden = true

    @touchEnabled = false

  fitPosition : () ->
    if @parentNode?
      @moveTo(@parentNode.getWidth()/2 - @width/2, 
        @parentNode.getWidth()/2 - @height/2)

  clone : () -> 
    obj = new Icon(@image, @width, @height)
    obj.frame = @frame 
    obj

#####################################################
# Customチップ
#####################################################
class Instruction extends EventTarget
  constructor : () -> 
    super()
    @isAsynchronous = false
    @parameters = []

  onComplete : (result = null) ->
    ###
    evt = document.createEvent('UIEvent', false)
    evt.initUIEvent('completeExecution', true, true)
    ###
    @dispatchEvent(new InstructionEvent('completeExecution', {tip: this, result: result}))
    ###
    evt.tip = this
    evt.result = result
    ###
    #document.dispatchEvent(evt)

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
    idParam = new TipParameter("$B%+%&%s%?!<(BID", 0, 0, @counters.length, 1)
    stepParam = new TipParameter("$BA}2CNL(B", 1, 1, 100, 1)
    
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
    "$B%+%&%s%?!<(B" + @id + "$B$r(B" + @step + "$BA}2C$5$;$^$9!#(B"

  clone : () -> @copy(new CounterIncrementInstruction(@counters))

class CounterDecrementInstruction extends ActionInstruction
  constructor : (@counters) ->
    super()
    @id = 0
    @step = 1
    idParam = new TipParameter("$B%+%&%s%?!<(BID", 0, 0, @counters.length, 1)
    stepParam = new TipParameter("$B8:>/NL(B", 1, 1, 100, 1)
    
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
    "$B%+%&%s%?!<(B" + @id + "$B$r(B" + @step + "$B8:>/$5$;$^$9!#(B"

  clone : () -> @copy(new CounterDecrementInstruction(@counters))

class CounterBranchInstruction extends BranchInstruction
  constructor : (@counters) ->
    super()
    @id = 0
    @threthold = 0
    idParam = new TipParameter("$B%+%&%s%?!<(BID", 0, 0, @counters.length, 1)
    thretholdParam = new TipParameter("$BogCM(B", 0, -100, 100, 1)
    
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
    "$B%+%&%s%?!<(B" + @id + "$B$,(B" + @threthold + "$B0J>e$J$i$P@DLp0u$K?J$_$^$9!#(B<br>" +  
    "$B%+%&%s%?!<(B" + @id + "$B$,(B" + @threthold + "$BL$K~$J$i$P@VLp0u$K?J$_$^$9!#(B" 

  clone : () -> @copy(new CounterBranchInstruction(@counters))

class CounterPushInstruction extends ActionInstruction
  constructor : (@counters, @stack) ->
    super()
    @id = 0
    idParam = new TipParameter("$B%+%&%s%?!<(BID", 0, 0, @counters.length, 1)
    
    @addParameter(idParam)

  action : () -> @stack.push(@counters[@id])

  onParameterChanged : (parameter) ->  @id = parameter.value

  getIcon : () -> new Icon(Resources.get("iconRandom"))
  mkDescription : () ->
    "$B%+%&%s%?!<(B" + @id + "$B$NCM$r(B" + "$B%9%?%C%/$K%W%C%7%e$7$^$9!#(B"

  clone : () -> @copy(new CounterPushInstruction(@counters))

class CounterPopInstruction extends ActionInstruction
  constructor : (@counters, @stack) ->
    super()
    @id = 0 
    idParam = new TipParameter("$B%+%&%s%?!<(BID", 0, 0, @counters.length, 1)
    
    @addParameter(idParam)

  action : () -> @counters[@id] = @stack.pop()

  onParameterChanged : (parameter) ->  @id = parameter.value

  getIcon : () -> new Icon(Resources.get("iconRandom"))
  mkDescription : () ->
    "$B%9%?%C%/$+$i(Bx$B$r%]%C%W$7$F(B, $B%+%&%s%?!<(B" + @id + "$B$KBeF~$7$^$9!#(B"

  clone : () -> @copy(new CounterPushInstruction(@counters))

class StackMachine 
  constructor : () ->
    @stack = []

  pop : () -> @stack.pop()
  push : (val) -> @stack.push(val)

  binaryOp : (op) ->
    if @stack.length > 1
      @push(op(@pop(), @pop()))

  unaryOp : (op) ->
    if @stack.length > 0
      @push(op(@pop()))

  # binary operations
  add : () -> @binaryOp((y, x) -> x + y)
  sub : () -> @binaryOp((y, x) -> x - y)
  mul : () -> @binaryOp((y, x) -> x * y)
  div : () -> @binaryOp((y, x) -> x / y)
  mod : () -> @binaryOp((y, x) -> x % y)
  xor : () -> @binaryOp((y, x) -> x ^ y)
  grt : () -> @binaryOp((y, x) -> if x > y then 1 else 0)
  swap : () -> 
    if @stack.length > 1
      x = @pop()
      y = @pop()
      @push(y)
      @push(x)

  # unary operations
  not : () -> @unaryOp(if @stack.pop() == 0 then 1 else 0) 
  dup : () ->
    if @stack.length > 0
      val = @pop()
      @push(val)
      @push(val)

  rot : () ->
    if @stack.length > 3
      x = @pop()
      y = @pop()
      z = @pop()
      @push(y)
      @push(z)
      @push(x)

  # branch operations
  bnz : () ->
    if @stack? then @pop() != 0
    else false

  # I/O operations
  input : () -> @push(window.prompt())
  toString : () ->
    str = ""
    while @stack?
      str += String.fromCharCode(@pop())
    str

class StackAddInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.add()
  clone : () -> @copy(new StackAddInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y$B$r%]%C%W$7$F(B, x+y$B$NCM$r%W%C%7%e$9$k!#(B"

class StackSubInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.sub()
  clone : () -> @copy(new StackSubInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y$B$r%]%C%W$7$F(B, x-y$B$NCM$r%W%C%7%e$9$k!#(B"

class StackMulInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.mul()
  clone : () -> @copy(new StackMulInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y$B$r%]%C%W$7$F(B, x+y$B$NCM$r%W%C%7%e$9$k!#(B"

class StackDivInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.div()
  clone : () -> @copy(new StackDivInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y$B$r%]%C%W$7$F(B, x/y$B$NCM$r%W%C%7%e$9$k!#(B"

class StackModInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.mod()
  clone : () -> @copy(new StackModInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y$B$r%]%C%W$7$F(B, x$B$r(By$B$G3d$C$?;~$NM>$j$r%W%C%7%e$9$k!#(B"

class StackXorInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.xor()
  clone : () -> @copy(new StackXorInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y$B$r%]%C%W$7$F(B, x$B$H(By$B$NGSB>E*O@M}OB$NCM$r%W%C%7%e$9$k!#(B"

class StackGrtInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.grt()
  clone : () -> @copy(new StackGrtInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y$B$r%]%C%W$7$F(B, x>y$B$J$i$P(B1$B$r%W%C%7%e$9$k!#(B<br>$B$=$&$G$J$1$l$P(B0$B$r%W%C%7%e$9$k!#(B"

class StackSwpInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.swap()
  clone : () -> new StackSwpInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y$B$r%]%C%W$7$F(B, y, x$B$N=g$G%W%C%7%e$9$k!#(B"

class StackNotInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.not()
  clone : () -> @copy(new StackNotInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx$B$r%]%C%W$7$F(B, x$B$,(B0$B$J$i$P(B1$B$r%W%C%7%e$9$k!#(B<br>$B$=$&$G$J$1$l$P(B0$B$r%W%C%7%e$9$k!#(B"

class StackDupInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.dup()
  clone : () -> @copy(new StackDupInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx$B$r%]%C%W$7$F(B, x$B$r(B2$B2s%W%C%7%e$9$k!#(B"

class StackRotInstruction extends ActionInstruction
  constructor : (@stack) -> super
  action : () -> @stack.rot()
  clone : () -> @copy(new StackRotInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx, y, z$B$r%]%C%W$7$F(B, y, z, x$B$N=g$G%W%C%7%e$9$k!#(B"

class StackBnzInstruction extends BranchInstruction
  constructor : (@stack) -> super
  action : () -> @stack.bnz()
  clone : () -> @copy(new StackBnzInstruction(@stack))
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "$B%9%?%C%/A`:nL?Na(B($B>e5i<T8~$1(B)<br>" + "$B%9%?%C%/$+$i(Bx$B$r%]%C%W$7$F(B, x$B$,(B1$B$J$i$P@DLp0u$K?J$`!#(B<br>$B$=$&$G$J$1$l$P@VLp0u$K?J$`!#(B" 

#####################################################
# チップ関連
#####################################################

#####################################################
# 座標
#####################################################
class Point
  constructor : (@x, @y) ->

#####################################################
# チップ 
#####################################################
class Tip
  constructor : () ->
    @transitions = {}
    @index = {x:0, y:0}
  addTransition : (name, dst) -> @transitions[name] = dst
  getTransition : (name) -> @transitions[name]
  clone : () -> new Tip() 
  copy : (obj) ->
    obj.index.x = @index.x
    obj.index.y = @index.y
    for t of @transitions
      obj.transitions[t] = @transitions[t]
    obj
  execute : () -> null

  mkDescription : () -> TipUtil.tipToMessage(this) 

  serialize : () ->
    name:  @constructor.name
    index: @index
    transitions: @transitions

  deserialize : (serializedVal) ->
    @transitions = serializedVal.transitions
    @index = serializedVal.index

#####################################################
# Emptyチップ
# 何も命令の入っていないチップ
# 遷移も持たない
#####################################################
class EmptyTip extends Tip
  constructor : () -> super()
  clone : () -> new EmptyTip()

class StopTip extends Tip
  constructor : () -> super()
  clone : () -> new StopTip()

#####################################################
# 単一の遷移(next)しかもたないチップ
#####################################################
class SingleTransitionTip extends Tip 
  constructor : (next) ->
    super()
    @setNext(next)

  setNext : (next) ->
    @next = next
    @addTransition("next", @next)

  getNext : () -> @getTransition("next")

  execute : () -> @getTransition("next")
  clone : () -> @copy(new SingleTransitionTip(@getNext()))

#####################################################
# Thinkチップ
# 特殊チップ(nop, sub routine etc...)
#####################################################
class ThinkTip extends SingleTransitionTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new ThinkTip(@getNext()))

#####################################################
# Nopチップ
#####################################################
class NopTip extends ThinkTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new NopTip(@getNext()))

#####################################################
# 何もしないで次へ遷移するチップ
# Return ,Startチップがこれに該当
#####################################################
class StartTip extends SingleTransitionTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new StartTip(@getNext()))

class ReturnTip extends SingleTransitionTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new ReturnTip(@getNext()))

class WallTip extends SingleTransitionTip
  constructor : (next) -> super(next)
  clone : () -> @copy(new WallTip(@getNext()))

#####################################################
# Branchチップ
# 条件分岐を行うチップ
# 二つの遷移(conseq,alter)を持つ
# 条件を満たせばconseq, 満たさなければalterへ遷移
#####################################################
class BranchTip extends Tip 
  constructor : (conseq, alter) ->
    super()
    @addTransition("conseq", conseq)
    @addTransition("alter", alter)

  condition : () -> true

  execute : () ->
    super
    if @condition() then @getTransition("conseq") 
    else @getTransition("alter")
  
  setConseq : (conseq) -> @addTransition("conseq", conseq)
  setAlter : (alter) -> @addTransition("alter", alter)
  getConseq : () -> @getTransition("conseq")
  getAlter : () -> @getTransition("alter")

  clone : () -> @copy(new BranchTip(@getConseq(), @getAlter()))

#####################################################
# Actionチップ
# アクションを実行して次へ遷移するチップ
#####################################################
class ActionTip extends SingleTransitionTip 
  constructor : (next) -> super(next)

  action : () ->

  execute : () ->
    @action()
    @getTransition("next")

  clone : () -> tip = @copy(new ActionTip(@getNext()))

#####################################################
# SingleTransitionTipのCV 
#####################################################
class TipParameter
  constructor : (@valueName, @value, @min, @max, @step, @id) ->
    @text = ""

  setValue : (value) ->
    @value = value
    @text = toString()
    @onValueChanged()

  getValue : () -> @value

  onValueChanged : () ->
  onParameterComplete : () ->
  mkLabel : () ->

  #clone : () -> $.extend(true, {}, @)
  clone : () -> @copy(new TipParameter(@valueName, @value, @min, @max, @step))
  
  copy : (obj) ->
    obj.valueName = @valueName
    obj.value = @value
    obj.min = @min
    obj.max = @max
    obj.step = @step
    obj.id = @id
    obj

  toString : () -> @value.toString()

  serialize : () -> {valueName: @valueName, value: @value}
  deserialize : (serializedVal) -> @setValue(serializedVal.value)

#####################################################
# CV(Control View)関連 
#####################################################

#####################################################
# 進行方向 
#####################################################
class Direction
  @left      = new Point(-1, 0)
  @right     = new Point( 1, 0)
  @up        = new Point( 0,-1)
  @down      = new Point( 0, 1)
  @leftUp    = new Point(-1,-1)
  @leftDown  = new Point(-1, 1)
  @rightUp   = new Point( 1,-1)
  @rightDown = new Point( 1, 1)

  @toDirection : (x, y) -> new Point(x, y)

#####################################################
# チップのCV 
#####################################################
class CodeTip extends SpriteGroup
  @selectedEffect = null 
  @clonedTip = null

  constructor : (@code) ->
    super(TipUtil.tipToImage(@code))
    @immutable   = @code instanceof WallTip || @code instanceof StartTip
    @description = @code.mkDescription() 

    @isTransitionSelect = false
    @icon = @getIcon()

    @dragMode = false
    @isFirstClick = false
    @dragStartX = 0
    @dragStartY = 0

    @parameters = if @code.instruction? then @code.instruction.parameters 

    @addChild(@sprite)

    if @icon?
      @addChild(@icon)
      @icon.fitPosition()

    @executionEffect = new ExecutionEffect(this)
    CodeTip.selectedEffect = new SelectedEffect() if !CodeTip.selectedEffect?

  isInnerTip : (x, y) ->
    pos = @getAbsolutePosition()
    range = @getWidth()
    xs = pos.x
    xe = pos.x + range 
    ys = pos.y
    ye = pos.y + range
    x>xs && x<xe && y>ys && y<ye

  select : () =>
    @topGroup().ui.help.setText(@description)
    @isFirstClick = !@isSelected()
    @showSelectedEffect()

  unselect : () ->
    @topGroup().help.setText("")
    @hideSelectedEffect()

  execute : () -> if @code? then @code.execute() else null

  createGhost : () ->
    CodeTip.clonedTip.hide() if CodeTip.clonedTip?

    tip = @clone()
    tip.setOpacity(0.5)
    tip.moveTo(@x, @y)
    tip.sprite.touchEnabled = false
    tip

  ontouchstart : (e) =>
    @isTransitionSelect = !@isInnerTip(e.x, e.y)
    if !@isTransitionSelect
      if @dragMode && CodeTip.clonedTip? 
        CodeTip.clonedTip.hide()
      @dragMode = false
      @select()

  ontouchmove : (e) => 
    if !@isTransitionSelect
      if !@dragMode && !@immutable 
        @dragMode = true
        @dragStart(e)
      @dragged(e) 

  ontouchend : (e) => 
    if !@immutable
      if !@dragMode && @isSelected() && !@isFirstClick then @doubleClicked()
      else if @dragMode then @dragEnd(e)
    CodeTip.selectedInstance = this

  dragStart : (e) -> 
    CodeTip.clonedTip = @createGhost()
    CodeTip.clonedTip.show(@parentNode)
    @dragStartX = e.x
    @dragStartY = e.y

  dragged : (e) -> 
    if CodeTip.clonedTip?
      dx = e.x - @dragStartX
      dy = e.y - @dragStartY
      CodeTip.clonedTip.moveTo(@x + dx, @y + dy)

  dragEnd : (e) -> 
    @dragMode = false
    if CodeTip.clonedTip?
      pos = CodeTip.clonedTip.getAbsolutePosition()
      @topGroup().cpu.insertTipOnNearestPosition(pos.x, pos.y, CodeTip.clonedTip)
      CodeTip.clonedTip.hide()

  doubleClicked : () -> @showConfigWindow() 

  showConfigWindow : () -> 
    panel = new ParameterConfigPanel(@topGroup())
    panel.show(this)

  isSelected : () -> 
    CodeTip.selectedEffect.parentNode == this

  showExecutionEffect : () -> @executionEffect.show(this)
  hideExecutionEffect : () -> @executionEffect.hide()
  showSelectedEffect : () -> 
    if !@isSelected() then CodeTip.selectedEffect.show(this)
  hideSelectedEffect : () -> CodeTip.selectedEffect.hide()

  isAsynchronous : () -> @code.isAsynchronous? && @code.isAsynchronous()

  setIcon : (icon) -> 
    @icon = icon
    @icon.fitPosition()

  getIcon : () ->
    @icon = 
      if @code.getIcon? then @code.getIcon() 
      else 
        icon = TipUtil.tipToIcon(@code)
        if icon? then new Icon(icon) else null
    @icon

  setDescription : (desc) ->
    @description = desc
    @onDescriptionChanged()

  onDescriptionChanged : () ->
    if @isSelected() then @topGroup().ui.help.setText(@description)

  setIndex : (idxX, idxY) -> @code.index = {x: idxX, y: idxY}
  getIndex : () -> @code.index

  show : (parent) -> parent.addChild(this) if parent?
  hide : (parent) -> @parentNode.removeChild(this) if @parentNode?

  clone : () -> new CodeTip(@code.clone())

  copy : (obj) ->
    obj.description = @description
    obj.icon = @icon.clone() if @icon?

    obj

  serialize : () -> 
    {
      name: @constructor.name
      code: @code.serialize()
    }
  deserialize : (serializedVal) ->
    @code.deserialize(serializedVal.code)
    @setDescription(@code.mkDescription())

#####################################################
# SingleTransitionTipのCV 
#####################################################
class SingleTransitionCodeTip extends CodeTip
  constructor : (code) ->
    super(code)
    @trans = null

  setNext : (x, y, dst) -> 
    @trans.hide() if @trans?
    @trans = new NormalTransition(this, dst)
    @trans.show(this)
    @code.setNext({x:x, y:y}) 

  getNextDir : () ->
    next = @code.getNext()
    if !next? then null
    else Direction.toDirection(next.x - @code.index.x, 
      next.y - @code.index.y)

  #clone : () -> @copy(new SingleTransitionCodeTip(@code.clone()))
  clone : () -> @copy(new SingleTransitionCodeTip(@code.clone()))

#####################################################
# SingleTransitionTipのCV 
#####################################################
class BranchTransitionCodeTip extends CodeTip
  constructor : (code) ->
    super(code)
    @conseqTrans = null
    @alterTrans = null

  setConseq : (x, y, dst) ->
    @conseqTrans.hide() if @conseqTrans?
    @conseqTrans = new NormalTransition(this, dst)
    @conseqTrans.show(this) 
    @code.setConseq({x:x, y:y})

  setAlter : (x, y, dst) ->
    @alterTrans.hide() if @alterTrans?
    @alterTrans = new AlterTransition(this, dst)
    @alterTrans.show(this) 
    @code.setAlter({x:x, y:y})

  getConseqDir : () ->
    next = @code.getConseq()
    if !next? then null
    else Direction.toDirection(next.x - @code.index.x, 
      next.y - @code.index.y)

  getAlterDir : () ->
   next = @code.getAlter()
   if !next? then null
   else Direction.toDirection(next.x - @code.index.x, 
     next.y - @code.index.y)

  clone : () -> @copy(new BranchTransitionCodeTip(@code.clone()))

#####################################################
# SingleTransitionTipのCV 
#####################################################
class JumpTransitionCodeTip extends CodeTip
  constructor : (code) -> super(code)
  setNext : (x, y) -> @code.setNext({x:x, y:y})
  clone : () -> @copy(new JumpTransitionCodeTip(@code.clone()))
