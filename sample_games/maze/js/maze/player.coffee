R = Config.R

class Player extends Sprite
  constructor: (width, height, @_map) ->
    super width, height
    Object.defineProperties @, @properties
    @index = new Point()
    @position = @_map.startElement
    @direction = Direction.UP

  properties:
    position:
      get: () -> null
      set: (e) ->
        point = @_map.toPoint(e)
        @x = point.x
        @y = point.y
        @index.x = e.index.x
        @index.y = e.index.y
    direction:
      get: () -> @_direction
      set: (direction) -> @_direction = direction

  move: () ->
    pos = @index.add(@direction)
    e = @_map.getElement(pos.x, pos.y)
    if e != false and !e.isImpassable()
        @position = e
        # if @_isGoal(e)
    @dispatchEvent(new MazeEvent('move'))

  turnLeft: () ->
    @direction = Direction.prev(@direction)

  turnRight: () ->
    @direction = Direction.next(@direction)

  _isStart: (e) ->
    e? and e == @_map.startElement

  _isGoal: (e) ->
    e? and e == @_map.goalElement
    

class RobotPlayer extends Player
  @WIDTH  : 16
  @HEIGHT : 16

  constructor: (map) ->
    super RobotPlayer.WIDTH, RobotPlayer.HEIGHT, map
    @image = Game.instance.assets[R.CHAR.CHAR1]
