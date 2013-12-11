class MapElement extends Sprite
  @WIDTH  : 48
  @HEIGHT : 48

  constructor: (@id = 0)->
    super MapElement.WIDTH, MapElement.HEIGHT
    @image = Game.instance.assets[R.MAP.SRC]
    @frame = @id
    @item = null

  isImpassable: 1

  isThrough: () -> true

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

  constructor: () ->
    super BlockElement.ID

  isImpassable: 1

  isThrough: () -> false

class StartElement extends MapElement
  @ID : 14

  constructor: () ->
    super StartElement.ID

  isImpassable: 0

  isThrough: () -> true


class GoalElement extends MapElement
  @ID : 13

  constructor: () ->
    super GoalElement.ID

  isImpassable: 0

  isThrough: () -> true

  # override
  onride: (player) ->
    super
    player.dispatchEvent(new MazeEvent('goal'))


class TreasureElement extends MapElement
  @ID : 25

  constructor: () ->
    super TreasureElement.ID

  isImpassable: 0

  isThrough: () -> true

  onride: (player) ->
    player.addItem new Key

  requiredItems: () ->
    [new Key, new Key]

class GateElement extends MapElement
  @ID : 17

  constructor: () ->
    super GateElement.ID

  isImpassable: 1

  isThrough: () -> true

  requiredItems: () ->
    [new Key]

class ElementFactory

  @create: (id) ->
    switch id
      when BlockElement.ID
        ret = new BlockElement()
      when StartElement.ID
        ret = new StartElement()
      when GoalElement.ID
        ret = new GoalElement()
      when TreasureElement.ID
        ret = new TreasureElement()
      when GateElement.ID
        ret = new GateElement()
    ret
