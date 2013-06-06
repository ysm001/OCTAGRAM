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

class ParameterConfigPanel extends UISpriteComponent
  constructor : () ->
    super(Resources.get("dummy"))

  addParameter : (parameter) -> 
    slider = new ParameterSlider(parameter)
    slider.moveTo(@x + slider.titleWidth, @y + @children.length * slider.height)
    slider.setTitle(parameter.valueName)
    @addChild(slider)

  clear : () -> @children = []
