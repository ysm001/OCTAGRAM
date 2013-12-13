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

intersection = (arrA, arrB) ->
  exist = {}
  for a in arrA then exist[a.order] = true
  (b for b in arrB when exist[b.order])

class GraphSearcher
  constructor: () ->
    @visited = []
    @predecessors = {}

  visit: (node) -> @visited.push(node)
  isVisited: (node) -> node in @visited

  init: () -> 
    @visited = []

  getChilds: (node, cpu, expand) ->
    if expand? then expand(node)
    else
      dirs = 
        if node.getNextDir? then [node.getNextDir()]
        else if node.getConseqDir? then [node.getConseqDir(), node.getAlterDir()]
        else null

      if dirs?
        idx = node.getIndex()
        childs = (cpu.getTip(d.x + idx.x, d.y + idx.y) for d in dirs)
        ((if @isRecursive(child) then cpu.getStartTip() else child) for child in childs)

  findUnvisitedChild: (node, cpu, expand) ->
    childs = @getChilds(node, cpu, expand)

    if childs?
      unvisited = (child for child in childs when !@isVisited(child))
      if unvisited? then unvisited[0] else null

  findVisitedChild: (node, cpu, expand) ->
    childs = @getChilds(node, cpu, expand)

    if childs?
      visited = (child for child in childs when @isVisited(child))
      if visited? then visited[0] else null

  findLoop: (node, cpu, stack) ->
    child = @findVisitedChild(node, cpu)

    if child?
      idx = stack.indexOf(child)
      (stack[i] for i in [idx...stack.length])

  getSuccessors: (node, context) ->
    successors = []
    graph = new GraphSearcher()
    graph.dfs(node, context.cpu, (obj) -> 
      if context.end? && obj.node == context.end then false
      else
        successors.push(obj.node)
        true
    )

    successors

  getImmediatePredecessors: (node, context) ->
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

    @predecessors[node.order]

  calcPredecessors: (root, context) ->
    _calcPredecessors = (node) =>
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

  isRecursive: (node) ->
    node.code? && (node.code.constructor.name == 'ReturnTip' || node.code.constructor.name == 'WallTip')

  dfs: (root, cpu, callback, expand) ->
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
      child = @findUnvisitedChild(node, cpu, expand)

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

  createDominatorTree: (root, universal, graph, context) ->
    dominators = @calcDominators(root, universal, graph, context)
    nodes = universal.slice(0)

    for node in nodes then node.childs = []

    for node in nodes when node != root
      dom = dominators[node.order]
      idom = dom[dom.length - 2]

      idom.childs.push(node)
      node.idom = idom

    {tree: nodes, dominators: dominators}

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
        dominators[u.order] = universal.slice(0)
        for p in graph.getImmediatePredecessors(u, context) when dominators[p.order]?
          dominators[u.order] = intersection(dominators[u.order], dominators[p.order])
        dominators[u.order] = dominators[u.order].concat([u])

     dominators

  findLoopHeaders: (root, dominators, graph, context) ->
    headers = []
    grpah.dfs(root, context.cpu, (obj) ->
    )

  findBackEdges: (root, dominators, graph, context) ->
    backedges = []
    graph.dfs(root, context.cpu, (obj) ->
      succ = graph.getChilds(obj.node, context.cpu)
      dom = dominators[obj.node.order]

      if succ?
        #backedge = ({src: obj.node, dst: s} for s in succ when s.order < obj.node.order)
        backedge = ({src: obj.node, dst: s} for s in succ when s in dom)
        if backedge.length > 0 then backedges = backedges.concat(backedge)

      true
    )

    backedges

  calcLoop: (edge, dominators, context) ->
    graph = new GraphSearcher()
    stack = []
    lp = [edge.dst]

    insert = (m) ->
      if !(m in lp) && m.order? && (edge.dst in dominators[m.order])
        lp.push(m)
        stack.push(m)

    insert(edge.src)

    while stack.length > 0
      m = stack.pop()
      for p in graph.getImmediatePredecessors(m, context)
        insert(p)

    lp

  find: (cpu) ->
    root = cpu.getStartTip()
    context = {cpu: cpu}

    graph = new GraphSearcher()
    graph.assignOrder(root, context)

    universal = []
    graph.dfs(root, cpu, (obj) => universal.push(obj.node))

    dom = @createDominatorTree(root, universal, graph, context)
    domTree = dom.tree
    dominators = dom.dominators

    backedges = @findBackEdges(root, dominators, graph, context)

    loops = []
    for edge in backedges
      # lp = graph.findRoute(edge.dst, edge.src, cpu)
      lp = @calcLoop(edge, dominators, context)
      loops.push(lp)

    {loops: loops, backedges: backedges, dominators: dom.dominators}

  verify: (loopObj, context) ->
    loops = loopObj.loops

    graph = new GraphSearcher()

    # ループヘッダの共有を検査
    headers = (lp[0].order for lp in loops)
    buf = []
    for h in headers
      if buf[h]? then return {loop: (lp[0] for lp in loops when lp[0].order = h)[0], reason: 'duplicateHeader'}
      else buf[h] = true

    # 一つのループに2つ以上の入り口が存在しないか検査 
    for lp in loops
      header = lp[0]
      for n in lp when n != header
        for p in graph.getImmediatePredecessors(n, context)
          if p.order? && !(p in lp) then return {loop: lp, reason: 'multiEnterEdge'}

    # non-natural loopの検出(曖昧)
    graph = new GraphSearcher()
    loops = []

    error = null
    graph.dfs(context.cpu.getStartTip(), context.cpu, (obj) ->
      childs = graph.getChilds(obj.node, context.cpu)
      if !childs? then return true

      succ = (s for s in childs when graph.isVisited(s) && s in obj.stack)
      if !succ? || succ.length == 0 then return true

      edges = ({src: obj.node, dst: s} for s in succ)
      for edge in edges
        for bedge in loopObj.backedges
          if (edge.src == bedge.src) && (edge.dst == bedge.dst) then return true

      error = {loop: graph.findLoop(obj.node, context.cpu, obj.stack), reason: 'nonNaturalLoop'}

      return false
    )
    
    error

class JsConstant
  @indent = '  '

class JsText
  constructor: () ->
    @lines = []

  insertLine: (node, text) -> 
    @lines.push({node: (if node instanceof Array then node else [node]), text: text})

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
  constructor: (@condition, @root) ->
    super()
  createCondition: () -> @condition

  generateCode: () ->
    code = super()
    code[0].text = 'while( ' + @createCondition() + ' ) ' + code[0].text
    code[0].node.unshift(@root)
    code[code.length - 1].node.unshift(@root)
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
    @breakBlock = new JsPlainBlock()
    @headerBlock = new JsPlainBlock()

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

          common.insertLine(line.node, line.text)
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
    headerCode = @headerBlock.generateCode()

    headerCode.concat(ifCode.concat(elseCode).concat(commonCode))

class JsGenerator
  constructor: () ->
    @currentBlock = new JsPlainBlock()
    @blockStack = []
    @loops = []

  isBranchTransitionTip: (node) -> node.getConseqDir? && node.getAlterDir?
  isSingleTransitionTip: (node) -> node.getNextDir?
  isJumpTransitionTip: (node) -> node.constructor.name == 'JumpTransitionCodeTip'
  isNopTip: (node) -> node.code && node.code.constructor.name == 'NopTip'
  isStopTip: (node) -> node.code && node.code.constructor.name == 'StopTip'
  isEmptyTip: (node) -> node.code && node.code.constructor.name == 'EmptyTip'
  isValidCodeTip: (node) -> (@isNopTip(node) || @isStopTip(node) || @isEmptyTip(node))

  getOperationName: (node) ->
    name = 
      if @isNopTip(node) then '// do nothing'
      else if @isStopTip(node) || @isEmptyTip(node) then 'return'
      else if node.code.instruction? && node.code.instruction.generateCode?
        node.code.instruction.generateCode() + '()'
      else if node.code.instruction? 
        node.code.instruction.constructor.name + '()'
      else 
        node.code.constructor.name + '()'

    if name? && name.length > 0
      name = name.replace('Tip', '')
      name = name.replace('Instruction', '')
      name = name.substring(0, 1).toLowerCase() + name.substring(1)
      name += ';'

    name

  insertToCurrentBlock: (node) ->
    @currentBlock.insertLine(node, @getOperationName(node))

  registerLoop: (newLp) ->
    sort = (arr) -> arr.sort (a, b) -> a - b
    newOrder = sort((node.order for node in newLp))
    for lp in @loops
      order = sort((node.order for node in lp))
      if arrayEqual(order, newOrder) then return false

    @loops.push(newLp.slice(0))

  findAllLoop: (root, context) ->
    # 重いが、コントロールフロー解析による確実な探索
    finder = new LoopFinder()
    finder.find(context.cpu)

    # 軽いが、DFSによる不確実な探索(ループが重なると見逃す)
    #graph = new GraphSearcher()
    #loops = []

    #graph.dfs(root, context.cpu, (obj) ->
    #  lp = graph.findLoop(obj.node, context.cpu, obj.stack)
    #  if lp? then loops.push(lp)
    #  true
    #)
    #
    #loops

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

    context.end = node
    ifSuccessors = graph.getSuccessors(nodes.ifNext, context)
    elseSuccessors = graph.getSuccessors(nodes.elseNext, context)

    for s in ifSuccessors
      if s in elseSuccessors then return s

    null

  isChildLoopNode: (node, childLoop) ->
    for lp in childLoop
      for n in lp 
        if node == n then return true

    false

  generateWhileCode: (root, context) ->
    block = new JsWhileBlock('true')
    if @isSingleTransitionTip(root) || @isJumpTransitionTip(node) || @isValidCodeTip(node)
      block.insertLine(root, @getOperationName(root))
      child = (new GraphSearcher()).getChilds(root, context.cpu)

      if child?
        block.insertBlock(@generateCode(child[0], context))
    else if @isBranchTransitionTip(root)
      block.insertBlock(@generateBranchCode(root, context))

    block
   
  findBreakNode: (root, branchNodes, context) ->
    result = {if: false, else: false}

    lp = @getCurrentLoop(context) 

    if !(branchNodes.ifNext in lp)
      result.if = true
      result.else = false
    else if !(branchNodes.elseNext in lp)
      result.if = false
      result.else = true

    result

  generateBranchCode: (root, context) ->
    block = new JsBranchBlock(@getOperationName(root), root)
    nodes = @getBranchNodes(root, context)

    block.ifBlock.insertBlock(@generateCode(nodes.ifNext, context))
    block.elseBlock.insertBlock(@generateCode(nodes.elseNext, context))

    block

  isTraversedLoopHeader: (node, context) ->
    if context.loop?
      for lp in context.loop
        if lp[0] == node then return true

    false

  isChildLoopHeader: (node, context) ->
    if context.loop?
      for n in @loops[@loops.length - 1]
        if n == node then return true

    false

  isOnLoop: (node, lp) ->
    for n in lp
      if node == n then return true

    false

  getCurrentLoop: (context) -> 
    if context.loop? && context.loop.length > 0
      context.loop[context.loop.length - 1]

  generateCode: (root, context) ->
    graph = new GraphSearcher()
    block = new JsPlainBlock()

    currentLoop = @getCurrentLoop(context)
    graph.dfs(root, context.cpu, (obj) => 
      node = obj.node

      if currentLoop? && !(node in currentLoop)
        block.insertLine(null, 'break;')
        context.break = node
        false
      else
        lp = @findLoopByEnterNode(node)
        if lp?
          if !@isTraversedLoopHeader(node, context)
            if !context.loop? then context.loop = []
            context.loop.push(lp)
            block.insertBlock(@generateWhileCode(node, context))
            context.loop.pop()
            if context.break?
              br = context.break
              context.break = null
              block.insertBlock(@generateCode(br, context))
          false
        else if @isBranchTransitionTip(node)
          block.insertBlock(@generateBranchCode(node, context))
          false
        else if @isSingleTransitionTip(node) || @isJumpTransitionTip(node) || @isValidCodeTip(node)
          block.insertLine(node, @getOperationName(node))
          true
    )

    block

  generateErrorCode: (error) ->
    switch error.reason
      when 'duplicateHeader' then @generateDuplicateHeaderErrorCode(error.loop)
      when 'multiEnterEdge'then @generateNonNaturalLoopErrorCode(error.loop)
      when 'nonNaturalLoop'then @generateNonNaturalLoopErrorCode(error.loop)
    
  generateDuplicateHeaderErrorCode: (errorLoop) ->
    block = new JsPlainBlock()
    block.insertLine(errorLoop, '//// Error ////')
    block.insertLine(errorLoop, '// ループの入り口は共有できません。')

    block

  generateNonNaturalLoopErrorCode: (errorLoop) ->
    block = new JsPlainBlock()
    block.insertLine(errorLoop, '//// Error ////')
    block.insertLine(errorLoop, '// 不正なループを検出しました。')
    block.insertLine(errorLoop, '// ループに複数の入り口が存在する可能性があります。')

    block

  generateHeaderCode: () ->
    block = new JsPlainBlock()
    block.insertLine(null, '// OCTAGRAMに対応するJavascriptコードです。')
    block.insertLine(null, '// ただし、non-natural loop(複数の入り口があるループなど)を含むプログラムの場合、')
    block.insertLine(null, '// 正しいコードが生成されません。')
    block.insertLine(null, '')
    
    block

  finalize: (cpu) ->
    for x in [-1..8]
      for y in [-1..8]
        node = cpu.getTip(x, y)
        node.childs = undefined
        node.idom = undefined
        node.order = undefined

  generate: (cpu) ->
    finder = new LoopFinder()
    root = cpu.getStartTip()
    context = {cpu: cpu}

    loopObj = @findAllLoop(root, context)
    error = finder.verify(loopObj, context)

    @loops = loopObj.loops

    code = 
      if error? then @generateErrorCode(error).generateCode()
      else
        headerBlock = @generateHeaderCode()
        block = @generateCode(root, context)
        block.generateCode()

    @finalize(cpu)
    code
