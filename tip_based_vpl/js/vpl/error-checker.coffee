class ErrorChecker
  constructor : () -> @init()

  init : () ->
    @stack = []
    @visited = []
    @error = new ErrorData()

  # cycle and unreachable
  detectError : (cpu) ->
    start = cpu.getStartPosition()

    @init()
    @_dfs(cpu, start)
    @error

  _dfs : (cpu, tipPos) ->
    tip = cpu.getTip(tipPos.x, tipPos.y)
    if tip?
      if tip in @stack
        # cycle detected
        @_registerCycle(cpu, tip)
      else
        @stack.push(tip)
        @visited.push(tip)

        if tip instanceof SingleTransitionCodeTip
          @_dfs(cpu.getTip())
        else if tip instanceof BranchTransitionCodeTip
          @_dfs(tip.getConseq())
          @_dfs(tip.getAlter())

        @stack.pop()

  _registerCycle : (cpu, cycleStartTip) ->
    start = @stack.indexOf(cycleStartTip)
    cycle = @stack.slice(start, @stack.length - 1)
    @error.cycle.push(cycle)

  _registerUnreachable : () ->
    for j in [0...cpu.getYnum()]
      for i in [0...cpu.getXnum()]
        console.log("")

class ErrorData
  constructor : () ->
    @cycle = []
    @unreachable = []
