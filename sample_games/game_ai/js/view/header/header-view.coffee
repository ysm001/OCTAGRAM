R = Config.R

class Header extends ViewGroup
  @WIDTH = 600

  constructor: (x, y) ->
    super
    @x = x
    @y = y
    @addView(new PlayerHp(8, 0))
    @addView(new EnemyHp(Header.WIDTH/2 + 8, 0))
    @addView(new PlayerEnergy(8, 26))
    @addView(new EnemyEnergy(Header.WIDTH/2 + 8, 26))
