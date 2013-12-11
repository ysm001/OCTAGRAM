R = Config.R

class Player extends Sprite
  constructor: (width, height, @_map) ->
    super width, height
    Object.defineProperties @, @properties
    @index = new Point()
    @_moveDirect(@_map.startTile)
    @direction = Direction.UP

  properties:
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

  _moveDirect: (tile) ->
    point = @_map.toPoint(tile)
    @x = point.x
    @y = point.y
    @index.x = tile.index.x
    @index.y = tile.index.y

  _move: (tile, onComplete) ->
    point = @_map.toPoint(tile)
    @tl.moveTo(point.x, point.y, 0).then () =>
      @index.x = tile.index.x
      @index.y = tile.index.y
      tile.onride(@)
      @dispatchEvent(new MazeEvent('move'))
      onComplete()

  initPosition: (@_map, tile) ->
    @_moveDirect(tile)
      
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
    tile = @_map.getTile(pos.x, pos.y)
    if tile != false
      #if tile.checkRequiredItems(@)
      #  tile.changePassable(@)
      tile.check(@)
      if tile.isThrough()
        @_move(tile, onComplete)
        ret = true
    ret

  turnLeft: () ->
    @direction = Direction.prev(@direction)
    @dispatchEvent(new MazeEvent('turnLeft'))

  turnRight: () ->
    @direction = Direction.next(@direction)
    @dispatchEvent(new MazeEvent('turnRight'))

  canMove: (direction) ->
    switch direction
      when Direction.LEFT
        d = Direction.prev(@direction)
      when Direction.RIGHT
        d = Direction.next(@direction)
      else
        d = @direction
    pos = @index.add(d)
    tile = @_map.getTile(pos.x, pos.y)
    if tile != false
      tile.check(@)
      ret = tile.isThrough()
    ret

class RobotPlayer extends Player
  @WIDTH  : 48
  @HEIGHT : 48

  constructor: (map) ->
    super RobotPlayer.WIDTH, RobotPlayer.HEIGHT, map
    @image = Game.instance.assets[R.CHAR.CHAR1]
