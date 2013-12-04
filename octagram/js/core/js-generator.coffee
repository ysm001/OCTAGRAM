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

  dfs: (cpu, callback) ->
    @init()

    stack = []
    _visit = (node) =>
      stack.push(node)
      @visit(node)
      callback({stack: stack, node: node})

    root = cpu.getStartTip()
    _visit(root)

    while stack.length > 0
      node = stack[stack.length - 1]
      child = @findUnvisitedChild(node, cpu)

      if child? then _visit(child)
      else stack.pop()

class JsConstant
  @indent = '  '

class JsText
  constructor: () ->
    @lines = []

  insertLine: (line) -> @lines.push(line)
  insertBlock: (block) -> @lines.concat(block)

  clean: () -> @lines = []

  generateCode: () -> @lines

class JsBlock extends JsText
  generateCode: () ->
    code = (JsConstant.indent + line for line in @lines)
    code.unshift('{')
    code.push('}')
    code

class JsWhileBlock extends JsBlock
  constructor: (@condition) ->

  createCondition: () -> @condition

  generateCode: () ->
    code = super()
    code[0] = 'while( ' + @createCondition() + ' ) ' + code[0]

class JsForBlock extends JsBlock
  constructor: (@condition) ->

  createCondition: () -> @condition

  generateCode: () ->
    code = super()
    code[0] = 'for( ' + @createCondition() + ' ) ' + code[0]

class JsIfBlock extends JsBlock
  constructor: (@condition) ->

  createCondition: () -> @condition

  generateCode: () ->
    code = super()
    code[0] = 'if( ' + @createCondition() + ' ) ' + code[0]

class JsModule

class JsBuilder
  constructor: () ->
    @graph = new GraphSearcher()
    @mainBlock = new JsText()

  verify: () ->

  getOperationName: (node) ->
    if node.code.instruction? then node.code.instruction.constructor.name else node.code.constructor.name

  insertSingleOperation: (node) ->
    code = @getOperationName(node) + '();'
    @mainBlock.insertLine(code)

  insertCode: (obj, cpu) ->
    loopNodes = @graph.findLoop(obj.node, cpu, obj.stack)
    @insertSingleOperation(obj.node)
    if loopNodes? then console.log loopNodes

  generate: (cpu) ->
    @mainBlock.clean()

    @graph.dfs(cpu, (obj) => @insertCode(obj, cpu))
    code = @mainBlock.generateCode()
    console.log code.join('\n')
