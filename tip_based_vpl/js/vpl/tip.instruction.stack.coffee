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
  constructor : (@stack) ->
  action : () -> @stack.add()
  clone : () -> new StackAddInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x+yの値をプッシュする。"

class StackSubInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.sub()
  clone : () -> new StackSubInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x-yの値をプッシュする。"

class StackMulInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.mul()
  clone : () -> new StackMulInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x+yの値をプッシュする。"

class StackDivInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.div()
  clone : () -> new StackDivInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x/yの値をプッシュする。"

class StackModInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.mod()
  clone : () -> new StackModInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, xをyで割った時の余りをプッシュする。"

class StackXorInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.xor()
  clone : () -> new StackXorInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, xとyの排他的論理和の値をプッシュする。"

class StackGrtInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.grt()
  clone : () -> new StackGrtInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x>yならば1をプッシュする。<br>そうでなければ0をプッシュする。"

class StackSwpInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.swap()
  clone : () -> new StackSwpInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, y, xの順でプッシュする。"

class StackNotInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.not()
  clone : () -> new StackNotInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからxをポップして, xが0ならば1をプッシュする。<br>そうでなければ0をプッシュする。"

class StackDupInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.dup()
  clone : () -> new StackDupInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからxをポップして, xを2回プッシュする。"

class StackRotInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.rot()
  clone : () -> new StackRotInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからx, y, zをポップして, y, z, xの順でプッシュする。"

class StackBnzInstruction extends BranchInstruction
  constructor : (@stack) ->
  action : () -> @stack.bnz()
  clone : () -> new StackBnzInstruction(@stack)
  getIcon : () ->  new Icon(Resources.get("iconRandom"))
  mkDescription : () -> "スタック操作命令(上級者向け)<br>" + "スタックからxをポップして, xが1ならば青矢印に進む。<br>そうでなければ赤矢印に進む。" 
