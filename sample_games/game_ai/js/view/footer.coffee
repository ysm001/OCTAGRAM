R = Config.R

class MsgBox extends ViewGroup
  @WIDTH : 320
  @HEIGHT : 128

  ###
   inner class
  ###
  class MsgWindow extends ViewSprite
    @WIDTH = 320
    @HEIGHT = 128

    constructor: (x,y) ->
      super MsgWindow.WIDTH, MsgWindow.HEIGHT
      @x = x
      @y = y
      @image = Game.instance.assets[R.BACKGROUND_IMAGE.MSGBOX]

  constructor: (x,y) ->
    super MsgWindow.WIDTH, MsgWindow.HEIGHT
    @x = x
    @y = y
    @window = new MsgWindow 0, 0
    @addChild @window
    @label = new Label
    @label.font = "16px 'Meiryo UI'"
    @label.color = '#FFF'
    @label.x = 10
    @label.y = 30
    @addChild @label
    @label.width = MsgWindow.WIDTH * 0.9

  initEvent: (world) ->
    world.player.addEventListener 'move', (evt) =>
      player = evt.target
      point = evt.params
      if point != false
        @print R.String.move(player.name, point.x+1, point.y+1)
      else
        @print R.String.CANNOTMOVE

    world.player.addEventListener 'shot', (evt) =>
      player = evt.target
      ret = evt.params
      if ret != false
        @print R.String.shot(player.name)
      else
        @print R.String.CANNOTSHOT

    world.player.addEventListener 'pickup', (evt) =>
      player = evt.target
      ret = evt.params
      if ret != false
        @print R.String.pickup(player.name)
      else
        @print R.String.CANNOTPICKUP

  print: (msg) ->
    @label.text = "#{msg}"

class RemainingBulletsGroup extends ViewGroup

  ###
   inner class
  ###
  class RemainingBullet extends ViewSprite
    @SIZE = 24

    constructor: (x, y, frame) ->
      super RemainingBullet.SIZE, RemainingBullet.SIZE
      @x = x
      @y = y
      @frame = frame
      @image = Game.instance.assets[R.ITEM.STATUS_BULLET]

  class RemainingBullets extends ViewGroup
    @HEIGHT = 30
    @WIDTH = 120

    increment: () ->
      if @size < 5
        @array[@size].frame = @type - 1
        @size++

    decrement: () ->
      if @size > 0
        @size--
        @array[@size].frame = @type

    constructor: (x, y, @type) ->
      super RemainingBullets.WIDTH, RemainingBullets.HEIGHT
      @x = x
      @y = y
      @size = 0
      @array = []
      for i in [0..4]
        b = new RemainingBullet(i * RemainingBullet.SIZE, 0, @type)
        @array.push b
        @addChild b

  constructor : (x, y) ->
    super
    @normal = new RemainingBullets(30, 30, 1)
    @wide   = new RemainingBullets(30, 30 + RemainingBullet.SIZE, 3)
    @dual   = new RemainingBullets(30, 30 + RemainingBullet.SIZE * 2, 5)

    @addChild @normal
    @addChild @wide
    @addChild @dual

  initEvent: (world) ->
    world.player.addEventListener 'pickup', (evt) =>
      player = evt.target
      effect = new ShotEffect(player.x, player.y)
      @addChild effect
      switch evt.params.type
        when BulletType.NORMAL
          @normal.increment()
        when BulletType.WIDE
          @wide.increment()
        when BulletType.DUAL
          @dual.increment()

    world.player.addEventListener 'shot', (evt) =>
      switch evt.params.type
        when BulletType.NORMAL
          @normal.decrement()
        when BulletType.WIDE
          @wide.decrement()
        when BulletType.DUAL
          @dual.decrement()

class StatusBox extends ViewGroup

  ###
   inner class
  ###
  class StatusWindow extends ViewSprite
    @WIDTH = 160
    @HEIGHT = 128
    constructor: (x,y) ->
      super StatusWindow.WIDTH, StatusWindow.HEIGHT
      @x = x
      @y = y
      @image = Game.instance.assets[R.BACKGROUND_IMAGE.STATUS_BOX]

  constructor: (x,y) ->
    super StatusWindow.WIDTH, StatusWindow.HEIGHT
    @x = x
    @y = y
    
    @addView(new RemainingBulletsGroup())

class Footer extends ViewGroup

  constructor: (x,y) ->
    super
    @x = x
    @y = y
    @addView(new MsgBox(20, 0))
    @addView(new StatusBox(x+MsgBox.WIDTH+32, 16))
