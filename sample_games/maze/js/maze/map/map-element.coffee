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
    @item = null

  isImpassable: 1

  setItem: (@item) ->
    @parentNode.addChild @item
    @item.x = @x
    @item.y = @y

  onride: (player) ->
    if @item
      player.addItem(@item)
      @item.parentNode.removeChild @item
      @item = null
  
  requiredItems: () -> []
  checkRequiredItems: (player) ->
    checkAllRequiredItem = true
    if @isImpassable
      items = @requiredItems()
      for item in items
        checkAllRequiredItem = checkAllRequiredItem and player.hasItem(item)
    checkAllRequiredItem

  changePassable: (player) ->
    items = @requiredItems()
    player.getItem item for item in items
    @isImpassable = 0
    
class BlockElement extends MapElement
  @ID : 4

  constructor: (x, y) ->
    super BlockElement.ID, x, y

  isImpassable: 1

class RoadElement extends MapElement
  @ID : 0

  constructor: (x, y) ->
    super RoadElement.ID, x, y

  isImpassable: 0

class StartElement extends MapElement
  @ID : 14

  constructor: (x, y) ->
    super StartElement.ID, x, y

  isImpassable: 0


class GoalElement extends MapElement
  @ID : 13

  constructor: (x, y) ->
    super GoalElement.ID, x, y

  isImpassable: 0

  # override
  onride: (player) ->
    super
    player.dispatchEvent(new MazeEvent('goal'))


class TreasureElement extends MapElement
  @ID : 25

  constructor: (x, y) ->
    super TreasureElement.ID, x, y

  isImpassable: 0

  affect: (player) ->
    player.addItem new Key

  requiredItems: () ->
    [new Key, new Key]

class GateElement extends MapElement
  @ID : 17

  constructor: (x, y) ->
    super GateElement.ID, x, y

  isImpassable: 1

  requiredItems: () ->
    [new Key]

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
      when TreasureElement.ID
        ret = new TreasureElement(x, y)
      when GateElement.ID
        ret = new GateElement(x, y)
    ret
