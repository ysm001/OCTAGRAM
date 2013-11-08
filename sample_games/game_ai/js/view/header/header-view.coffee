R = Config.R

class Header extends ViewGroup
  @WIDTH = 600

  constructor: (x, y) ->
    super
    @x = x
    @y = y
    offset = 16
    @addView(new PlayerHp(offset + 8, offset))
    @addView(new EnemyHp(Header.WIDTH/2 + 8 + offset, offset))
    @addView(new PlayerEnergy(8 + offset, 26 + offset))
    @addView(new EnemyEnergy(Header.WIDTH/2 + 8 + offset, 26 + offset))
    @addView(new TimerView(8, 0))
