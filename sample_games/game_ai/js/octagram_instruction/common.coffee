
class InstrCommon

  class RobotDirect
    constructor : (@value, @frame) ->

  directs = [
    Direct.RIGHT
    Direct.RIGHT | Direct.DOWN
    Direct.LEFT | Direct.DOWN
    Direct.LEFT
    Direct.LEFT | Direct.UP
    Direct.RIGHT | Direct.UP
  ]

  frame = [
    0, 5, 7, 2, 6, 4
  ]
  @getRobotDirect : (i) ->
    new RobotDirect(directs[i], frame[i])

  @getDirectSize : () ->
    directs.length

  @getDirectIndex : (direct) ->
    directs.indexOf(direct)

  @getFrame : (direct) ->
    for i in [0..directs.length]
      if directs[i] == direct
        return frame[i]
    return 0

class TipInfo
  constructor: (@description) ->
    @params = {}
    @labels = {}

  addParameter : (id, column, labels, value) ->
    param =
      column : column
      labels : labels
    @labels[id] = param.labels[value]
    @params[id] = param

  changeLabel : (id, value) ->
    @labels[id] = @params[id].labels[value]

  getLabel : (id) ->
    @labels[id]
    
  getDescription : () ->
    values = (v for k, v of @labels)
    @description(values)
