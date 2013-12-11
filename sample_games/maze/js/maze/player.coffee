R = Config.R

class Player extends Sprite
  constructor: (width, height, @_map) ->
    super width, height
    Object.defineProperties @, @properties
    @index = new Point()
    @_moveDirect(@_map.startElement)
    @direction = Direction.UP

  properties:
    position:
      get: () -> null
      set: (e) ->
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

  _moveDirect: (e) ->
    point = @_map.toPoint(e)
    @x = point.x
    @y = point.y
    @index.x = e.index.x
    @index.y = e.index.y

  _move: (e, onComplete) ->
    point = @_map.toPoint(e)
    @tl.moveTo(point.x, point.y, 5).then () =>
      @index.x = e.index.x
      @index.y = e.index.y
      e.onride(@)
      @dispatchEvent(new MazeEvent('move'))
      onComplete()
      
  getItem: (item) ->
    ret = null    
    if @hasItem(item)
      pos = @_items.indexOf(item)
      ret = @_items[pos]
      @_items.splice(pos, 1)
    console.log "getItem", item, @_items
    ret

  hasItem: (item) ->
    @_items? and @_items.reduce ((ret,i) -> ret or item.name == i.name), true
  
  addItem: (item) ->
    if !@_items?
      @_items = []
    @_items.push item
    console.log "addItem", item, @_items

  move: (onComplete = () ->) ->
    ret = false
    pos = @index.add(@direction)
    e = @_map.getElement(pos.x, pos.y)
    if e != false
      if e.checkRequiredItems(@)
        e.changePassable(@)
      if !e.isImpassable
        @_move(e, onComplete)
        ret = true
    ret

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
    e != false and e.isImpassable == 0

class RobotPlayer extends Player
  @WIDTH  : 48
  @HEIGHT : 48

  constructor: (map) ->
    super RobotPlayer.WIDTH, RobotPlayer.HEIGHT, map
    @image = Game.instance.assets[R.CHAR.CHAR1]
