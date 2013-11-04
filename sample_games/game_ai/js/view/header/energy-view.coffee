
class PlayerEnergy extends MeterView

  PART_WIDTH = 48
  COUNT = 5

  constructor: (x, y) ->
    super
      x:         x
      y:         y
      partWidth: PART_WIDTH
      count:     COUNT
      height:    16
      foregroundImage: R.BACKGROUND_IMAGE.ENERGY
      backgroundImage: R.BACKGROUND_IMAGE.HP_ENCLOSE

  initEvent: (world) ->
    # callback on the HP of enemy changed
    world.player.addObserver "energy", (energy) =>
      @decreaseForce(world.player.energy - energy) if energy < world.player.energy

class EnemyEnergy extends MeterView

  PART_WIDTH = 48
  COUNT = 5

  constructor: (x, y) ->
    super
      x:         x
      y:         y
      partWidth: PART_WIDTH
      count:     COUNT
      height:    16
      foregroundImage: R.BACKGROUND_IMAGE.ENERGY
      backgroundImage: R.BACKGROUND_IMAGE.HP_ENCLOSE

  initEvent: (world) ->
    # callback on the HP of enemy changed
    world.enemy.addObserver "energy", (energy) =>
      @decreaseForce(world.enemy.energy - energy) if energy < world.enemy.energy
