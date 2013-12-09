R = Config.R

class MazeMap extends Map
  @UNIT_SIZE : 48

  properties:
    startElement:
      get: () -> @_startElement
    goalElement:
      get: () -> @_goalElement

  constructor: (@matrix) ->
    super MazeMap.UNIT_SIZE, MazeMap.UNIT_SIZE
    @image = Game.instance.assets[R.MAP.SRC]
    collisionData = []
    @elementData = []
    for y in [0...matrix.length]
      collisionLine = []
      elementLine = []
      for x in [0...matrix[y].length]
        id = matrix[y][x]
        element = ElementFactory.create(id, x, y)
        collisionLine.push(element.isImpassable())
        elementLine.push(element)
        if element instanceof StartElement
          @_startElement = element
        else if element instanceof GoalElement
          @_goalElement = element
      collisionData.push(collisionLine)
      @elementData.push(elementLine)
    @loadData(matrix)
    @collisionData = collisionData
    Object.defineProperties @, @properties

  getElement: (x, y) ->
    if 0 <= x < @elementData[0].length and 0 <= y < @elementData.length
      @elementData[y][x]
    else
      false

  toPoint: (e) -> new Point(@x + @tileWidth * e.index.x, @x + @tileHeight * e.index.y)

