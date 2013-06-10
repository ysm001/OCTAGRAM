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

class ParameterConfigPanel extends Group 
  addParameter : (parameter) -> 
    slider = new ParameterSlider(parameter)
    slider.moveTo(slider.titleWidth, @childNodes.length * slider.getHeight())
    slider.setTitle(parameter.valueName)
    @addChild(slider)
