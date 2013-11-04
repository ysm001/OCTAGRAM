R = Config.R

class ViewGroup extends Group
  constructor: (x, y) ->
    super(x,y)
    @_childs = []

  addView: (view) ->
    @_childs.push(view)
    @addChild(view)

  initEvent: (world) ->
    view.initEvent(world) for view in @_childs

class ViewSprite extends Sprite
  constructor: (x, y) ->
    super(x,y)

  initEvent: (world) ->

class Background extends ViewSprite
  @SIZE = 640

  constructor: (x, y) ->
    super Background.SIZE, Background.SIZE
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.SPACE]
    @x = x
    @y = y

class MeterView extends ViewGroup
  @MAX_HP = 4

  ###
   inner class
  ###
  class MeterBar extends Bar

    constructor: (x, y, @height, @maxValue, resource) ->
      super x, y
      @height = height
      @value = @maxValue
      @image = Game.instance.assets[resource]

  class MeterEnclosePart extends ViewSprite

    constructor: (x, y, width, height, i) ->
      super width, height
      @x = x
      @y = y
      if i == 0
        @frame = 0
      else if i ==  Robot.MAX_HP - 1
        @frame = 2
      else
        @frame = 1
      @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_ENCLOSE]

  class MeterEnclose extends ViewGroup

    constructor: (x, y, width, height, count) ->
      super width, height
      @x = x
      @y = y
      for i in [0...count]
        @addChild new MeterEnclosePart(i*width, 0, width, height, i)

  constructor: (config) ->
    super
    @hp = new MeterBar config.x, config.y, config.height, config.width, resource
    @underMeter = new MeterEnclose x, y, 
    @addChild @underMeter
    @addChild @hp

  reduce: () ->
    @hp.value -= @hp.maxValue / Robot.MAX_HP if @hp.value > 0


class MeterView extends ViewGroup

  ###
   inner class
  ###
  class Meter extends Bar
    constructor: (x, y, width, height, resource) ->
      super 0, 0
      @height = height
      @value = width
      @maxValue = width
      @image = Game.instance.assets[resource]

  class MeterBackgroundPart extends ViewSprite

    constructor: (x, y, width, height, resource) ->
      super width, height
      @x = x
      @y = y
      @image = Game.instance.assets[resource]

  class MeterBackground extends ViewGroup

    constructor: (x, y, width, height, count, resource) ->
      super width, height
      partWidth = (width / count)
      for i in [0...count]
        @addChild new MeterBackgroundPart(i*partWidth, 0, partWidth, height, resource)

  constructor: (config) ->
    super
    @x               = config.x
    @y               = config.y
    @partWidth       = config.partWidth
    @count           = config.count
    @height          = config.height
    @width           = @partWidth * @count
    @foregroundImage = config.foregroundImage
    @backgroundImage = config.backgroundImage

    @meter = new Meter(@x, @y, @width, @height, @foregroundImage)
    @background = new MeterBackground(@x, @y, @width, @height, @count, @backgroundImage)
    @addChild(@background)
    @addChild(@meter)

  decrease: (value) ->
    if @meter.value - value >= 0
      @meter.value -= value
      return true
    else
      return false

  decreaseForce: (value) ->
    if @meter.value - value >= 0
      @meter.value -= value
    else
      @meter.value = 0

  increase: (value) ->
    if @meter.value + value <= @meter.maxValue
      @meter.value += value
      return true
    else
      return false

  increaseForce: (value) ->
    if @meter.value + value <= @meter.maxValue
      @meter.value += value
    else
      @meter.value = @meter.maxValue
