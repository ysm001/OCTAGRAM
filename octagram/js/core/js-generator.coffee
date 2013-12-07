class GraphSearcher
  constructor: () ->
    @visited = []

  visit: (node) -> @visited.push(node)
  isVisited: (node) -> node in @visited

  init: () -> 
    @visited = []

  getChilds: (node, cpu) ->
    dirs = 
      if node.getNextDir? then [node.getNextDir()]
      else if node.getConseqDir? then [node.getConseqDir(), node.getAlterDir()]
      else null

    if dirs?
      idx = node.getIndex()
      childs = (cpu.getTip(d.x + idx.x, d.y + idx.y) for d in dirs)

  findUnvisitedChild: (node, cpu) ->
    childs = @getChilds(node, cpu)

    if childs?
      unvisited = (child for child in childs when !@isVisited(child))
      if unvisited? then unvisited[0] else null

  findVisitedChild: (node, cpu) ->
    childs = @getChilds(node, cpu)

    if childs?
      visited = (child for child in childs when @isVisited(child))
      if visited? then visited[0] else null

  findLoop: (node, cpu, stack) ->
    child = @findVisitedChild(node, cpu)

    if child?
      idx = stack.indexOf(child)
      (stack[i] for i in [idx...stack.length])

  findSuccessors: (node, cpu) ->
    successors = []
    graph = new GraphSearcher()
    graph.dfs(node, cpu, (obj) -> 
      successors.push(obj.node)
      true
    )

    successors

  findRoute: (start, end, cpu) ->
    route = []
    graph = new GraphSearcher()

    graph.dfs(start, cpu, (obj) -> 
      if obj.node == end 
        route = obj.stack
        false
      else true
    )

    route

  dfs: (root, cpu, callback) ->
    @init()

    end = false

    stack = []
    _visit = (node) =>
      stack.push(node)
      @visit(node)
      callback({stack: stack, node: node, backtrack: false})

    end = !_visit(root)

    while stack.length > 0 && !end
      node = stack[stack.length - 1]
      child = @findUnvisitedChild(node, cpu)

      if child? then end = !_visit(child)
      else stack.pop()

class JsConstant
  @indent = '  '

class JsText
  constructor: () ->
    @lines = []

  insertLine: (line) -> @lines.push(line)
  insertBlock: (block) -> @insertArray(block.generateCode())
  insertArray: (array) -> @lines = @lines.concat(array)

  clean: () -> @lines = []

  generateCode: () -> @lines

class JsPlainBlock extends JsText
  constructor: () ->
    super()
    @childs = []

  addChild: (child) ->
    @childs.push(child)
    child.parent = @

class JsBlock extends JsPlainBlock
  generateCode: () ->
    code = (JsConstant.indent + line for line in @lines)
    code.unshift('{')
    code.push('}')
    code

class JsWhileBlock extends JsBlock
  constructor: (@condition) ->
    super()
  createCondition: () -> @condition

  generateCode: () ->
    code = super()
    code[0] = 'while( ' + @createCondition() + ' ) ' + code[0]
    code

class JsForBlock extends JsBlock
  constructor: (@condition) ->
    super()

  createCondition: () -> @condition

  generateCode: () ->
    code = super()
    code[0] = 'for( ' + @createCondition() + ' ) ' + code[0]
    code

class JsBranchBlock
  constructor: (@condition) ->
    @ifBlock = new JsBlock()
    @elseBlock = new JsBlock()

  getIfBlock: () -> @ifBlock
  getElseBlock: () -> @elseBlock

  createCondition: () -> @condition

  generateCode: () ->
    ifCode = @ifBlock.generateCode()
    elseCode = @elseBlock.generateCode()

    ifCode[0] = 'if( ' + @createCondition() + ' ) ' + ifCode[0]
    elseCode[0] = 'else ' + elseCode[0]

    ifCode.concat(elseCode)

class JsGenerator
  constructor: () ->
    @currentBlock = new JsPlainBlock()
    @blockStack = []
    @loops = []

  isBranchTransitionTip: (node) -> node.getConseqDir? && node.getAlterDir?
  isSingleTransitionTip: (node) -> node.getNextDir?

  getOperationName: (node) ->
    if node.code.instruction? then node.code.instruction.constructor.name else node.code.constructor.name

  insertToCurrentBlock: (node) ->
    @currentBlock.insertLine(@getOperationName(node) + '();')

  findLoop: (root, context) ->
    graph = new GraphSearcher()
    loops = []

    graph.dfs(root, context.cpu, (obj) ->
      lp = graph.findLoop(obj.node, context.cpu, obj.stack)
      if lp? then loops.push(lp)
      true
    )

    loops

  findLoopByEnterNode: (node) ->
    for lp in @loops
      if node == lp[0] then return lp

    null

  getBranchNodes: (node, context) ->
    ifDir = node.getConseqDir()
    elseDir = node.getAlterDir()
    cur = node.getIndex()

    ifNext = context.cpu.getTip(cur.x + ifDir.x, cur.y + ifDir.y)
    elseNext = context.cpu.getTip(cur.x + elseDir.x, cur.y + elseDir.y)

    {ifNext: ifNext, elseNext: elseNext}

  getMergeNode: (node, context) ->
    graph = new GraphSearcher()

    nodes = @getBranchNodes(node, context)

    ifSuccessors = graph.getSuccessors(nodes.ifNext)
    elseSuccessors = graph.getSuccessors(nodes.elseNext)

    for s in ifSuccessors
      if s in elseSuccessors then return s

    null

  generateWhileCode: (root, context) ->
    block = new JsWhileBlock('true')

    for node in context.loop
      if @isBranchTransitionTip(node)
        block.insertBlock(@generateBranchCode(node, context))
        # incompatible for break statement
        break
      else if @isSingleTransitionTip(node)
        block.insertLine(@getOperationName(node) + '();')

    block
    
  generateBranchCode: (root, context) ->
    block = new JsBranchBlock(@getOperationName(root))

    nodes = @getBranchNodes(root, context)
    block.ifBlock.insertBlock(@generateCode(nodes.ifNext, context))
    block.elseBlock.insertBlock(@generateCode(nodes.elseNext, context))

    block

  generateCode: (root, context) ->
    graph = new GraphSearcher()
    block = new JsPlainBlock()

    graph.dfs(root, context.cpu, (obj) => 
      node = obj.node
      lp = @findLoopByEnterNode(node)
      if lp?
        if !context.loop? || context.loop[0] != node
          context.loop = lp
          block.insertBlock(@generateWhileCode(node, context))
        false
      else if @isBranchTransitionTip(node)
        block.insertBlock(@generateBranchCode(node, context))
        false
      else if @isSingleTransitionTip(node)
        block.insertLine(@getOperationName(node) + '();')
        true
    )

    block

  assignOrder: (root, context) ->
    graph = new GraphSearcher()
    order = 0

    graph.dfs(root, context.cpu, (obj) => 
      obj.node.order = order++;
      true
    )

  generate: (cpu) ->
    root = cpu.getStartTip()
    context = {cpu: cpu}

    @loops = @findLoop(root, context)
    block = @generateCode(root, context)
    block.generateCode()
