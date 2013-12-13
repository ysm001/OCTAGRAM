R = Config.R

class Player extends Sprite
  @SEARCH_FRAME : 12
  @MOVE_FRAME : 16

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
            @rotation = 0
          when Direction.RIGHT
            @rotation = 90
          when Direction.DOWN
            @rotation = 180
          when Direction.LEFT
            @rotation = -90

  _moveDirect: (tile) ->
    point = @_map.toPoint(tile)
    @x = point.x
    @y = point.y
    @index.x = tile.index.x
    @index.y = tile.index.y

  _move: (tile, onComplete) ->
    point = @_map.toPoint(tile)
    @tl.moveTo(point.x, point.y, Player.MOVE_FRAME/SPEED).then () =>
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
    @rotate(-90)
    @direction = Direction.prev(@direction)
    @dispatchEvent(new MazeEvent('turnLeft'))

  turnRight: () ->
    @rotate(90)
    @direction = Direction.next(@direction)
    @dispatchEvent(new MazeEvent('turnRight'))

  canMove: (direction, onComplete = () ->) ->
    switch direction
      when Direction.LEFT
        d = Direction.prev(@direction)
      when Direction.RIGHT
        d = Direction.next(@direction)
      else
        d = @direction
    pos = @index.add(d)
    tile = @_map.getTile(pos.x, pos.y)
    search = new SearchEffect(pos.x*MazeMap.TILE_WIDTH, pos.y*MazeMap.TILE_HEIGHT)
    if d == Direction.RIGHT
      search.rotate(90)
    else if d == Direction.LEFT
      search.rotate(-90)
    else if d == Direction.DOWN
      search.rotate(180)
    @parentNode.addChild(search)
    @tl.delay(Player.SEARCH_FRAME/SPEED).then () =>
      ret = false
      if tile != false
        tile.check(@)
        ret = tile.isThrough()
      onComplete(ret)

class RobotPlayer extends Player
  @WIDTH  : 64
  @HEIGHT : 64

  constructor: (map) ->
    super RobotPlayer.WIDTH, RobotPlayer.HEIGHT, map
    @image = Game.instance.assets[R.CHAR.CHAR1]


