class Executer extends EventTarget
  @latency = 30

  constructor : (@cpu) ->
    @next = null
    @current = null
    @end = false
    @running = false

  getNext : () -> if @next? then @cpu.getTip(@next.x, @next.y) else null

  _execute : (tip) ->
    @current.hideExecutionEffect() if @current?
    @current = tip
    @current.showExecutionEffect()

    if @current.isAsynchronous()
      @current.code.instruction.removeEventListener('completeExecution', @execNext) 
      @current.code.instruction.addEventListener('completeExecution', @execNext) 

    @next = @current.execute()

    if !@next?
      @current.hideExecutionEffect()
      @current = null

    if !tip.isAsynchronous()
      setTimeout(@execNext, Executer.latency)

  waitWhileRunning : (callback) ->
    if @isRunning() 
      @stop()
      wait = () => @waitWhileRunning(callback)
      setTimeout(wait, 100)
    else callback()

  execute : () ->
    @waitWhileRunning(() =>
      @onStart()
      tip = @cpu.getStartTip()
      @_execute(tip)
    )

  execNext : (e) =>
    if @end
      @current.hideExecutionEffect() if @current
      nextTip = null
      @current = null
    else
      nextTip = @getNext()

    # asynchronous branch
    if @current? && @current.isAsynchronous() && e && e.params.result? && @current instanceof BranchTransitionCodeTip
      @next = if e.params.result then @current.code.getConseq() else @current.code.getAlter()
      nextTip = @getNext()

    if nextTip?
      if nextTip == @current
        console.log("error : invalid execution timing.")
        @next = @current.code.getNext()
        nextTip = @getNext()

      @_execute(nextTip)
    else @onStop()

  stop : () -> @end =true

  onStart : () ->
    console.log("start")
    @running = true
    @end = false

  onStop : () -> 
    console.log("stop")
    @running = false
    @end = false

  isRunning : () -> @running

octagram.Executer = Executer
