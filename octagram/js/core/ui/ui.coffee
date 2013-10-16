class TextLabel extends Label
  constructor : (text) ->
    super(text)
    @font = "18px 'Meirio', 'ヒラギノ角ゴ Pro W3', sans-serif" 
    @color = "white"

class UIPanel extends SpriteGroup
  constructor : (content) -> 
    super(Resources.get("panel"))
    @body = new UIPanelBody(this, content)

    @addChild(@sprite)
    @addChild(@body)
    @setContent(content)

  setTitle : (title) -> @body.label.text = title
  setContent : (content) -> @body.setContent(content)

  onClosed : (closedWithOK) ->

  show : (parent) ->
    Game.instance.currentScene.addChild(this)

  hide : (closedWithOK) ->
    @onClosed(closedWithOK)
    Game.instance.currentScene.removeChild(this)

class UIPanelBody extends SpriteGroup 
  constructor : (@parent, @content) ->
    super(Resources.get("miniPanel"))
    @label = new TextLabel("")

    @moveTo(Environment.EditorX + Environment.ScreenWidth/2 - @getWidth()/2,
      Environment.EditorY + Environment.EditorHeight/2 - @getHeight()/2)

    @closeButton = new UICloseButton(@parent)
    @okButton    = new UIOkButton(@parent)
    @closedWithOK = false

    @okButton.moveTo(@getWidth()/2 - @okButton.width/2, 
      @getHeight() - @okButton.height - 24)

    @closeButton.moveTo(32, 19)
    @label.moveTo(80, 28)
    @content.moveTo(90, 24)

    @addChild(@sprite)
    @addChild(@closeButton)
    @addChild(@okButton)
    @addChild(@label)


  setContent : (content) ->
    @removeChild(@content) if @content

    @content = content
    @content.moveTo(32, 64)
    @addChild(content)

class UIButton extends ImageSprite
  constructor : (image) ->
    super(image, image.width / 2, image.height)

  ontouchstart : () =>
    @frame = 1;

  ontouchend : () =>
    @frame = 0;
    @onClicked()

  onClicked : () ->

class UICloseButton extends UIButton
  constructor : (@parent) ->
    super(Resources.get("closeButton"))

  onClicked : () => @parent.hide(false)

class UIOkButton extends UIButton 
  constructor : (@parent) ->
    super(Resources.get("okButton"))

  onClicked : () => @parent.hide(true)

class HelpPanel extends SpriteGroup
  constructor : (x, y, w, h, @text) ->
    super(Resources.get("helpPanel"))
    @label = new TextLabel(@text)
    @moveTo(x, y)

    @label.width = w
    @label.height = h
    @label.x = 16 
    @label.y = 16

    @addChild(@sprite)
    @addChild(@label)

  setText : (text) -> @label.text = text
  getText : () -> @label.text

class Frame extends ImageSprite 
  constructor : () ->
    super(Resources.get("frame"))
    @touchEnabled = false
