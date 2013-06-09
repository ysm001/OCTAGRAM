class Slider extends SpriteGroup#UISpriteComponent
  constructor : (@min, @max, @step, @value) ->
    super(Resources.get("slider"))

    @titleWidth = 128 
    labelPaddingY = 4
    labelPaddingX = 12

    @knob = new SliderKnob(this)
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

  setTitle : (title) -> @title.text = title

  setValue : (value) ->
    @value = value
    @onValueChanged()

  onValueChanged : () -> @setText(@value)

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

class SliderKnob extends ImageSprite 
  constructor : (@parent) ->
    super(Resources.get("sliderKnob"))
    @touchEnabled = false

