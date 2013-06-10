class Executer
  @latency = 30

  constructor : (@cpu) ->
    @next = null
    @current = null

    document.addEventListener("completeExecution", (e) => @execNext())

  getNext : () -> if @next? then @cpu.getTip(@next.x, @next.y) else null

  _execute : (tip) ->
    @current.hideExecutionEffect() if @current?
    @current = tip
    @current.showExecutionEffect()

    @next = tip.execute()

    if !@next?
      @current.hideExecutionEffect()
      @current = null
    if !tip.isAsynchronous() 
      setTimeout(@execNext, Executer.latency)

  execute : () ->
    tip = @cpu.getStartTip()
    @_execute(tip)

  execNext : (e) =>
    nextTip = @getNext()

    if nextTip?
      if nextTip == @current
        console.log("error : invalid execution timing.")
        @next = @current.code.getNext()
        nextTip = @getNext()

      @_execute(nextTip)

