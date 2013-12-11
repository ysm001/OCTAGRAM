R = Config.R

class MazeMap extends Group
  @TILE_WIDTH : 48
  @TILE_HEIGHT : 48

  properties:
    startTile:
      get: () -> @_startTile
    goalTile:
      get: () -> @_goalTile

  constructor: (matrix) ->
    super MazeMap.UNIT_SIZE, MazeMap.UNIT_SIZE
    @image = Game.instance.assets[R.MAP.SRC]
    @tileData = []
    for y in [0...matrix.length]
      tileLine = []
      for x in [0...matrix[y].length]
        id = matrix[y][x]
        tile = new MapTile(x, y)
        @addChild(tile)
        tileLine.push(tile)
        if id != 0
          element = ElementFactory.create(id)
          tile.pushElement(element)
          if element instanceof StartElement
            @_startTile = tile
          else if element instanceof GoalElement
            @_goalTile = tile
      @tileData.push(tileLine)
    Object.defineProperties @, @properties

  getTile: (x, y) ->
    if 0 <= x < @tileData[0].length and 0 <= y < @tileData.length
      @tileData[y][x]
    else
      false

  toPoint: (tile) -> new Point(@x + MazeMap.TILE_WIDTH * tile.index.x, @y + MazeMap.TILE_HEIGHT * tile.index.y)
