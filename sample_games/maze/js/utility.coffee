class Point
  constructor: (@x = 0, @y = 0) ->

  sub: (point) ->
    @x -= point.x
    @y -= point.y
    @

  add: (point) ->
    @x += point.x
    @y += point.y
    @

class Direction
  @LEFT      = new Point(-1, 0)
  @RIGHT     = new Point(1, 0)
  @UP        = new Point(0, -1)
  @DOWN      = new Point(0, 1)
  _directs = [
    Direction.UP
    Direction.RIGHT
    Direction.DOWN
    Direction.LEFT
  ]
  _direct_len = _directs.length
  
  @next: (direct) ->
    for v, i in _directs
      return _directs[(i+1) % _direct_len] if v == direct
    return direct

  @prev: (direct) ->
    for v, i in _directs
      return _directs[(i+_direct_len-1) % _direct_len] if v == direct
    return direct


class MazeEvent extends Event
