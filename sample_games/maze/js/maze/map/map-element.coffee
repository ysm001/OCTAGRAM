class MapElement extends Sprite
  @WIDTH  : 64
  @HEIGHT : 64

  constructor: (@id = 0)->
    super MapElement.WIDTH, MapElement.HEIGHT
    # @image = Game.instance.assets[R.MAP.SRC]
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
    @image = Game.instance.assets[R.MAP.START]
    @tl.scaleTo(0.1, 0.1, 0, enchant.Easing.CIRC_EASEOUT).
      scaleTo(1.2, 1.2, 30, enchant.Easing.CIRC_EASEOUT)
      .loop()

  isThrough: true

class GoalElement extends MapElement
  @ID : 13

  constructor: () ->
    super GoalElement.ID
    @image = Game.instance.assets[R.MAP.GOAL]
    @tl.scaleTo(0.1, 0.1, 0, enchant.Easing.CIRC_EASEOUT).
      scaleTo(1.2, 1.2, 30, enchant.Easing.CIRC_EASEOUT)
      .loop()

  isThrough: true

  # override
  onride: (player) ->
    super
    player.dispatchEvent(new MazeEvent('goal'))


class TreasureElement extends MapElement
  @ID : 25

  constructor: () ->
    super TreasureElement.ID
    @image = Game.instance.assets[R.MAP.SRC]

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
    @image = Game.instance.assets[R.MAP.SRC]

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


class RoadElement extends MapElement
  @ID : 30
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.ROAD]

class Wall1RightElement extends BlockElement
  @ID : 45
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL1_1]

class Wall1DownElement extends BlockElement
  @ID : 46
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL1_2]

class Wall1LeftElement extends BlockElement
  @ID : 47
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL1_3]

class Wall1UpElement extends BlockElement
  @ID : 48
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL1_4]
  
class Wall2HorizontalElement extends BlockElement
  @ID : 49
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL2_1]
  
class Wall2VerticalElement extends BlockElement
  @ID : 50
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL2_2]

class Wall3TopElement extends BlockElement
  @ID : 33
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL3_TOP]

class Wall3RightElement extends BlockElement
  @ID : 34
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL3_RIGHT]

class Wall3BottomElement extends BlockElement
  @ID : 35
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL3_BOTTOM]

class Wall3LeftElement extends BlockElement
  @ID : 36
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL3_LEFT]

# class Wall4Element extends BlockElement
#   @ID : 34
#   constructor: () ->
#     super 
#     @image = Game.instance.assets[R.MAP.WALL4]

class Wall5Element extends BlockElement
  @ID : 38
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL5]

# class Wall6Element extends BlockElement
#   @ID : 36
#   constructor: () ->
#     super 
#     @image = Game.instance.assets[R.MAP.WALL6]

# class Wall7Element extends BlockElement
#   @ID : 37
#   constructor: () ->
#     super 
#     @image = Game.instance.assets[R.MAP.WALL7]

class Wall8UpLeftElement extends BlockElement
  @ID : 41
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL8_1]

class Wall8UpRightElement extends BlockElement
  @ID : 42
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL8_2]

class Wall8BottomRightElement extends BlockElement
  @ID : 43
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL8_3]

class Wall8BottomLeftElement extends BlockElement
  @ID : 44
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL8_4]

class Wall9Element extends BlockElement
  @ID : 37
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL9]


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

      when RoadElement.ID
        ret = new RoadElement()

      when Wall1RightElement.ID
        ret = new Wall1RightElement()
      when Wall1DownElement.ID
        ret = new Wall1DownElement()
      when Wall1LeftElement.ID
        ret = new Wall1LeftElement()
      when Wall1UpElement.ID
        ret = new Wall1UpElement()

      when Wall2HorizontalElement.ID
        ret = new Wall2HorizontalElement()
      when Wall2VerticalElement.ID
        ret = new Wall2VerticalElement()

      when Wall3RightElement.ID
        ret = new Wall3RightElement()
      when Wall3TopElement.ID
        ret = new Wall3TopElement()
      when Wall3BottomElement.ID
        ret = new Wall3BottomElement()
      when Wall3LeftElement.ID
        ret = new Wall3LeftElement()

      when Wall5Element.ID
        ret = new Wall5Element()
    
      when Wall8UpLeftElement.ID
        ret = new Wall8UpLeftElement()
      when Wall8UpRightElement.ID
        ret = new Wall8UpRightElement()
      when Wall8BottomRightElement.ID
        ret = new Wall8BottomRightElement()
      when Wall8BottomLeftElement.ID
        ret = new Wall8BottomLeftElement()
    
      when Wall9Element.ID
        ret = new Wall9Element()

    ret
