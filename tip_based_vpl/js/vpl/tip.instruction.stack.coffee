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

class StackSubInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.sub()
  clone : () -> new StackSubInstruction(@stack)

class StackMulInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.mul()
  clone : () -> new StackMulInstruction(@stack)

class StackDivInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.div()
  clone : () -> new StackDivInstruction(@stack)

class StackModInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.mod()
  clone : () -> new StackModInstruction(@stack)

class StackXorInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.xor()
  clone : () -> new StackXorInstruction(@stack)

class StackGrtInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.grt()
  clone : () -> new StackGrtInstruction(@stack)

class StackSwapInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.swap()
  clone : () -> new StackSwapInstruction(@stack)

class StackNotInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.not()
  clone : () -> new StackNotInstruction(@stack)

class StackDupInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.dup()
  clone : () -> new StackDupInstruction(@stack)

class StackRotInstruction extends ActionInstruction
  constructor : (@stack) ->
  action : () -> @stack.rot()
  clone : () -> new StackRotInstruction(@stack)

class StackBnzInstruction extends BranchInstruction
  constructor : (@stack) ->
  action : () -> @stack.bnz()
  clone : () -> new StackBnzInstruction(@stack)
