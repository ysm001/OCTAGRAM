
class TimerView extends MeterView

  PART_WIDTH = 48

  constructor: (x, y) ->
    super
      x:         x
      y:         y
      partWidth: PART_WIDTH
      count:     13
      height:    8
      foregroundImage: R.BACKGROUND_IMAGE.TIMER
      backgroundImage: R.BACKGROUND_IMAGE.HP_ENCLOSE

  initEvent: (world) ->
    # callback on the HP of player changed
    world.addEventListener "ontimer", (evt) =>
      @decreaseForce(PART_WIDTH / 8)

    world.addEventListener "gameend", (evt) =>
      @increaseForce(PART_WIDTH * 13)


