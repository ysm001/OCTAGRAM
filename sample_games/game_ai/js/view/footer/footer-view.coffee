R = Config.R

class MsgBox extends ViewGroup
  @WIDTH : 544
  @HEIGHT : 128

  ###
   inner class
  ###
  class MsgWindow extends ViewSprite
    @WIDTH : 544
    @HEIGHT : 128

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

    # callback on the HP of enemy changed
    world.player.addObserver "hp", (hp) =>
      @print R.String.die(world.player.name) if hp <= 0

  print: (msg) ->
    @label.text = "#{msg}"

class Footer extends ViewGroup

  constructor: (x,y) ->
    super
    @x = x
    @y = y
    @addView(new MsgBox(20, 0))
