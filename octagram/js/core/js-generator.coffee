getUniqueArray = (ary) ->
   storage = []
   uniqueArray = []
   for value in ary
     if !(value in storage)
       storage.push(value)
       uniqueArray.push(value)
       uniqueArray

    uniqueArray

arrayEqual = (a, b) ->
    a.length is b.length and a.every (elem, i) -> elem is b[i]

class GraphSearcher
  constructor: () ->
    @visited = []
    @predecessors = {}

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

  getSuccessors: (node, cpu) ->
    successors = []
    graph = new GraphSearcher()
    graph.dfs(node, cpu, (obj) -> 
      successors.push(obj.node)
      true
    )

    successors

  calcPredecessors: (root, context) ->
    _calcPredecessors = (node) =>
      if !@predecessors[node.order]?
        @predecessors[node.order] = []
        for dx in [-1..1]
          for dy in [-1..1] 
            cur = node.getIndex()
            nx = cur.x + dx
            ny = cur.y + dy
            inRange = (v) -> -1 <= v && v < 8

            if inRange(nx) && inRange(ny)
              cand = context.cpu.getTip(nx, ny)
              candSucc = @getChilds(cand, context.cpu)
              if candSucc? && node in candSucc 
                @predecessors[node.order].push(cand)

        for pre in @predecessors[node.order]
          _calcPredecessors(pre, context)

    _calcPredecessors(root)

  getPredecessors: (root, context) ->
    calced = []

    _getPredecessors = (node) =>
      if !(node in calced)
        calced.push(node)
        predecessors = []
        if !@predecessors[node.order]? then @calcPredecessors(node, context)
        parents = @predecessors[node.order]

        if parents.length > 0
          for p in parents
            predecessors.push(p)
            predecessors = predecessors.concat(_getPredecessors(p))

        getUniqueArray(predecessors)
      else []

    _getPredecessors(root)

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

  assignOrder: (root, context) ->
    graph = new GraphSearcher()
    order = 0

    graph.dfs(root, context.cpu, (obj) => 
      obj.node.order = order++;
      true
    )

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

class LoopFinder
  constructor: () ->

  initDominators: (root, universal) ->
    dominators = {}

    for u in universal
      dominators[u.order] = 
        if u == root then [u]
        else universal.slice(0)

  calcDominators: (root, universal, graph, context) ->
    dominators = @initDominators(root, universal)

    preDominators = []
    isChangeOccurred = (pre, cur) ->
      if pre.length != cur.length then return true

      for i in [0...cur.length]
        if !arrayEqual(pre[i], cur[i]) then return true

      false

    while isChangeOccurred(preDominators, dominators)
      preDominators = dominators.slice(0)
      for u in universal when u != root
        dominators[u.order] = [u]
        for p in graph.getPredecessors(u, context) when dominators[p.order]?
          dominators[u.order] = dominators[u.order].concat(dominators[p.order])
          dominators[u.order] = getUniqueArray(dominators[u.order])

     dominators

  findBackEdges: (root, dominators, graph, context) ->
    backedges = []
    graph.dfs(root, context.cpu, (obj) ->
      succ = graph.getChilds(obj.node, context.cpu)
      #dom = dominators[obj.node.order]

      if succ?
        backedge = ({src: obj.node, dst: s} for s in succ when s.order < obj.node.order)
        #backedge = ({src: obj.node, dst: s} for s in succ when s in dom)
        if backedge.length > 0 then backedges = backedges.concat(backedge)

      true
    )

    backedges

  find: (cpu) ->
    root = cpu.getStartTip()
    context = {cpu: cpu}

    graph = new GraphSearcher()
    graph.assignOrder(root, context)

    universal = []
    graph.dfs(root, cpu, (obj) => universal.push(obj.node))

    dominators = @calcDominators(root, universal, graph, context)

    backedges = @findBackEdges(root, dominators, graph, context)

    console.log ({src: e.src.order, dst: e.dst.order} for e in backedges)

class JsConstant
  @indent = '  '

class JsText
  constructor: () ->
    @lines = []

  insertLine: (node, text) -> @lines.push({node: [node], text: text})
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
    code = ({node: line.node, text: JsConstant.indent + line.text} for line in @lines)
    nodes = (line.node[0] for line in @lines)
    code.unshift({node: nodes, text: '{'})
    code.push({node: nodes, text: '}'})
    code

  clone: () ->
    block = new JsBlock()
    block.lines = @lines.slice(0)
    block

class JsWhileBlock extends JsBlock
  constructor: (@condition) ->
    super()
  createCondition: () -> @condition

  generateCode: () ->
    code = super()
    code[0].text = 'while( ' + @createCondition() + ' ) ' + code[0].text
    code

class JsForBlock extends JsBlock
  constructor: (@condition) ->
    super()

  createCondition: () -> @condition

  generateCode: () ->
    code = super()
    code[0].text = 'for( ' + @createCondition() + ' ) ' + code[0].text
    code

class JsBranchBlock
  constructor: (@condition, @root) ->
    @ifBlock = new JsBlock()
    @elseBlock = new JsBlock()

  getIfBlock: () -> @ifBlock
  getElseBlock: () -> @elseBlock

  createCondition: () -> @condition

  removeCommonProcess: (ifLines, elseLines) ->
    long = if ifLines.length > elseLines.length then ifLines else elseLines
    short = if ifLines.length <= elseLines.length then ifLines else elseLines

    common = new JsPlainBlock()

    if long.length > 0 && short.length > 0
      for i in [1..short.length]
        ln = long[long.length - 1].node
        sn = short[short.length - 1].node
        
        if arrayEqual(ln, sn)
          line = long.pop()
          short.pop()

          if line.node.length != 1 then console.log 'err'
          common.insertLine(line.node[0], line.text)
        else break

    common.lines.reverse()
    common

  generateCode: () ->
    ifBlock = @ifBlock.clone()
    elseBlock = @elseBlock.clone()
    commonBlock = @removeCommonProcess(ifBlock.lines, elseBlock.lines)

    ifCode = ifBlock.generateCode()
    elseCode = elseBlock.generateCode()

    ifCode[0].text = 'if( ' + @createCondition() + ' ) ' + ifCode[0].text
    elseCode[0].text = 'else ' + elseCode[0].text

    ifCode[0].node.unshift(@root)
    ifCode[ifCode.length - 1].node.unshift(@root)
    elseCode[0].node.unshift(@root)
    elseCode[elseCode.length - 1].node.unshift(@root)

    commonCode = commonBlock.generateCode()

    ifCode.concat(elseCode).concat(commonCode)

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
    @currentBlock.insertLine(node, @getOperationName(node) + '();')

  registerLoop: (newLp) ->
    sort = (arr) -> arr.sort (a, b) -> a - b
    newOrder = sort((node.order for node in newLp))
    for lp in @loops
      order = sort((node.order for node in lp))
      if arrayEqual(order, newOrder) then return false

    @loops.push(newLp.slice(0))

  findAllLoop: (root, context) ->
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
        break
      else if @isSingleTransitionTip(node)
        block.insertLine(node, @getOperationName(node) + '();')

    block
   
  generateBranchCode: (root, context) ->
    block = new JsBranchBlock(@getOperationName(root), root)

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
        block.insertLine(node, @getOperationName(node) + '();')
        true
    )

    block

  generate: (cpu) ->
    root = cpu.getStartTip()
    context = {cpu: cpu}

    @loops = @findAllLoop(root, context)
    block = @generateCode(root, context)
    block.generateCode()
