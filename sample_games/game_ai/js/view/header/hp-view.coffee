
class PlayerHp extends MeterView

  PART_WIDTH = 48

  constructor: (x, y) ->
    super
      x:         x
      y:         y
      partWidth: PART_WIDTH
      count:     Robot.MAX_HP
      height:    24
      foregroundImage: R.BACKGROUND_IMAGE.HP_GREEN
      backgroundImage: R.BACKGROUND_IMAGE.HP_ENCLOSE

  initEvent: (world) ->
    # callback on the HP of player changed
    world.player.addObserver "hp", (hp) =>
      if hp < world.player.hp
        @decreaseForce(PART_WIDTH * (world.player.hp - hp))
      else
        @increaseForce(PART_WIDTH * (hp - world.player.hp))

class EnemyHp extends MeterView

  PART_WIDTH = 48

  constructor: (x, y) ->
    super
      x:         x
      y:         y
      partWidth: PART_WIDTH
      count:     Robot.MAX_HP
      height:    24
      foregroundImage: R.BACKGROUND_IMAGE.HP_RED
      backgroundImage: R.BACKGROUND_IMAGE.HP_ENCLOSE

  initEvent: (world) ->
    # callback on the HP of enemy changed
    world.enemy.addObserver "hp", (hp) =>
      if hp < world.enemy.hp
        @decreaseForce(PART_WIDTH * (world.enemy.hp - hp))
      else
        @increaseForce(PART_WIDTH * (hp - world.enemy.hp))
