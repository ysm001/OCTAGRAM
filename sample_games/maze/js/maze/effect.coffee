

class Effect extends Sprite
  constructor: (w, h, @endFrame, @step) ->
    super w, h
    @frame = 0

  onenterframe: () ->
    if @age % @step == 0
      @frame += 1
      if @frame > @endFrame
        @parentNode.removeChild @


class SearchEffect extends Effect
  @SIZE = 64
  constructor: (x, y) ->
    super SearchEffect.SIZE, SearchEffect.SIZE, 24, 1
    @image = Game.instance.assets[R.EFFECT.SEARCH]
    @x = x
    @y = y
