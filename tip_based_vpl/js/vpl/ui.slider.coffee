class Slider extends SpriteGroup#UISpriteComponent
  constructor : (@min, @max, @step, @value) ->
    super(Resources.get("slider"))
    @knob = new SliderKnob(this)
    #@value = 0

    @label = new UITextComponent(this, "")#new Label("")
    labelPaddingY = 4
    labelPaddingX = 12

    @titleWidth = 128 
    @title = new UITextComponent(this, "")
    @title.moveTo(- @titleWidth, labelPaddingY)
    @title.width = @titleWidth

    #@moveTo(x, y)
    @knob.moveTo(0, @knob.width / 2)
    @label.moveTo(@getWidth() + labelPaddingX, labelPaddingY)

    @knob.addEventListener('touchstart', (e) ->
    )

    @knob.addEventListener('touchmove', (e) =>
      x = e.x - @getAbsolutePosition().x
      if x < 0 then x = 0 
      if x > @getWidth() then x = @getWidth()

      value = @positionToValue(x)
      @scroll(value)
    )

    @knob.addEventListener('touchend', (e) ->)

    @addEventListener('touchstart', (e) ->
      x = e.x - @getAbsolutePosition().x
      value = @positionToValue(x)
      @scroll(value)
    )
    @scroll(@value)

    LayerUtil.setOrder(this, LayerOrder.dialogUI)

    @addChild(@sprite)
    @addChild(@knob)
    @addChild(@label)
    @addChild(@title)

  setTitle : (title) -> @title.text = title

  setValue : (value) ->
    @value = value
    @onValueChanged()

  onValueChanged : () -> @setText(@value)

  setText : (text) -> @label.text = text

  scroll : (value) ->
    @value = @adjustValue(value)
    x = @valueToPosition(@value)
    @knob.moveTo(x - @knob.width/2, @y + @knob.height / 2)
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

class SliderKnob extends Sprite 
  constructor : (@parent) ->
    image = Resources.get("sliderKnob")
    super(image.width, image.height)
    @image = image
    LayerUtil.setOrder(this, LayerOrder.dialogUI)

