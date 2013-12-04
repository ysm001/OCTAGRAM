class DepthFirstSearcher
  constructor: () ->
    @visited = []

  visit: (node) -> @visited.push(node)
  isVisited: (node) -> node in @visited

  init: () -> 
    @visited = []

  findUnvisitedChild: (node, cpu) ->
    dirs = 
      if node.getNextDir? then [node.getNextDir()]
      else if node.getConseqDir? then [node.getConseqDir(), node.getAlterDir()]
      else null

    if dirs?
      idx = node.getIndex()
      childs = (cpu.getTip(d.x + idx.x, d.y + idx.y) for d in dirs)

      unvisited = (child for child in childs when !@isVisited(child))

      if unvisited? then unvisited[0] else null

  search: (cpu, callback) ->
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


class JsProgram

class JsContext
  constructor: (@octagram) ->

  createMapping: () ->
    cpu = @octagram

class JsModule

class JsBuilder
  createCall: (tip) ->
  generate: (context) ->
