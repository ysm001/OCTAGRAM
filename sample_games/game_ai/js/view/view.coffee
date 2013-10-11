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
