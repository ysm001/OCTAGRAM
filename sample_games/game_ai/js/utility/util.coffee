

toi = (i) ->
  parseInt(i)


class RobotEvent extends enchant.Event

  constructor: (type, @params = {}) ->
    super(type)

class Direct
  bit = 1
  @LEFT = bit << 0
  @RIGHT = bit << 1
  @UP = bit << 2
  @DOWN = bit << 3
  _directs = [
    Direct.RIGHT
    Direct.RIGHT | Direct.DOWN
    Direct.LEFT | Direct.DOWN
    Direct.LEFT
    Direct.LEFT | Direct.UP
    Direct.RIGHT | Direct.UP
  ]
  @each : (func) ->
    for i in _directs
      func(i)
  
  @next: (direct) ->
    for v, i in _directs
      return _directs[(i+1) % _directs.length] if v == direct
    return direct

class Point
  constructor : (@x, @y) ->

  length : () ->
    Math.sqrt(@x*@x+@y*@y)


class Util

  @toMillisec : (frame) ->
    frame * 1000 / Game.instance.fps

  @includedAngle: (vec1, vec2) ->
    tmp = 1
    if (vec1.y * vec2.x - vec1.x * vec2.y ) < 0
      tmp *= -1
    dot = (vec1.x * vec2.x + vec1.y * vec2.y)
    len1 = Math.sqrt(vec1.x * vec1.x + vec1.y * vec1.y)
    len2 = Math.sqrt(vec2.x * vec2.x + vec2.y * vec2.y)
    tmp * Math.acos(dot/(len1*len2))


  @lengthPointToPoint : (p1, p2) ->
    x = Math.abs(p1.x - p2.x)
    y = Math.abs(p1.y - p2.y)
    Math.sqrt(x*x + y*y)

  @toDeg: (r) ->
    r * 180.0 / (Math.atan(1.0) * 4.0)

  @toRad: (deg) ->
    deg * Math.PI / 180

  @toCartesianCoordinates: (r, rad) ->
    return new Point(r * Math.cos(rad), r * Math.sin(rad))

  @dispatchEvent : (name, hash) ->
    evt = document.createEvent('UIEvent', false)
    evt.initUIEvent(name, true, true)
    for k, v of hash
      evt[k] = v
    document.dispatchEvent(evt)


class Stack

  constructor: (@maxSize) ->
    @s = []

  push: (item) ->
    @s.push item if @maxSize >= @s.length

  pop: () ->
    @s.pop() if @s.length > 0

  size: () ->
    @s.length
