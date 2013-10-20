#####################################################
# SingleTransitionTipのCV 
#####################################################
class TipParameter
  constructor : (@valueName, @value, @min, @max, @step, @id) ->
    @text = ""

  setValue : (value) ->
    @value = value
    @text = toString()
    @onValueChanged()

  getValue : () -> @value

  onValueChanged : () ->
  onParameterComplete : () ->
  mkLabel : () ->

  #clone : () -> $.extend(true, {}, @)
  clone : () -> @copy(new TipParameter(@valueName, @value, @min, @max, @step))
  
  copy : (obj) ->
    obj.valueName = @valueName
    obj.value = @value
    obj.min = @min
    obj.max = @max
    obj.step = @step
    obj.id = @id
    obj

  toString : () -> @value.toString()

  serialize : () -> {valueName: @valueName, value: @value}
  deserialize : (serializedVal) -> @setValue(serializedVal.value)

octagram.TipParameter = TipParameter
