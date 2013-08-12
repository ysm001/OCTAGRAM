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
  constructor : () -> 
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

      Game.instance.vpl.ui.configPanel.setContent(this)
      Game.instance.vpl.ui.configPanel.show(tip)

      Game.instance.vpl.ui.configPanel.onClosed = (closedWithOK) =>
        if closedWithOK 
          tip.icon = tip.getIcon()
          tip.setDescription(tip.code.mkDescription())
        else 
          for param, i in tip.parameters
            param.setValue(backup[i])
            param.onParameterComplete()
