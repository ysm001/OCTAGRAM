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
    @image = Game.instance.assets[R.MAP.ROAD]

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

class Wall5Element extends BlockElement
  @ID : 38
  constructor: () ->
    super 
    @image = Game.instance.assets[R.MAP.WALL5]

class Wall6RightElement extends BlockElement
  @ID : 60
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL6_1]

class Wall6DownElement extends BlockElement
  @ID : 61
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL6_2]

class Wall6LeftElement extends BlockElement
  @ID : 62
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL6_3]

class Wall6UpElement extends BlockElement
  @ID : 63
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL6_4]

class Wall7RightElement extends BlockElement
  @ID : 70
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL7_1]

class Wall7DownElement extends BlockElement
  @ID : 71
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL7_2]

class Wall7LeftElement extends BlockElement
  @ID : 72
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL7_3]

class Wall7UpElement extends BlockElement
  @ID : 73
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL7_4]

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

class Wall10RightElement extends BlockElement
  @ID : 50
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL10_1]

class Wall10DownElement extends BlockElement
  @ID : 51
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL10_2]

class Wall10LeftElement extends BlockElement
  @ID : 52
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL10_3]

class Wall10UpElement extends BlockElement
  @ID : 53
  constructor: () ->
    super
    @image = Game.instance.assets[R.MAP.WALL10_4]

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
    
      when Wall6LeftElement.ID
        ret = new Wall6LeftElement()
      when Wall6RightElement.ID
        ret = new Wall6RightElement()
      when Wall6UpElement.ID
        ret = new Wall6LeftElement()
      when Wall6DownElement.ID
        ret = new Wall6DownElement()
    
      when Wall7LeftElement.ID
        ret = new Wall7LeftElement()
      when Wall7RightElement.ID
        ret = new Wall7RightElement()
      when Wall7UpElement.ID
        ret = new Wall6LeftElement()
      when Wall7DownElement.ID
        ret = new Wall7DownElement()
    
      when Wall10LeftElement.ID
        ret = new Wall10LeftElement()
      when Wall10RightElement.ID
        ret = new Wall10RightElement()
      when Wall10UpElement.ID
        ret = new Wall10LeftElement()
      when Wall10DownElement.ID
        ret = new Wall10DownElement()
    
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

ST = StartElement.ID
GL = GoalElement.ID

WU1 = Wall1RightElement.ID
WU2 = Wall1DownElement.ID
WU3 = Wall1LeftElement.ID
WU4 = Wall1UpElement.ID

WA1 = Wall3TopElement.ID
WA2 = Wall3RightElement.ID
WA3 = Wall3BottomElement.ID
WA4 = Wall3LeftElement.ID

WC1 = Wall8UpLeftElement.ID
WC2 = Wall8UpRightElement.ID
WC3 = Wall8BottomRightElement.ID
WC4 = Wall8BottomLeftElement.ID

WR1 = Wall6RightElement.ID
WR2 = Wall6DownElement.ID
WR3 = Wall6LeftElement.ID
WR4 = Wall6UpElement.ID

WL1 = Wall7RightElement.ID
WL2 = Wall7DownElement.ID
WL3 = Wall7LeftElement.ID
WL4 = Wall7UpElement.ID

RO = RoadElement.ID
WB = Wall5Element.ID

WV = Wall2HorizontalElement.ID
WH = Wall2VerticalElement.ID  

WT = Wall9Element.ID

WX1 = Wall10RightElement.ID
WX2 = Wall10DownElement.ID
WX3 = Wall10LeftElement.ID
WX4 = Wall10UpElement.ID
