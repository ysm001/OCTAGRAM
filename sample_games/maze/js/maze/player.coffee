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
      
  getItem: (item) ->
    ret = null
    if item in @_items
      pos = @_items.indexOf(item)
        ret = @_items[pos]
      @_items.splice(pos, 1)
    ret
  
  addItem: (item) ->
    if !@_items?
      @_items = []
    @_items.push item

  move: () ->
    pos = @index.add(@direction)
    e = @_map.getElement(pos.x, pos.y)
    if e != false and !e.isImpassable()
        @position = e
        e.affect(@)
    @dispatchEvent(new MazeEvent('move'))

  turnLeft: () ->
    @direction = Direction.prev(@direction)
    @dispatchEvent(new MazeEvent('turnLeft'))

  turnRight: () ->
    @direction = Direction.next(@direction)
    @dispatchEvent(new MazeEvent('turnRight'))


class RobotPlayer extends Player
  @WIDTH  : 48
  @HEIGHT : 48

  constructor: (map) ->
    super RobotPlayer.WIDTH, RobotPlayer.HEIGHT, map
    @image = Game.instance.assets[R.CHAR.CHAR1]
