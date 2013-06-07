###
# UI試行錯誤
###

###
class UISpriteComponent extends Sprite
  constructor : (image) ->
    super(image.width, image.height) if image?
    @image = image
    @children = [] 
    @hidden = true
    @opacity = 0
    @fadeTime = 300
    @tl.setTimeBased()

  show : () ->
    if @hidden
      Game.instance.currentScene.addChild(this)
      @hidden = false
      @tl.fadeIn(@fadeTime)

      for child in @children
        child.show()

  hide : () ->
    if !@hidden
      @hidden = true
      @tl.fadeOut(@fadeTime).then(() -> 
        Game.instance.currentScene.removeChild(this)
      )

      for child in @children
        child.hide()

  addChild : (child) ->
    child.tl.setTimeBased()
    @children.push(child)

  removeChild : (child) ->
    idx = @children.indexOf(child)
    @children.splice(idx, 1) if idx != -1

  moveTo : (x, y) ->
    for child in @children
      dx = child.x - @x
      dy = child.y - @y
      child.moveTo(x + dx, y + dy)

    super(x, y)
###
#
class UITextComponent extends Label
  constructor : (@parent, text) ->
    super(text)
    #@hidden = true
    #@opacity = 0
    #@fadeTime = 300
    #@tl.setTimeBased()
    #@children = []
    @font = "18px 'Meirio', 'ヒラギノ角ゴ Pro W3', sans-serif" 
    @color = "white"
    LayerUtil.setOrder(this, LayerOrder.dialogText)

    ###
  show : () ->
    if @hidden
      Game.instance.currentScene.addChild(this)
      @hidden = false
      @tl.fadeIn(@fadeTime)

      for child in @children
        child.show()

  hide : () ->
    @hidden = true
    @tl.fadeOut(@fadeTime).then(() -> 
      Game.instance.currentScene.removeChild(this)
    )

    for child in @children
      child.hide()
      ###

###
class UITipConfigurator extends UISpriteComponent
  constructor : (@parent) -> super(Resources.get("dummy"))
###

class UIPanel extends SpriteGroup
  constructor : (content) -> 
    super(Resources.get("panel"))
    @body = new UIPanelBody(content)

    @addChild(@sprite)
    @addChild(@body)
    @setContent(content)

  setTitle : (title) -> @body.label.text = title
  setContent : (content) ->
    @body.removeChild(@body.content) if @body.content

    @body.content = content
    @body.content.moveTo(32, 64)
    @body.addChild(content)

  onClosed : (closedWithOK) ->

  show : (parent) ->
    Game.instance.currentScene.addChild(this)

  hide : () ->
    @onClosed(@body.closedWithOK)
    Game.instance.currentScene.removeChild(this)

###
class UIPanelBack extends Sprite 
  constructor : () ->
    image = Resources.get("panel")
    super(image.width, image.height)
    @image = image
    LayerUtil.setOrder(this, LayerOrder.dialog - 1)
###

class UIPanelBody extends SpriteGroup 
  constructor : (@content) ->
    super(Resources.get("miniPanel"))
    @label = new UITextComponent(this, "")

    #@filter = new UIPanelFilter()

    @moveTo(Environment.EditorX + Environment.ScreenWidth/2 - @getWidth()/2,
      Environment.EditorY + Environment.EditorHeight/2 - @getHeight()/2)

    @closeButton = new UICloseButton(this)
    @okButton    = new UIOkButton(this)
    @closedWithOK = false

    LayerUtil.setOrder(this, LayerOrder.dialog)

    @okButton.moveTo(@getWidth()/2 - @okButton.width/2, 
      @getHeight() - @okButton.height - 24)

    @closeButton.moveTo(32, 24)
    @label.moveTo(80, 28)
    @content.moveTo(90, 24)

    #@addChild(@filter)
    @addChild(@sprite)
    #@addChild(@content)
    #@setContent(@content)
    @addChild(@closeButton)
    @addChild(@okButton)
    @addChild(@label)

  show : (parent) ->
    ###
    @parent = parent
    GlobalUI.help.setText("")
    ###
    #parent.addChild(this)
    #super()
    Game.instance.currentScene.addChild(this)

  hide : () ->
    ###
    msg = CodeTip.selectedEffect.parent.description
    GlobalUI.help.setText(msg)
    @onClosed(@closedWithOK)
    super()
    ###
    #parent.removeChild(this)
    #Game.instance.currentScene.removeChild(this)
    @parentNode.hide()

class UICloseButton extends Sprite
  constructor : (@parent) ->
    image = Resources.get("closeButton")
    super(image.width, image.height)
    @image = image 
    LayerUtil.setOrder(this, LayerOrder.dialogButton)

    @addEventListener('touchstart', () =>
      @parentNode.closedWithOK = false
      @parentNode.hide()
    )

class UIOkButton extends Sprite 
  constructor : (@parent) ->
    image = Resources.get("okButton")
    super(image.width, image.height)
    @image = image 
    LayerUtil.setOrder(this, LayerOrder.dialogButton)

    @addEventListener('touchstart', () =>
      @parentNode.closedWithOK = true
      @parentNode.hide()
    )

###
class SelectorTip extends CodeTip
  @selectedEffect = null
  constructor : (@tip) ->
    super(@tip.code) 

    if @tip.icon?
      @icon = @tip.icon.clone()
      @icon.parent = this

    @description = @tip.description

    SelectorTip.selectedEffect = new SelectedEffect() if !SelectorTip.selectedEffect?
    LayerUtil.setOrder(this, LayerOrder.frameUI)
    LayerUtil.setOrder(SelectorTip.selectedEffect, LayerOrder.frameUIEffect)
    LayerUtil.setOrder(@icon, LayerOrder.frameUIIcon) if @icon? 

  showSelectedEffect : () -> SelectorTip.selectedEffect.show(this)
  hideSelectedEffect : () -> SelectorTip.selectedEffect.hide()

  doubleClicked : () -> 
  createGhost : () ->
    tip = super()
    LayerUtil.setOrder(tip, LayerOrder.frameUI) 
    LayerUtil.setOrder(tip.icon, LayerOrder.frameUIIcon) if tip.icon? 
    tip

  clone : () -> @tip.clone()
###
class SideSelectorArrow extends GroupedSprite
  constructor : (@parent) ->
    image = Resources.get("arrow")
    super(image.width, image.height)
    @image = image
    LayerUtil.setOrder(this, LayerOrder.frameUIArrow)

class SideTipSelector extends SpriteGroup#UISpriteComponent
  constructor : (x, y, @parent) -> 
    super(Resources.get("sidebar"))
   
    @tipGroup = new Group()

    @moveTo(x, y)
    @padding = 56 
    LayerUtil.setOrder(this, LayerOrder.frameUI)
    @topArrow = new SideSelectorArrow() 
    @bottomArrow = new SideSelectorArrow() 
    @topArrow.rotate(-90)
    @bottomArrow.rotate(90)
    @topArrow.moveTo(@sprite.width/2 - @topArrow.width/2, 0)
    @bottomArrow.moveTo(@sprite.width/2 - @bottomArrow.width/2, 
      @sprite.height - @bottomArrow.height)

    @addChild(@sprite)
    @addChild(@tipGroup)
    @addChild(@topArrow)
    @addChild(@bottomArrow)

    @topArrow.addEventListener('touchstart', () => @scrollDown())
    @bottomArrow.addEventListener('touchstart', () => @scrollUp())

    @capacity = 8 
    @scrollPosition = 0

  addTip : (tip) -> 
    uiTip = tip.clone()#new SelectorTip(tip)
    uiTip.moveTo(@padding, @padding + @getTipNum() * tip.sprite.height)
    #@hideOuter(uiTip)
    uiTip.setVisible(false)
    @tipGroup.addChild(uiTip)
    @updateVisibility()
    #LayerUtil.setOrder(uiTip.icon, LayerOrder.frameUITip) if uiTip.icon

  isOut : (tip) ->
    tip.y < (@topArrow.y + @topArrow.height/2) || tip.y > (@bottomArrow.y - @bottomArrow.height/2)

  hideOuter : (tip) ->
    opacity = if @isOut(tip) then 0 else 1
    tip.opacity = opacity 
    tip.icon.opacity = opacity if tip.icon? 

  updateVisibility : () ->
    for tip, i in @tipGroup.childNodes
      tip.setVisible(!@isOuterIndex(i))

  isOuterIndex : (index) ->
    index < @scrollPosition || index >= (@capacity + @scrollPosition)

  getTipNum : () -> @tipGroup.childNodes.length#@children.length - 2

  isUpScrollable : () -> 
    rest = @getTipNum() - @scrollPosition
    rest > @capacity

  isDownScrollable : () -> @scrollPosition > 0

  ###
  show : () ->
    super()
    for child in GlobalUI.side.children
      if child.icon?
        LayerUtil.setOrder(child.icon, LayerOrder.frameUIIcon)
  ###

  scrollUp : () ->
    if @isUpScrollable()
      @scrollPosition += 1
      @tipGroup.moveBy(0, -Resources.get("emptyTip").height)
      @updateVisibility()
      ###
      for child in @tipGroup.childNodes
        child.unselect()
        child.moveBy(0, -child.getHeight())
        @hideOuter(child)
      ###

  scrollDown : () ->
    if @isDownScrollable()
      @scrollPosition -= 1
      @tipGroup.moveBy(0, Resources.get("emptyTip").height)
      @updateVisibility()
      ###
      for child in @tipGrou.childNodes
        if child instanceof SelectorTip
          child.unselect()
          child.moveBy(0, child.height)
          @hideOuter(child)
      ###

###
class UIConfigWindow extends UISpriteComponent
  constructor : (@parent) -> 
    super(Resources.get("dummy"))

  show : (target) ->
    super()
###

class HelpPanel extends Group
  constructor : (x, y, w, h, @text) ->
    super()
    @sprite = new Sprite(w, h)
    @sprite.image = Resources.get("helpPanel")
    @label = new Label(@text)
    @label._element = document.createElement("div")
    @label.text = @text
    @x = x
    @y = y
    @label.width = w
    @label.height = h
    @label.x = 16 
    @label.y = 16
    @label.font = "18px 'Meirio', 'ヒラギノ角ゴ Pro W3', sans-serif" 
    @label.color = "white"
    @addChild(@sprite)
    @addChild(@label)
    #LayerUtil.setOrder(this, LayerOrder.messageWindow)
    #LayerUtil.setOrder(@label, LayerOrder.messageText)

  mkMsgHtml : (text) -> "<div class='msg'>" + text + "</div>"

  ###
  show : () ->
    Game.instance.currentScene.addChild(this)
    Game.instance.currentScene.addChild(@label)
  ###

  setText : (text) -> @label.text = @mkMsgHtml(text)
  getText : () -> @label.text

class Frame extends Group
  constructor : (x, y) ->
    super()
    frameWidth = 640
    frameHeight = 640
    contentWidth = 480
    contentHeight = 480
    borderWidth = 16
    borderHeight = 16

    @top    = new Sprite(frameWidth, borderWidth)
    @bottom = new Sprite(frameWidth, frameHeight - contentHeight - borderHeight)
    @left   = new Sprite(borderWidth, frameHeight)
    @right  = new Sprite(frameWidth - contentWidth - borderWidth, frameHeight)

    @top.image    = Resources.get("frameTop")
    @bottom.image = Resources.get("frameBottom")
    @left.image   = Resources.get("frameLeft")
    @right.image  = Resources.get("frameRight")

    @top.moveTo(x, y)
    @bottom.moveTo(x, y + borderHeight + contentHeight)
    @left.moveTo(x, y)
    @right.moveTo(borderWidth + contentWidth, y)

    @addChild(@top)
    @addChild(@bottom)
    @addChild(@left)
    @addChild(@right)

    ###
    LayerUtil.setOrder(@top,    LayerOrder.frame)
    LayerUtil.setOrder(@left,   LayerOrder.frame)
    LayerUtil.setOrder(@right,  LayerOrder.frame)
    LayerUtil.setOrder(@bottom, LayerOrder.frame)
    ###

    ###
  show : () ->
    Game.instance.currentScene.addChild(@top)
    Game.instance.currentScene.addChild(@bottom)
    Game.instance.currentScene.addChild(@left)
    Game.instance.currentScene.addChild(@right)
    ###
