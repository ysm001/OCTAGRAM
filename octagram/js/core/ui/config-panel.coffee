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
    padding = slider.getHeight() / 2
    slider.moveTo(slider.titleWidth + padding, padding + @childNodes.length * (slider.getHeight() + padding))
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
