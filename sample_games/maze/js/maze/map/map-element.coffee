class MapElement extends Sprite
  @WIDTH  : 48
  @HEIGHT : 48

  constructor: (@id = 0)->
    super MapElement.WIDTH, MapElement.HEIGHT
    @image = Game.instance.assets[R.MAP.SRC]
    @frame = @id
    @enabled = true

  isThrough: true

  onride: (player) ->

  check: (player) ->
  
  requiredItems: () -> []
    
class BlockElement extends MapElement
  @ID : 4

  constructor: () ->
    super BlockElement.ID

  isThrough: false

class StartElement extends MapElement
  @ID : 14

  constructor: () ->
    super StartElement.ID

  isThrough: true

class GoalElement extends MapElement
  @ID : 13

  constructor: () ->
    super GoalElement.ID

  isThrough: true

  # override
  onride: (player) ->
    super
    player.dispatchEvent(new MazeEvent('goal'))


class TreasureElement extends MapElement
  @ID : 25

  constructor: () ->
    super TreasureElement.ID

  isThrough: true

  onride: (player) ->
    super player
    @parentNode.removeChild @
    @enabled = false
    player.addItem new Key

class GateElement extends MapElement
  @ID : 17

  constructor: () ->
    super GateElement.ID

  isThrough: false

  _checkRequiredItems: (player) ->
    checkAllRequiredItem = true
    items = @requiredItems()
    for item in items
      checkAllRequiredItem = checkAllRequiredItem and player.hasItem(item)
    checkAllRequiredItem

  check: (player) ->
    super player
    if @_checkRequiredItems(player)
      items = @requiredItems()
      player.getItem item for item in items
      @parentNode.removeChild @
      @enabled = false
      @isThrough = true

  requiredItems: () -> [new Key]

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
