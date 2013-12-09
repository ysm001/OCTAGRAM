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
      set: (direction) ->
        @_direction = direction
        switch direction
          when Direction.UP
            @frame = 3
          when Direction.RIGHT
            @frame = 2
          when Direction.DOWN
            @frame = 0
          when Direction.LEFT
            @frame = 1

  move: () ->
    pos = @index.add(@direction)
    e = @_map.getElement(pos.x, pos.y)
    if e != false and !e.isImpassable()
        @position = e
        if @_isGoal(e)
          @dispatchEvent(new MazeEvent('goal'))
    @dispatchEvent(new MazeEvent('move'))

  turnLeft: () ->
    @direction = Direction.prev(@direction)
    @dispatchEvent(new MazeEvent('turnLeft'))

  turnRight: () ->
    @direction = Direction.next(@direction)
    @dispatchEvent(new MazeEvent('turnRight'))

  isThrough: (direction) ->
    switch direction
      when Direction.LEFT
        d = Direction.prev(@direction)
      when Direction.RIGHT
        d = Direction.next(@direction)
      else
        d = @direction
    pos = @index.add(d)
    e = @_map.getElement(pos.x, pos.y)
    e != false and e.isImpassable() == 0

  _isStart: (e) ->
    e? and e == @_map.startElement

  _isGoal: (e) ->
    e? and e == @_map.goalElement
    

class RobotPlayer extends Player
  @WIDTH  : 48
  @HEIGHT : 48

  constructor: (map) ->
    super RobotPlayer.WIDTH, RobotPlayer.HEIGHT, map
    @image = Game.instance.assets[R.CHAR.CHAR1]
