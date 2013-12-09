class MapElement extends Sprite
  @WIDTH  : 16
  @HEIGHT : 16

  constructor: (@id = 0, x, y)->
    super MapElement.WIDTH, MapElement.HEIGHT
    @index =
      x: x
      y: y

  isImpassable: () -> 1

  affect: (player) ->
  

class BlockElement extends MapElement
  @ID : 4

  constructor: (x, y) ->
    super BlockElement.ID, x, y

  isImpassable: () -> 1

class RoadElement extends MapElement
  @ID : 0

  constructor: (x, y) ->
    super RoadElement.ID, x, y

  isImpassable: () -> 0

class StartElement extends MapElement
  @ID : 14

  constructor: (x, y) ->
    super StartElement.ID, x, y

  isImpassable: () -> 0


class GoalElement extends MapElement
  @ID : 13

  constructor: (x, y) ->
    super GoalElement.ID, x, y

  isImpassable: () -> 0

  affect: (player) ->
    player.odispatchEvent(new MazeEvent('goal'))


class TreasureElement extends MapElement
  @ID : 13

  constructor: (x, y) ->
    super GoalElement.ID, x, y

  isImpassable: () -> 0


class ElementFactory

  @create: (id, x, y) ->
    switch id
      when RoadElement.ID
        ret = new RoadElement(x, y)
      when BlockElement.ID
        ret = new BlockElement(x, y)
      when StartElement.ID
        ret = new StartElement(x, y)
      when GoalElement.ID
        ret = new GoalElement(x, y)
    ret
