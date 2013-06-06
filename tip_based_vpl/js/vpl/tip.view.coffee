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

  @toDirection : (x, y) -> 
    if x == -1 && y ==  0 then Direction.left
    else if x ==  1 && y ==  0 then Direction.right
    else if x ==  0 && y == -1 then Direction.up
    else if x ==  0 && y ==  1 then Direction.down
    else if x == -1 && y == -1 then Direction.leftUp
    else if x == -1 && y ==  1 then Direction.leftDown
    else if x ==  1 && y == -1 then Direction.rightUp
    else if x ==  1 && y ==  1 then Direction.rightDown

#####################################################
# チップのCV 
#####################################################
class CodeTip extends Sprite
  @selectedEffect = null 
  @selectedInstance = null
  @clonedTip = null

  constructor : (@code) ->
    @immutable   = @code instanceof WallTip || @code instanceof StartTip
    @description = @code.mkDescription()#TipUtil.tipToMessage(@code) 
    image        = TipUtil.tipToImage(@code) 

    super(image.width, image.height)
    @image = image 
    @icon = null
    @dragMode = false
    CodeTip.clonedTip = null
    @dragStartX = 0
    @dragStartY = 0
    @parameters = if @code.instruction? then @code.instruction.parameters 
    @addEventListener('touchstart', (e) =>
      @dragMode = false
      @select()
    )
    @addEventListener('touchmove', (e) => 
      if !@dragMode && !@immutable
        @dragMode = true
        @dragStart(e)
      @dragged(e) 
    )
    @addEventListener('touchend', (e) => 
      if !@immutable
        if !@dragMode && @isSelected() then @doubleClicked()
        else @dragEnd(e)
      CodeTip.selectedInstance = this
    )

    #@updateIcon()

    @executionEffect = new ExecutionEffect(this)
    CodeTip.selectedEffect = new SelectedEffect() if !CodeTip.selectedEffect?

    LayerUtil.setOrder(this, LayerOrder.tip)

  select : () =>
    GlobalUI.help.setText(@description)
    @showSelectedEffect()

  unselect : () ->
    GlobalUI.help.setText("")
    @hideSelectedEffect()

  #addParameter : (param) -> @parameters.push(param)

  execute : () -> if @code? then @code.execute() else null
  doubleClicked : () -> @showConfigWindow() 
  createGhost : () ->
    CodeTip.clonedTip.hide() if CodeTip.clonedTip?
    tip = @clone()
    tip.opacity = 0.5
    tip.icon.opacity = 0.5 if tip.icon?
    tip.moveTo(@x, @y)
    tip.clearEventListener()
    tip

  dragStart : (e) -> 
    CodeTip.clonedTip = @createGhost()
    CodeTip.clonedTip.show()
    @dragStartX = e.x
    @dragStartY = e.y

  dragged : (e) -> 
    dx = e.x - @dragStartX
    dy = e.y - @dragStartY
    CodeTip.clonedTip.moveTo(@x + dx, @y + dy)

  dragEnd : (e) -> 
    if CodeTip.clonedTip?
      CodeTip.clonedTip.hide()
      evt = document.createEvent('UIEvent', false)
      evt.initUIEvent('copyTip', true, true)
      evt.tip = CodeTip.clonedTip
      document.dispatchEvent(evt)

  showConfigWindow : () -> 
    if @parameters?
      backup = {}
      GlobalUI.configPanel.content.clear()
      
      for param, i in @parameters
        backup[i] = param.getValue()
        GlobalUI.configPanel.content.addParameter(param)

      GlobalUI.configPanel.show(this)

      GlobalUI.configPanel.onClosed = (closedWithOK) =>
        if closedWithOK 
          @updateIcon() 
          @setDescription(@code.mkDescription())
        else 
          for param, i in @parameters
            param.setValue(backup[i])

  isSelected : () -> CodeTip.selectedInstance == this

  showExecutionEffect : () -> @executionEffect.show()
  hideExecutionEffect : () -> @executionEffect.hide()
  showSelectedEffect : () -> CodeTip.selectedEffect.show(this)
  hideSelectedEffect : () -> CodeTip.selectedEffect.hide()

  isAsynchronous : () -> @code.isAsynchronous? && @code.isAsynchronous()

  updateIcon : () ->
    @icon.hide() if @icon?

    @icon = 
      if @code.getIcon? then @code.getIcon() 
      else 
        icon = TipUtil.tipToIcon(@code)
        if icon? then new Icon(icon) else null

    @icon.show(this) if @icon?

  setDescription : (desc) ->
    @description = desc
    @onDescriptionChanged()

  setIcon : (icon) -> 
    @icon = icon
    @icon.fitPosition()

  getIcon : (icon) -> @icon

  onDescriptionChanged : () ->
    if @isSelected() then GlobalUI.help.setText(@description)

  setIndex : (idxX, idxY) -> @code.index = {x: idxX, y: idxY}
  getIndex : () -> @code.index

  moveTo : (x, y) ->
    super(x, y)
    @icon.fitPosition() if @icon?
    #CodeTip.selectedEffect.moveTo(x, y) if @isSelected()

  moveBy : (x, y) ->
    super(x, y)
    @icon.fitPosition() if @icon?
    #CodeTip.selectedEffect.moveBy(x, y) if @isSelected()

  show : () -> 
    Game.instance.currentScene.addChild(this)
    #@icon.show(this) if @icon?
    @updateIcon()

  hide : () ->
    Game.instance.currentScene.removeChild(this)
    @icon.hide() if @icon?

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
    @trans.show()
    @code.setNext({x:x, y:y}) 

  getNextDir : () ->
    next = @code.getNext()
    if !next? then null
    else Direction.toDirection(next.x - @code.index.x, 
      next.y - @code.index.y)

  hide : () -> 
    super()
    @trans.hide() if @trans?

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
    @conseqTrans.show() 
    @code.setConseq({x:x, y:y})

  setAlter : (x, y, dst) ->
    @alterTrans.hide() if @alterTrans?
    @alterTrans = new AlterTransition(this, dst)
    @alterTrans.show() 
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

  hide : () ->
    super()
    @conseqTrans.hide() if @conseqTrans?
    @alterTrans.hide() if @alterTrans?

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
    LayerUtil.setOrder(this, LayerOrder.tipIcon)
    #LayerUtil.setOrder(this, LayerOrder.frameUIIcon) 

    @addEventListener('touchstart', (e)-> @parent.dispatchEvent(e))
    @addEventListener('touchmove', (e)-> @parent.dispatchEvent(e))
    @addEventListener('touchend', (e)-> @parent.dispatchEvent(e))

  fitPosition : () ->
    if @parent?
      @moveTo(@parent.x + @parent.width/2 - @width/2, 
        @parent.y + @parent.height/2 - @height/2)

  show : (parent) ->
    if @hidden
      @hidden = false
      @parent = parent if parent?
      @fitPosition()
      Game.instance.currentScene.addChild(this)

  hide : () -> 
    if !@hidden
      @hidden = true
      Game.instance.currentScene.removeChild(this)

  clone : () -> 
    obj = new Icon(@image, @width, @height)
    obj.frame = @frame 
    obj

#####################################################
# SingleTransitionTipのCV 
#####################################################
class TipParameter
  constructor : (@valueName, @value, @min, @max, @step) -> @text = ""

  setValue : (value) ->
    @value = value
    @text = toString()
    @onValueChanged()

  getValue : () -> @value

  onValueChanged : () ->
  mkLabel : () ->

  clone : () -> new TipParameter(@valueName, @value, @min, @max, @step)
  copy : (obj) ->
    obj.valueName = @valueName
    obj.value = @value
    obj.min = @min
    obj.max = @max
    obj.step = @step

  toString : () -> @value.toString()


