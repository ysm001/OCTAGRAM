R = Config.R

class HpBar extends Bar
  @HEIGHT = 24
  @MAX_VALUE = 64 * Robot.MAX_HP
  constructor: (x,y,resource=PlayerHp.YELLOW) ->
    super x, y
    @height = HpBar.HEIGHT
    @value = HpBar.MAX_VALUE
    @maxValue = HpBar.MAX_VALUE
    switch resource
      when PlayerHp.BLUE
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_BULE]
      when PlayerHp.YELLOW
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_YELLOW]

class HpEnclosePart extends ViewSprite
  @WIDTH = HpBar.MAX_VALUE / Robot.MAX_HP
  @HEIGHT = HpBar.HEIGHT
  constructor: (x, y, i) ->
    super HpEnclosePart.WIDTH, HpEnclosePart.HEIGHT
    @x = x
    @y = y
    if i == 0
      @frame = 0
    else if i ==  Robot.MAX_HP - 1
      @frame = 2
    else
      @frame = 1
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_ENCLOSE]

class HpEnclose extends ViewGroup
  @WIDTH = HpBar.MAX_VALUE
  @HEIGHT = HpBar.HEIGHT
  constructor: (x, y) ->
    super HpEnclose.WIDTH, HpEnclose.HEIGHT
    @x = x
    @y = y
    for i in [0...Robot.MAX_HP]
      @addChild new HpEnclosePart(i*HpEnclosePart.WIDTH ,0, i)

class HpView extends ViewGroup
  @YELLOW = 1
  @BLUE = 2
  @MAX_HP = 4
  constructor: (x,y, resource) ->
    super
    @hp = new HpBar x, y, resource
    @addChild @hp
    @underBar = new HpEnclose x, y
    @addChild @underBar

  reduce: () ->
    @hp.value -= @hp.maxValue / Robot.MAX_HP if @hp.value > 0

class EnemyHp extends HpView
  constructor: (x, y) ->
    super(x, y, HpView.BLUE)

  initEvent: (world) ->
    # callback on the HP of enemy changed
    world.enemy.addObserver "hp", (hp) =>
      @reduce() if hp < world.enemy.hp

class PlayerHp extends HpView
  constructor: (x, y) ->
    super(x, y, HpView.YELLOW)

  initEvent: (world) ->
    # callback on the HP of player changed
    world.player.addObserver "hp", (hp) =>
      @reduce() if hp < player.enemy.hp

class Header extends ViewGroup
  @WIDTH = 600
  constructor: (x, y) ->
    super
    @x = x
    @y = y
    @addView(new PlayerHp(16 + 32, 0))
    @addView(new EnemyHp(Header.WIDTH/2 + 16 + 32, 0))
