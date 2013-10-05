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

class Spot
  
  @TYPE_NORMAL_BULLET = 1
  @TYPE_WIDE_BULLET = 2
  @TYPE_DUAL_BULLET = 3
  @SIZE = 3

  constructor: (@type, point) ->
    switch @type
      when Spot.TYPE_NORMAL_BULLET
        @effect = new SpotNormalEffect(point.x, point.y + 5)
        @resultFunc = (robot, plate) ->
          robot.barrierMap[BulletType.NORMAL] = new NormalBarrierEffect()
          point = plate.getAbsolutePos()
          robot.parentNode.addChild new NormalEnpowerEffect(point.x, point.y)
          robot.onSetBarrier(BulletType.NORMAL)
      when Spot.TYPE_WIDE_BULLET
        @effect = new SpotWideEffect(point.x, point.y + 5)
        @resultFunc = (robot, plate) ->
          robot.barrierMap[BulletType.WIDE] = new WideBarrierEffect()
          point = plate.getAbsolutePos()
          robot.parentNode.addChild new WideEnpowerEffect(point.x, point.y)
          robot.onSetBarrier(BulletType.WIDE)
      when Spot.TYPE_DUAL_BULLET
        @effect = new SpotDualEffect(point.x, point.y + 5)
        @resultFunc = (robot, plate) ->
          robot.barrierMap[BulletType.DUAL] = new DualBarrierEffect()
          point = plate.getAbsolutePos()
          robot.parentNode.addChild new DualEnpowerEffect(point.x, point.y)
          robot.onSetBarrier(BulletType.DUAL)

  @createRandom: (point) ->
    type = Math.floor(Math.random() * (Spot.SIZE)) + 1
    return new Spot(type, poit)

  @getRandomType: () ->
    return Math.floor(Math.random() * (Spot.SIZE)) + 1

class Button extends ViewSprite
  @WIDTH = 120
  @HEIGHT = 50
  constructor: (x,y) ->
    super Button.WIDTH, Button.HEIGHT
    @x = x
    @y = y
  setOnClickEventListener: (listener) ->
    @on_click_event = listener
  ontouchstart: ->
    @on_click_event() if @on_click_event?
    @frame = 1

  ontouchend: ->
    @frame = 0

class NextButton extends Button
  constructor: (x,y) ->
    super x, y
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.NEXT_BUTTON]
