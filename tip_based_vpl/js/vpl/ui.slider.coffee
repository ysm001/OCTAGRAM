class Slider extends UISpriteComponent
  constructor : (@min, @max, @step, @value) ->
    super(Resources.get("slider"))
    @knob = new SliderKnob(this)
    #@value = 0

    @label = new UITextComponent(this, "")#new Label("")
    labelPaddingY = 4
    labelPaddingX = 12

    @titleWidth = 128 
    @title = new UITextComponent(this, "")
    @title.moveTo(@x - @titleWidth, @y + labelPaddingY)
    @title.width = @titleWidth

    #@moveTo(x, y)
    @knob.moveTo(@x, @y + @knob.width / 2)
    @label.moveTo(@x + @width + labelPaddingX, @y + labelPaddingY)

    @knob.addEventListener('touchstart', (e) ->
    )

    @knob.addEventListener('touchmove', (e) =>
      x = e.x
      if x < @x then x = @x
      if x > (@x + @width) then x = @x + @width

      value = @positionToValue(x)
      @scroll(value)
    )

    @knob.addEventListener('touchend', (e) ->)

    @addEventListener('touchstart', (e) ->
      value = @positionToValue(e.x)
      @scroll(value)
    )
    @scroll(@value)

    LayerUtil.setOrder(this, LayerOrder.dialogUI)

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
    x = @x + @width * (val / range) 

  positionToValue : (x) ->
    normValue = (x - @x) / @width
    @min + normValue * (@max - @min)

class SliderKnob extends UISpriteComponent
  constructor : (@parent) ->
   super(Resources.get("sliderKnob"))
   LayerUtil.setOrder(this, LayerOrder.dialogUI)

