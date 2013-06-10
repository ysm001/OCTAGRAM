#####################################################
# CV(Control View)関連 
#####################################################

#####################################################
# 進行方向 
#####################################################
class Direction
  @left      = new Point(-1, 0)
  @right     = new Point( 1, 0)
  @up        = new Point( 0,-1)
  @down      = new Point( 0, 1)
  @leftUp    = new Point(-1,-1)
  @leftDown  = new Point(-1, 1)
  @rightUp   = new Point( 1,-1)
  @rightDown = new Point( 1, 1)

  @toDirection : (x, y) -> new Point(x, y)

#####################################################
# チップのCV 
#####################################################
class CodeTip extends SpriteGroup
  @selectedEffect = null 
  #@selectedInstance = null
  @clonedTip = null

  constructor : (@code) ->
    super(TipUtil.tipToImage(@code))
    @immutable   = @code instanceof WallTip || @code instanceof StartTip
    @description = @code.mkDescription() 

    @isTransitionSelect = false
    @icon = @getIcon()

    @dragMode = false
    @isFirstClick = false
    CodeTip.clonedTip = null
    @dragStartX = 0
    @dragStartY = 0
    @parameters = if @code.instruction? then @code.instruction.parameters 
    @addChild(@sprite)
    if @icon?
      @addChild(@icon)
      @icon.fitPosition()

    @executionEffect = new ExecutionEffect(this)
    CodeTip.selectedEffect = new SelectedEffect() if !CodeTip.selectedEffect?

  isInnerTip : (x, y) ->
    pos = @getAbsolutePosition()
    half = @getWidth()
    xs = pos.x
    xe = pos.x + half
    ys = pos.y
    ye = pos.y + half
    x>xs && x<xe && y>ys && y<ye

  select : () =>
    Game.instance.vpl.ui.help.setText(@description)
    @isFirstClick = !@isSelected()
    @showSelectedEffect()

  unselect : () ->
    Game.instance.vpl.ui.help.setText("")
    @hideSelectedEffect()

  execute : () -> if @code? then @code.execute() else null

  createGhost : () ->
    CodeTip.clonedTip.hide() if CodeTip.clonedTip?
    tip = @clone()
    tip.sprite.opacity = 0.5
    tip.icon.opacity = 0.5 if tip.icon?
    tip.moveTo(@x, @y)
    tip.sprite.touchEnabled = false
    tip

  ontouchstart : (e) =>
    @isTransitionSelect = !@isInnerTip(e.x, e.y)
    if !@isTransitionSelect
      if @dragMode && CodeTip.clonedTip? 
        CodeTip.clonedTip.hide()
      @dragMode = false
      @select()

  ontouchmove : (e) => 
    if !@isTransitionSelect
      if !@dragMode && !@immutable 
        @dragMode = true
        @dragStart(e)
      @dragged(e) 

  ontouchend : (e) => 
    if !@immutable
      if !@dragMode && @isSelected() && !@isFirstClick then @doubleClicked()
      else if @dragMode then @dragEnd(e)
    CodeTip.selectedInstance = this

  dragStart : (e) -> 
    CodeTip.clonedTip = @createGhost()
    CodeTip.clonedTip.show(@parentNode)
    @dragStartX = e.x
    @dragStartY = e.y

  dragged : (e) -> 
    if CodeTip.clonedTip?
      dx = e.x - @dragStartX
      dy = e.y - @dragStartY
      CodeTip.clonedTip.moveTo(@x + dx, @y + dy)

  dragEnd : (e) -> 
    @dragMode = false
    if CodeTip.clonedTip?
      pos = CodeTip.clonedTip.getAbsolutePosition()
      CodeTip.clonedTip.hide()
      Game.instance.vpl.cpu.insertTipOnNearestPosition(pos.x, pos.y, CodeTip.clonedTip)

  doubleClicked : () -> @showConfigWindow() 

  showConfigWindow : () -> 
    if @parameters?
      backup = {}
      content = new ParameterConfigPanel()
      
      for param, i in @parameters
        backup[i] = param.getValue()
        onValueChanged = param.onValueChanged
        param.onValueChanged = () =>
          onValueChanged()
          @setDescription(@code.mkDescription())

        content.addParameter(param)

      Game.instance.vpl.ui.configPanel.setContent(content)
      Game.instance.vpl.ui.configPanel.show(this)

      Game.instance.vpl.ui.configPanel.onClosed = (closedWithOK) =>
        if closedWithOK 
          #@updateIcon() 
          @icon = @getIcon()
          @setDescription(@code.mkDescription())
        else 
          for param, i in @parameters
            param.setValue(backup[i])

  isSelected : () -> 
    CodeTip.selectedEffect.parentNode == this

  showExecutionEffect : () -> @executionEffect.show(this)
  hideExecutionEffect : () -> @executionEffect.hide()
  showSelectedEffect : () -> 
    if !@isSelected() then CodeTip.selectedEffect.show(this)
  hideSelectedEffect : () -> CodeTip.selectedEffect.hide()

  isAsynchronous : () -> @code.isAsynchronous? && @code.isAsynchronous()

  setIcon : (icon) -> 
    @icon = icon
    @icon.fitPosition()

  getIcon : () ->
    @icon = 
      if @code.getIcon? then @code.getIcon() 
      else 
        icon = TipUtil.tipToIcon(@code)
        if icon? then new Icon(icon) else null
    @icon

  setDescription : (desc) ->
    @description = desc
    @onDescriptionChanged()

  onDescriptionChanged : () ->
    if @isSelected() then Game.instance.vpl.ui.help.setText(@description)

  setIndex : (idxX, idxY) -> @code.index = {x: idxX, y: idxY}
  getIndex : () -> @code.index

  show : (parent) -> parent.addChild(this) if parent?
  hide : (parent) -> @parentNode.removeChild(this) if @parentNode?

  clone : () -> new CodeTip(@code.clone())

  copy : (obj) ->
    obj.description = @description
    obj.icon = @icon.clone() if @icon?

    obj

#####################################################
# SingleTransitionTipのCV 
#####################################################
class SingleTransitionCodeTip extends CodeTip
  constructor : (code) ->
    super(code)
    @trans = null

  setNext : (x, y, dst) -> 
    @trans.hide() if @trans?
    @trans = new NormalTransition(this, dst)
    @trans.show(this)
    @code.setNext({x:x, y:y}) 

  getNextDir : () ->
    next = @code.getNext()
    if !next? then null
    else Direction.toDirection(next.x - @code.index.x, 
      next.y - @code.index.y)

  clone : () -> @copy(new SingleTransitionCodeTip(@code.clone()))

#####################################################
# SingleTransitionTipのCV 
#####################################################
class BranchTransitionCodeTip extends CodeTip
  constructor : (code) ->
    super(code)
    @conseqTrans = null
    @alterTrans = null

  setConseq : (x, y, dst) ->
    @conseqTrans.hide() if @conseqTrans?
    @conseqTrans = new NormalTransition(this, dst)
    @conseqTrans.show(this) 
    @code.setConseq({x:x, y:y})

  setAlter : (x, y, dst) ->
    @alterTrans.hide() if @alterTrans?
    @alterTrans = new AlterTransition(this, dst)
    @alterTrans.show(this) 
    @code.setAlter({x:x, y:y})

  getConseqDir : () ->
    next = @code.getConseq()
    if !next? then null
    else Direction.toDirection(next.x - @code.index.x, 
      next.y - @code.index.y)

  getAlterDir : () ->
   next = @code.getAlter()
   if !next? then null
   else Direction.toDirection(next.x - @code.index.x, 
     next.y - @code.index.y)

  clone : () -> @copy(new BranchTransitionCodeTip(@code.clone()))

#####################################################
# SingleTransitionTipのCV 
#####################################################
class JumpTransitionCodeTip extends CodeTip
  constructor : (code) -> super(code)
  setNext : (x, y) -> @code.setNext({x:x, y:y})
  clone : () -> @copy(new JumpTransitionCodeTip(@code.clone()))




