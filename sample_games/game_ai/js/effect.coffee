
R = Config.R

class Effect extends Sprite
  constructor: (w, h, @endFrame, @step) ->
    super w, h
    @frame = 0

  onenterframe: () ->
    if @age % @step == 0
      @frame += 1
      if @frame > @endFrame
        @parentNode.removeChild @


class Explosion extends Effect
  @SIZE = 64
  constructor: (x, y) ->
    super Explosion.SIZE, Explosion.SIZE, 24, 1
    @image = Game.instance.assets[R.EFFECT.EXPLOSION]
    @x = x
    @y = y


class ShotEffect extends Effect
  @SIZE = 64
  constructor: (x, y) ->
    super Explosion.SIZE, Explosion.SIZE, 16, 1
    @image = Game.instance.assets[R.EFFECT.SHOT]
    @x = x
    @y = y


class SpotEffect extends Effect
  @SIZE = 64
  constructor: (x, y, image) ->
    super SpotEffect.SIZE, SpotEffect.SIZE, 10, 3
    @image = Game.instance.assets[image]
    @x = x
    @y = y

  onenterframe: () ->
    if @age % @step == 0
      @frame += 1
      if @frame > @endFrame
        @frame = 0

class SpotNormalEffect extends SpotEffect
  constructor: (x, y) ->
    super x, y, R.EFFECT.SPOT_NORMAL

class SpotWideEffect extends SpotEffect
  constructor: (x, y) ->
    super x, y, R.EFFECT.SPOT_WIDE

class SpotDualEffect extends SpotEffect
  constructor: (x, y) ->
    super x, y, R.EFFECT.SPOT_DUAL

class EnpowerEffect extends Effect
  @SIZE = 128
  constructor: (x, y, image) ->
    super EnpowerEffect.SIZE, EnpowerEffect.SIZE, 10, 2
    @image = Game.instance.assets[image]
    @x = x - EnpowerEffect.SIZE * 0.25
    @y = y - EnpowerEffect.SIZE * 0.25

class NormalEnpowerEffect extends EnpowerEffect
  constructor: (x, y) ->
    super x, y, R.EFFECT.ENPOWER_NORMAL

class WideEnpowerEffect extends EnpowerEffect
  constructor: (x, y) ->
    super x, y, R.EFFECT.ENPOWER_WIDE

class DualEnpowerEffect extends EnpowerEffect
  constructor: (x, y) ->
    super x, y, R.EFFECT.ENPOWER_DUAL


