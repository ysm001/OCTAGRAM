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

  class Msg extends ViewGroup
    SIZE = 4
    constructor: () ->
      super
      @labels = []
      @labelTexts = ["", "", "", ""]
      for i in [1..SIZE]
        label = new Label
        label.font = "14px 'Meiryo UI'"
        label.color = '#FFF'
        label.x = 10
        label.y = 24 * i + 6
        label.width = MsgWindow.WIDTH * 0.9
        @addChild label
        @labels.push(label)

    add: (string) ->
      @labelTexts[3] = @labelTexts[2]
      @labelTexts[2] = @labelTexts[1]
      @labelTexts[1] = @labelTexts[0]
      @labelTexts[0] = string

    print: () ->
      for i in [0...SIZE]
        @labels[i].text = @labelTexts[i]

  constructor: (x,y) ->
    super MsgWindow.WIDTH, MsgWindow.HEIGHT
    @x = x
    @y = y
    @window = new MsgWindow(0, 0)
    @addChild @window
    @msg = new Msg()
    @addChild @msg

  initEvent: (world) ->
    world.player.addEventListener 'move', (evt) =>
      player = evt.target
      point = evt.params
      if point != false
        @print R.String.move(player.name, point.x+1, point.y+1) + R.String.state(player.hp, player.energy)
      else
        @print R.String.CANNOTMOVE

    world.player.addEventListener 'shot', (evt) =>
      player = evt.target
      ret = evt.params
      if ret != false
        @print R.String.shot(player.name) + R.String.state(player.hp, player.energy)
      else
        @print R.String.CANNOTSHOT

    world.player.addEventListener 'supply', (evt) =>
      player = evt.target
      ret = evt.params.energy
      if ret != false
        @print R.String.supply(player.name, ret) + R.String.state(player.hp, player.energy)

    world.player.addEventListener 'turn', (evt) =>
      player = evt.target
      ret = evt.params
      if ret != false
        @print R.String.turn(player.name) + R.String.state(player.hp, player.energy)

    # callback on the HP of enemy changed
    world.addEventListener "gameEnd", (evt) =>
      #console.log "footer gameEnd"
      params = evt.params
      loseRobotName = params.lose.name
      winRobotName = params.win.name
      @print R.String.die(loseRobotName) + R.String.win(winRobotName)

  print: (msg) ->
    @msg.add(msg)
    @msg.print()

class Footer extends ViewGroup

  constructor: (x,y) ->
    super
    @x = x
    @y = y
    @addView(new MsgBox(20, 0))
