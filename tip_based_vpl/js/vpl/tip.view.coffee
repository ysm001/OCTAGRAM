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

###
  @toDirection : (x, y) -> 
    if x == -1 && y ==  0 then Direction.left
    else if x ==  1 && y ==  0 then Direction.right
    else if x ==  0 && y == -1 then Direction.up
    else if x ==  0 && y ==  1 then Direction.down
    else if x == -1 && y == -1 then Direction.leftUp
    else if x == -1 && y ==  1 then Direction.leftDown
    else if x ==  1 && y == -1 then Direction.rightUp
    else if x ==  1 && y ==  1 then Direction.rightDown
###

#####################################################
# チップのCV 
#####################################################
class CodeTip extends SpriteGroup
  @selectedEffect = null 
  @selectedInstance = null
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

    @addEventListener('touchstart', (e) =>
      @isTransitionSelect = !@isInnerTip(e.x, e.y)
      if !@isTransitionSelect
        if @dragMode && CodeTip.clonedTip? 
          CodeTip.clonedTip.hide()
        @dragMode = false
        @select()
    )

    @addEventListener('touchmove', (e) => 
      if !@isTransitionSelect
        if !@dragMode && !@immutable 
          @dragMode = true
          @dragStart(e)
        @dragged(e) 
    )
    @addEventListener('touchend', (e) => 
      if !@immutable
        if !@dragMode && @isSelected() && !@isFirstClick then @doubleClicked()
        else if @dragMode then @dragEnd(e)
      CodeTip.selectedInstance = this
    )

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
  doubleClicked : () -> @showConfigWindow() 
  createGhost : () ->
    CodeTip.clonedTip.hide() if CodeTip.clonedTip?
    tip = @clone()
    tip.sprite.opacity = 0.5
    tip.icon.opacity = 0.5 if tip.icon?
    tip.moveTo(@x, @y)
    tip.sprite.touchEnabled = false
    tip

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
      evt = document.createEvent('UIEvent', false)
      evt.initUIEvent('copyTip', true, true)
      evt.tip = CodeTip.clonedTip
      pos = evt.tip.getAbsolutePosition()
      evt.tip.x = pos.x
      evt.tip.y = pos.y
      CodeTip.clonedTip.hide()
      document.dispatchEvent(evt)

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

  getIcon : () ->
    @icon = 
      if @code.getIcon? then @code.getIcon() 
      else 
        icon = TipUtil.tipToIcon(@code)
        if icon? then new Icon(icon) else null
    @icon

  setIcon : (icon) -> 
    @icon = icon
    @icon.fitPosition()

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

class GhostCodeTip extends CodeTip
  constructor : (tip) ->
    super(tip.code)
    tip.copy(this)

    @sprite.opacity = 0.5
    @icon.opacity = 0.5 if tip.icon?
    @moveTo(tip.x, tip.y)
    @sprite.touchEnabled = false
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

#####################################################
# SingleTransitionTipのCV 
#####################################################
class Icon extends Sprite
  constructor : (icon, width, height) ->
    w = if width? then width else icon.width
    h = if height? then height else icon.height
    super(w, h)

    @image = icon
    @parent = null
    @hidden = true

    @touchEnabled = false

  fitPosition : () ->
    if @parentNode?
      @moveTo(@parentNode.getWidth()/2 - @width/2, 
        @parentNode.getWidth()/2 - @height/2)

  clone : () -> 
    obj = new Icon(@image, @width, @height)
    obj.frame = @frame 
    obj



