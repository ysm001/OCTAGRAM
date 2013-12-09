class MapElement extends Sprite
  @WIDTH  : 48
  @HEIGHT : 48

  constructor: (@id = 0, x, y)->
    super MapElement.WIDTH, MapElement.HEIGHT
    @image = Game.instance.assets[R.MAP.SRC]
    @frame = @id
    @index =
      x: x
      y: y
    @x = MapElement.WIDTH * x
    @y = MapElement.HEIGHT * y

  isImpassable: () -> 1

  setItem: (item) ->

  onride: (player) ->

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

  # override
  onride: (player) ->
    super
    player.dispatchEvent(new MazeEvent('goal'))


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
