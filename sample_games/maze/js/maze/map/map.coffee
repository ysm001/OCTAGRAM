R = Config.R

class MazeMap extends Group
  @TILE_WIDTH : 48
  @TILE_HEIGHT : 48

  properties:
    startElement:
      get: () -> @_startElement
    goalElement:
      get: () -> @_goalElement

  constructor: (matrix) ->
    super MazeMap.UNIT_SIZE, MazeMap.UNIT_SIZE
    @image = Game.instance.assets[R.MAP.SRC]
    @elementData = []
    for y in [0...matrix.length]
      collisionLine = []
      elementLine = []
      for x in [0...matrix[y].length]
        id = matrix[y][x]
    
        if id == TreasureElement.ID
          element = ElementFactory.create(RoadElement.ID, x, y)
          @addChild(element)
          element.setItem(new Key)
        else
          element = ElementFactory.create(id, x, y)
          @addChild(element)
          
        elementLine.push(element)
        if element instanceof StartElement
          @_startElement = element
        else if element instanceof GoalElement
          @_goalElement = element
      @elementData.push(elementLine)
    Object.defineProperties @, @properties

  getElement: (x, y) ->
    if 0 <= x < @elementData[0].length and 0 <= y < @elementData.length
      @elementData[y][x]
    else
      false

  toPoint: (e) -> new Point(@x + MazeMap.TILE_WIDTH * e.index.x, @y + MazeMap.TILE_HEIGHT * e.index.y)

