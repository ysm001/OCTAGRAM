###
# UI試行錯誤
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

class UITextComponent extends Label
  constructor : (@parent, text) ->
    super(text)
    @hidden = true
    @opacity = 0
    @fadeTime = 300
    @tl.setTimeBased()
    @children = []
    @font = "18px 'Meirio', 'ヒラギノ角ゴ Pro W3', sans-serif" 
    @color = "white"
    LayerUtil.setOrder(this, Environment.layer.dialogText)

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

class UIPanelFilter extends UISpriteComponent
  constructor : () ->
    super(Resources.get("panel"))
    LayerUtil.setOrder(this, Environment.layer.dialog - 1)
    #@miniPanel = new UIMiniPanel(@content, this)
    #@addChild(@miniPanel)

    #setTitle : (title) -> @miniPanel.setTitle(title)
    #setContent : (content) -> @miniPanel.setContent(content)

class UIPanel extends UISpriteComponent 
  constructor : (@content) ->
    super(Resources.get("miniPanel"))
    @label = new UITextComponent(this, "")

    @filter = new UIPanelFilter()

    @moveTo(Environment.EditorX + Environment.ScreenWidth/2 - @width/2, Environment.EditorY + Environment.EditorHeight/2 - @height/2)

    @closeButton = new UICloseButton(this)
    @okButton    = new UIOkButton(this)
    @closedWithOK = false

    LayerUtil.setOrder(this, Environment.layer.dialog)

    @okButton.moveTo(@x + @image.width/2 - @okButton.width/2, 
      @y + @image.height - @okButton.height - 24)

    @closeButton.moveTo(@x + 32, @y + 24)
    @label.moveTo(@x + 80, @y + 28)
    #@content.moveTo(@x + 90, @y + 24)
    @setContent(@content)

    @addChild(@content)
    @addChild(@closeButton)
    @addChild(@okButton)
    @addChild(@label)
    @addChild(@filter)

  setTitle : (title) -> @label.text = title
  setContent : (content) ->
    @removeChild(@content) if @content

    @content = content
    @content.moveTo(@x + 32, @y + 64)
    @addChild(@content)

  onClosed : (closedWithOK) ->

  show : (parent) ->
    @parent = parent
    GlobalUI.help.setText("")
    super()

  hide : () ->
    msg = CodeTip.selectedEffect.parent.description
    GlobalUI.help.setText(msg)
    @onClosed(@closedWithOK)
    super()

class UICloseButton extends UISpriteComponent 
  constructor : (@parent) ->
    image = Resources.get("closeButton")
    super(image)
    @image = image 
    LayerUtil.setOrder(this, Environment.layer.dialogButton)

    @addEventListener('touchstart', () =>
      @parent.closedWithOK = false
      @parent.hide()
    )

class UIOkButton extends UISpriteComponent 
  constructor : (@parent) ->
    image = Resources.get("okButton")
    super(image)
    @image = image 
    LayerUtil.setOrder(this, Environment.layer.dialogButton)

    @addEventListener('touchstart', () =>
      @parent.closedWithOK = true
      @parent.hide()
    )

class UITip extends UISpriteComponent 
  @selectedEffect = null
  @selectedInstance = null
  constructor : (@parent, @tip) ->
    super(@tip.image)
    @description = @tip.description
    @icon = @tip.icon.clone() if @tip.icon?
    LayerUtil.setOrder(this, Environment.layer.dialogButton)
    LayerUtil.setOrder(@icon, Environment.layer.dialogIcon) if @icon?

    @addEventListener('touchstart', () => 
      if !@hidden
        if @isSelected() then @doubleClicked()
        else @select()
    )

    if !UITip.selectedEffect?
      UITip.selectedEffect = new SelectedEffect() 
      LayerUtil.setOrder(UITip.selectedEffect, Environment.layer.dialogEffect)

  doubleClicked : () -> @parent.tipSelected(@tip)
  dragged : () ->
  dragEnd : () ->

  show : () ->
    super()
    if @icon?
      @icon.opacity = 0
      @icon.show(this)
      @icon.tl.setTimeBased()
      @icon.tl.fadeIn(@fadeTime)

  hide : () ->
    UITip.selectedEffect.hide()
    @icon.hide() if @icon?
    super()

  select : () ->
    GlobalUI.help.setText(@tip.description)
    UITip.selectedEffect.show(this)
    UITip.selectedInstance = this

  isSelected : () -> UITip.selectedInstance == this

class UITipSelector extends UISpriteComponent 
  constructor : (@parent) -> super(Resources.get("dummy"))

  addTip : (tip) -> 
    uiTip = new UITip(this, tip)
    uiTip.moveTo(@x + @children.length * tip.width, @y)
    @addChild(uiTip)

  tipSelected : (tip) ->
    target = @parent.parent
    idx = target.getIndex()
    evt = document.createEvent('UIEvent', false)
    evt.initUIEvent('insertNewTip', true, true)
    evt.tip = tip
    evt.x = idx.x
    evt.y = idx.y
    document.dispatchEvent(evt)
    @parent.hide()

    ###
class UITipSelector extends UISpriteComponent 
  constructor : (@parent) -> super(Resources.get("dummy"))

  add : (tip) -> 
    uiTip = new UITip(this, tip)
    uiTip.moveTo(@x + @children.length * tip.width, @y)
    @addChild(uiTip)

  tipSelected : (tip) ->
  ### 

class SelectorTip extends CodeTip
  @selectedEffect = null
  constructor : (@tip) ->
    super(@tip.code) 
    @icon = @tip.icon
    @description = @tip.description

    SelectorTip.selectedEffect = new SelectedEffect() if !SelectorTip.selectedEffect?
    LayerUtil.setOrder(this, Environment.layer.frameUI)
    LayerUtil.setOrder(SelectorTip.selectedEffect, Environment.layer.frameUIEffect)
    LayerUtil.setOrder(@icon, Environment.layer.frameUIIcon) if @icon? 

  showSelectedEffect : () -> SelectorTip.selectedEffect.show(this)
  hideSelectedEffect : () -> SelectorTip.selectedEffect.hide()

  doubleClicked : () -> 
  createGhost : () ->
    tip = super()
    LayerUtil.setOrder(tip, Environment.layer.frameUI) 
    LayerUtil.setOrder(tip.icon, Environment.layer.frameUIIcon) if tip.icon? 
    tip

  clone : () -> @tip.clone()

class SideSelectorArrow extends UISpriteComponent
  constructor : (@parent) ->
    super(Resources.get("arrow"))
    LayerUtil.setOrder(this, Environment.layer.frameUIArrow)

class SideTipSelector extends UISpriteComponent
  constructor : (x, y, @parent) -> 
    super(Resources.get("sidebar"))
    @moveTo(x, y)
    @padding = 56 
    LayerUtil.setOrder(this, Environment.layer.frameUI)
    @topArrow = new SideSelectorArrow() 
    @bottomArrow = new SideSelectorArrow() 
    @topArrow.rotate(-90)
    @bottomArrow.rotate(90)
    @topArrow.moveTo(@x + @width/2 - @topArrow.width/2, @y)
    @bottomArrow.moveTo(@x + @width/2 - @bottomArrow.width/2, 
      @y + @height - @bottomArrow.height)
    @addChild(@topArrow)
    @addChild(@bottomArrow)

    @topArrow.addEventListener('touchstart', () => @scrollUp())
    @bottomArrow.addEventListener('touchstart', () => @scrollDown())

    dummy = Resources.get("emptyTip")
    @capacity = 8 
    @scrollPosition = 0

  addTip : (tip) -> 
    uiTip = new SelectorTip(tip)
    uiTip.moveTo(@x + @padding, @y + @padding + @getTipNum() * tip.height)
    @hideOuter(uiTip)
    @addChild(uiTip)

  isOut : (tip) ->
    tip.y < (@topArrow.y + @topArrow.height/2) || tip.y > (@bottomArrow.y - @bottomArrow.height/2)

  hideOuter : (tip) ->
    opacity = if @isOut(tip) then 0 else 1
    tip.opacity = opacity 
    tip.icon.opacity = opacity if tip.icon? 

  getTipNum : () -> @children.length - 2

  isUpScrollable : () -> 
    rest = @getTipNum() - @scrollPosition
    rest > (@capacity + 1)
  isDownScrollable : () -> @scrollPosition > 0

  scrollUp : () ->
    if @isUpScrollable()
      @scrollPosition += 1
      for child in @children
        if child instanceof SelectorTip
          child.unselect()
          child.moveBy(0, -child.height)
          @hideOuter(child)

  scrollDown : () ->
    if @isDownScrollable()
      @scrollPosition -= 1
      for child in @children
        if child instanceof SelectorTip
          child.unselect()
          child.moveBy(0, child.height)
          @hideOuter(child)

class UITipConfigurator extends UISpriteComponent
  constructor : (@parent) -> super(Resources.get("dummy"))

class UITipDirectionSelector extends UITipSelector 
  constructor : (@parent, @center) -> 
    super(Resources.get("dummy"))

    left        = new UITip(TipFactory.createEmptyTip())
    right       = new UITip(TipFactory.createEmptyTip())
    top         = new UITip(TipFactory.createEmptyTip())
    bottom      = new UITip(TipFactory.createEmptyTip())
    leftTop     = new UITip(TipFactory.createEmptyTip())
    leftBottom  = new UITip(TipFactory.createEmptyTip())
    rightTop    = new UITip(TipFactory.createEmptyTip())
    rightBottom = new UITip(TipFactory.createEmptyTip())
    @center = new UITip(TipFactory.createStopTip()) 

class Pager extends UIPanel
  constructor : (@topPage) ->
    super(@topPage.content)
    @parent = null
    @next = new PagerArrow(this, @topPage.next, true)
    @prev = new PagerArrow(this, @topPage.prev, false)
    @next.moveTo(@x + @image.width - @next.width, 
                 @y + @image.height/2 - @next.image.height/2)

    @prev.moveTo(@x, 
                 @y + @image.height/2 - @prev.image.height/2)

    @next.addEventListener('touchstart', () -> @parent.toNextPage())
    @prev.addEventListener('touchstart', () -> @parent.toPrevPage())

    @addChild(@next)
    @addChild(@prev)

  changePage : (newPage) ->
    if newPage.content?
      @setContent(newPage.content)
      @setTitle(newPage.title)
      @setNextPage(newPage.next)
      @setPrevPage(newPage.prev)
      @next.update()
      @prev.update()

  show : (parent) -> 
    super()
    @changePage(@topPage)
    @parent = parent

  setNextPage : (page) -> @next.content = page
  setPrevPage : (page) -> @prev.content = page

  toNextPage : () -> 
    @content.hide()
    @changePage(@next.content)
    @content.show()

  toPrevPage : () -> 
    @content.hide()
    @changePage(@prev.content)
    @content.show()

class Page 
  constructor : (@content, @title) ->
    @nextPage = null 
    @prevPage = null 

class PagerArrow extends UISpriteComponent
  constructor : (@parent, @content, isRightArrow) ->
    super(Resources.get("arrow"))
    @scaleX = -1 if !isRightArrow
    LayerUtil.setOrder(this, Environment.layer.dialogButton)

  show : () -> super() if @content?

  update : () ->
    @show() if @content? && @hidden
    @hide() if !@content? && !@hidden

class UIPanelContent extends UISpriteComponent 
  constructor : (@parent) ->
    super(Resources.get("dummy"))
    @addEventListener('enterframe', ()->
      moveTo(@parent.x, @parent.y)
    )

class UIConfigWindow extends UISpriteComponent
  constructor : (@parent) -> 
    super(Resources.get("dummy"))

  show : (target) ->
    super()

class RingMenu extends UISpriteComponent
  constructor : (@parent) ->

class HelpPanel extends Sprite
  constructor : (x, y, w, h, @text) ->
    super(w, h)
    @image = Resources.get("helpPanel")
    @label = new Label(@text)
    @label._element = document.createElement("div")
    @label.text = @text
    @x = x
    @y = y
    @label.width = w
    @label.height = h
    @label.x = @x + 16 
    @label.y = @y + 16
    @label.font = "18px 'Meirio', 'ヒラギノ角ゴ Pro W3', sans-serif" 
    @label.color = "white"
    LayerUtil.setOrder(this, Environment.layer.messageWindow)
    LayerUtil.setOrder(@label, Environment.layer.messageText)

  mkMsgHtml : (text) -> "<div class='msg'>" + text + "</div>"

  show : () ->
    Game.instance.currentScene.addChild(this)
    Game.instance.currentScene.addChild(@label)

  setText : (text) -> @label.text = @mkMsgHtml(text)
  getText : () -> @label.text

class Frame
  constructor : (x, y) ->
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

    LayerUtil.setOrder(@top,    Environment.layer.frame)
    LayerUtil.setOrder(@left,   Environment.layer.frame)
    LayerUtil.setOrder(@right,  Environment.layer.frame)
    LayerUtil.setOrder(@bottom, Environment.layer.frame)

  show : () ->
    Game.instance.currentScene.addChild(@top)
    Game.instance.currentScene.addChild(@bottom)
    Game.instance.currentScene.addChild(@left)
    Game.instance.currentScene.addChild(@right)
