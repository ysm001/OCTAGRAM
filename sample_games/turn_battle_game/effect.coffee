
R = Config.R

class Effect extends Sprite
    constructor: (w, h, @endFrame) ->
        super w, h
        @frame = 0

    onenterframe: () ->
        @frame += 1
        if @frame > @endFrame
            @parentNode.removeChild @


class Explosion extends Effect
    @SIZE = 64
    constructor: (x, y) ->
        super Explosion.SIZE, Explosion.SIZE, 24
        @image = Game.instance.assets[R.EFFECT.EXPLOSION]
        @x = x
        @y = y



