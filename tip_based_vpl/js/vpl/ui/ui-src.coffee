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

    @closeButton.moveTo(32, 24)
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

class UICloseButton extends ImageSprite
  constructor : (@parent) ->
    super(Resources.get("closeButton"))

    @addEventListener('touchstart', () =>
      @parent.hide(false)
    )

class UIOkButton extends ImageSprite 
  constructor : (@parent) ->
    super(Resources.get("okButton"))

    @addEventListener('touchstart', () =>
      @parent.hide(true)
    )

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

class ParameterSlider extends Slider
  constructor : (@parameter) ->
    super(@parameter.min, @parameter.max, @parameter.step, @parameter.value)

  show : () ->
    @scroll(@parameter.getValue())
    super()

  setText : () ->
    super(@parameter.mkLabel())

  onValueChanged : () -> 
    @parameter.setValue(@value)
    @setText(@parameter.mkLabel())

class ParameterConfigPanel extends SpriteGroup 
  constructor : (@target) -> 
    super()

  addParameter : (parameter) -> 
    slider = new ParameterSlider(parameter)
    slider.moveTo(slider.titleWidth, @childNodes.length * slider.getHeight())
    slider.setTitle(parameter.valueName)
    @addChild(slider)

  show : (tip) ->
    if tip.parameters? and tip.parameters.length > 0
      backup = {}
      
      for param, i in tip.parameters
        backup[i] = param.getValue()

        if !param._onValueChanged?
          param._onValueChanged = param.onValueChanged
          param.onValueChanged = () ->
            @_onValueChanged()
            tip.setDescription(tip.code.mkDescription())

        @addParameter(param)

      @target.ui.configPanel.setContent(this)
      @target.ui.configPanel.show(tip)

      @target.ui.configPanel.onClosed = (closedWithOK) =>
        if closedWithOK 
          tip.icon = tip.getIcon()
          tip.setDescription(tip.code.mkDescription())
        else 
          for param, i in tip.parameters
            param.setValue(backup[i])
            param.onParameterComplete()


class SideTipSelector extends EntityGroup
  VISIBLE_TIP_COUNT = 8

  constructor: (x, y) ->
    super(160, 500)

    @moveTo(x, y)
    @scrollPosition = 0


    # create background
    background = new ImageSprite(Resources.get('sidebar'))
    @addChild(background)


    tipHeight = Resources.get("emptyTip").height

    # create top arrow
    @topArrow = new ImageSprite(Resources.get('arrow'))
    @topArrow.rotate(-90)
    @topArrow.moveTo((@width - @topArrow.width) / 2, 0)
    @topArrow.on(Event.TOUCH_START, =>
      return if @scrollPosition <= 0
      @scrollPosition -= 1
      @tipGroup.moveBy(0, tipHeight)
      @_updateVisibility()
    )
    @addChild(@topArrow)


    # create bottom arrow
    @bottomArrow = new ImageSprite(Resources.get('arrow'))
    @bottomArrow.rotate(90)
    @bottomArrow.moveTo((@width - @bottomArrow.width)/2, @height - @bottomArrow.height)
    @bottomArrow.on(Event.TOUCH_START, =>
      return if @scrollPosition > @_getTipCount() - VISIBLE_TIP_COUNT - 1
      @scrollPosition += 1
      @tipGroup.moveBy(0, -tipHeight)
      @_updateVisibility()
    )
    @addChild(@bottomArrow)


    # create tip group
    @createTipGroup()
    @addChild(@tipGroup)

  createTipGroup: () ->
    @tipGroup = new EntityGroup(64, 0)
    @tipGroup.backgroundColor = '#ff0000'
    @tipGroup.moveTo(@topArrow.x, @topArrow.y + @topArrow.height)


  addTip: (tip) ->
    tipCount = @_getTipCount()

    uiTip = tip.clone()
    uiTip.setVisible(false) if tipCount >= VISIBLE_TIP_COUNT
    uiTip.moveTo(8, -6 + tipCount * tip.getHeight())

    @tipGroup.addChild(uiTip)


  _getTipCount: ->
    @tipGroup.childNodes.length


  _updateVisibility: ->
    update = (index, flag) =>
      @tipGroup.childNodes[index].setVisible(flag) if 0 <= index < @_getTipCount()

    # hide outside
    update(@scrollPosition - 1, false)
    update(@scrollPosition + VISIBLE_TIP_COUNT, false)

    # show inside
    update(@scrollPosition, true)
    update(@scrollPosition + VISIBLE_TIP_COUNT - 1, true)

  clearTip: () ->
    @removeChild(@tipGroup)
    @createTipGroup()
    @addChild(@tipGroup)

    @scrollPosition = 0

class Slider extends SpriteGroup
  constructor : (@min, @max, @step, @value) ->
    super(Resources.get("slider"))

    @titleWidth = 128 
    labelPaddingY = 4
    labelPaddingX = 12

    @knob = new ImageSprite(Resources.get("sliderKnob"))
    @knob.touchEnabled = false

    @label = new TextLabel("")
    @title = new TextLabel("")

    @knob.moveTo(0, @knob.width / 2)
    @title.moveTo(-@titleWidth, labelPaddingY)
    @label.moveTo(@getWidth() + labelPaddingX, labelPaddingY)

    @title.width = @titleWidth

    @scroll(@value)

    @addChild(@sprite)
    @addChild(@knob)
    @addChild(@label)
    @addChild(@title)

  ontouchstart : (e) ->
    x = e.x - @getAbsolutePosition().x
    value = @positionToValue(x)
    @scroll(value)

  ontouchmove : (e) ->
    x = e.x - @getAbsolutePosition().x
    if x < 0 then x = 0 
    if x > @getWidth() then x = @getWidth()

    value = @positionToValue(x)
    @scroll(value)

  onValueChanged : () -> @setText(@value)

  setTitle : (title) -> @title.text = title

  setValue : (value) ->
    @value = value
    @onValueChanged()

  setText : (text) -> @label.text = text

  scroll : (value) ->
    @value = @adjustValue(value)
    x = @valueToPosition(@value)
    @knob.moveTo(x - @knob.width/2, @knob.height / 2)
    @onValueChanged()

  adjustValue : (value) ->
    nearestValue = @min
    nearestDist = 0xffffffff

    for i in [@min..@max] by @step
      dist = Math.abs(value - i)
      if dist < nearestDist
        nearestDist = dist
        nearestValue = i

    nearestValue

  valueToPosition : (value) ->
    range = @max - @min
    val = value - @min
    x = @getWidth() * (val / range) 

  positionToValue : (x) ->
    normValue = x / @getWidth()
    @min + normValue * (@max - @min)

