#####################################################
# CV(Control View)関連 
#####################################################

class SpriteGroup extends Group
  constructor : (image) -> 
    super()
    @sprite = new Sprite(image.width, image.height)
    @sprite.image = image

  getAbsolutePosition : () ->
    pos = {x: @x, y: @y}
    parent = @parentNode
    while parent? && !(parent instanceof Scene)
      pos.x += parent.x
      pos.y += parent.y
      parent = parent.parentNode
    pos

  setOpacity : (opacity) ->
    for child in @childNodes
      if child instanceof Sprite
        child.opacity = opacity
      else if child instanceof SpriteGroup
        child.setOpacity(opacity)

  setVisible : (visible) ->
    for child in @childNodes
      if child instanceof Sprite
        child.visible = visible
      else if child instanceof SpriteGroup
        child.setVisible(opacity)
    
  getWidth : () -> @sprite.width
  getHeight : () -> @sprite.height

class GroupedSprite extends Sprite
  getAbsolutePosition : () ->
    pos = {x: @x, y: @y}
    parent = @parentNode
    while parent? && !(parent instanceof Scene)
      pos.x += parent.x
      pos.y += parent.y
      parent = parent.parentNode
    pos

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
class CodeTip extends SpriteGroup#Sprite
  @selectedEffect = null 
  @selectedInstance = null
  @clonedTip = null

  constructor : (@code) ->
    super(TipUtil.tipToImage(@code))
    @immutable   = @code instanceof WallTip || @code instanceof StartTip
    @description = @code.mkDescription()#TipUtil.tipToMessage(@code) 
    @isTransitionSelect = false
    
    #super(image.width, image.height)
    #@image = image 
    @icon = @getIcon()#if @code.getIcon? then @code.getIcon() else null

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

    # ここで、チップの範囲外だったらdragしないようにする
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

    #@updateIcon()

    @executionEffect = new ExecutionEffect(this)
    CodeTip.selectedEffect = new SelectedEffect() if !CodeTip.selectedEffect?

    LayerUtil.setOrder(this, LayerOrder.tip)

  isInnerTip : (x, y) ->
    pos = @getAbsolutePosition()
    half = @getWidth()
    xs = pos.x
    xe = pos.x + half
    ys = pos.y
    ye = pos.y + half
    x>xs && x<xe && y>ys && y<ye

  select : () =>
    GlobalUI.help.setText(@description)
    @isFirstClick = !@isSelected()
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
    tip.sprite.opacity = 0.5
    tip.icon.opacity = 0.5 if tip.icon?
    tip.moveTo(@x, @y)
    #tip.clearEventListener()
    tip.sprite.touchEnabled = false
    tip

  dragStart : (e) -> 
    #console.log "start"
    CodeTip.clonedTip = @createGhost()
    CodeTip.clonedTip.show(@parentNode)
    @dragStartX = e.x
    @dragStartY = e.y

  dragged : (e) -> 
    #console.log "dragged"
    if CodeTip.clonedTip?
      dx = e.x - @dragStartX
      dy = e.y - @dragStartY
      CodeTip.clonedTip.moveTo(@x + dx, @y + dy)

  dragEnd : (e) -> 
    #console.log "end"
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

      GlobalUI.configPanel.setContent(content)
      GlobalUI.configPanel.show(this)

      GlobalUI.configPanel.onClosed = (closedWithOK) =>
        if closedWithOK 
          #@updateIcon() 
          @icon = @getIcon()
          @setDescription(@code.mkDescription())
        else 
          for param, i in @parameters
            param.setValue(backup[i])

  isSelected : () -> 
    #CodeTip.selectedInstance == this
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

  setDescription : (desc) ->
    @description = desc
    @onDescriptionChanged()

  setIcon : (icon) -> 
    @icon = icon
    @icon.fitPosition()

  #getIcon : (icon) -> @icon

  onDescriptionChanged : () ->
    if @isSelected() then GlobalUI.help.setText(@description)

  setIndex : (idxX, idxY) -> @code.index = {x: idxX, y: idxY}
  getIndex : () -> @code.index

  ###
  moveTo : (x, y) ->
    super(x, y)
    @icon.fitPosition() if @icon?
    #CodeTip.selectedEffect.moveTo(x, y) if @isSelected()

  moveBy : (x, y) ->
    super(x, y)
    @icon.fitPosition() if @icon?
    #CodeTip.selectedEffect.moveBy(x, y) if @isSelected()
  ###

  show : (parent) -> 
    #Game.instance.currentScene.addChild(this)
    parent.addChild(this) if parent?
    #@icon.show(this) if @icon?
    #@updateIcon()

  hide : (parent) ->
    #Game.instance.currentScene.removeChild(this)
    @parentNode.removeChild(this) if @parentNode?
    #@icon.hide() if @icon?

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

  ###
  hide : () -> 
    super()
    # @trans.hide(this) if @trans?
  ###

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

  hide : () ->
    super()
    #@conseqTrans.hide() if @conseqTrans?
    #@alterTrans.hide() if @alterTrans?

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

    @touchEnabled = false
    ###
    @addEventListener('touchstart', (e)-> @parent.dispatchEvent(e))
    @addEventListener('touchmove', (e)-> @parent.dispatchEvent(e))
    @addEventListener('touchend', (e)-> @parent.dispatchEvent(e))
    ###

  fitPosition : () ->
    if @parentNode?
      ###
      @moveTo(@parent.x + @parent.width/2 - @width/2, 
        @parent.y + @parent.height/2 - @height/2)
      ###
      @moveTo(@parentNode.getWidth()/2 - @width/2, 
        @parentNode.getWidth()/2 - @height/2)

  show : (parent) ->
    ###
    if @hidden
      @hidden = false
      @parent = parent if parent?
      @fitPosition()
      Game.instance.currentScene.addChild(this)
    ###

  hide : () -> 
    ###
    if !@hidden
      @hidden = true
      Game.instance.currentScene.removeChild(this)
    ###

  clone : () -> 
    obj = new Icon(@image, @width, @height)
    obj.frame = @frame 
    obj

#####################################################
# SingleTransitionTipのCV 
#####################################################
class TipParameter
  constructor : (@valueName, @value, @min, @max, @step, @id) ->
    @text = ""

  setValue : (value) ->
    @value = value
    @text = toString()
    @onValueChanged()

  getValue : () -> @value

  onValueChanged : () ->
  mkLabel : () ->

  clone : () -> @copy(new TipParameter(@valueName, @value, @min, @max, @step))
  copy : (obj) ->
    obj.valueName = @valueName
    obj.value = @value
    obj.min = @min
    obj.max = @max
    obj.step = @step
    obj.id = @id
    obj

  toString : () -> @value.toString()


