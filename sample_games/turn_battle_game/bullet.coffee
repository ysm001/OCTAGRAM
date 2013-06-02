
class Point
    constructor:(@x, @y) ->

    length: () ->
        Math.sqrt(@x*@x+@y*@y)

class Bullet extends Sprite
    bit = 1
    @LEFT = bit << 0
    @RIGHT = bit << 1
    @UP = bit << 2
    @DOWN = bit << 3
    @MAX_FRAME = 16

    constructor: (x, y, w, h, direct=Bullet.RIGHT) ->
        super w, h
        @rotate 90
        @set x, y, direct

    set: (@x, @y, @direct=Bullet.RIGHT) ->
        @offsetX = @x
        @offsetY = @y
        @dstPoint = new Point 0, 0
        @enabled = true
        if @_rorateDeg?
            @rotate -@_rorateDeg
        if (@direct & Bullet.UP) != 0
            @dstPoint.y = -Map.UNIT_SIZE * 2
        else if (@direct & Bullet.DOWN) != 0
            @dstPoint.y = Map.UNIT_SIZE * 2

        if (@direct & Bullet.LEFT) != 0
            @dstPoint.x = -Map.UNIT_SIZE * 2
        else if (@direct & Bullet.RIGHT) != 0
            @dstPoint.x = Map.UNIT_SIZE * 2
        rotate = Util.toDeg(Util.includedAngle(@dstPoint, new Point(@dstPoint.length(),0)))
        @rotate rotate
        @count = 0

    hit: (robot) ->
        explosion = new Explosion robot.x, robot.y
        @parentNode.addChild explosion
        @onDestroy()
        robot.damege()

    update:() ->
        if @enabled
            #Debug.log "#{@x}, #{@y}"
            @x += parseInt(@dstPoint.x / Bullet.MAX_FRAME)
            @y += parseInt(@dstPoint.y / Bullet.MAX_FRAME)
            @count++
            if @count >= Bullet.MAX_FRAME
                @onDestroy()

    onDestroy: () ->
        if @enabled
            @enabled = false
            @parentNode.removeChild @


class DroidBullet extends Bullet
    @WIDTH = 64
    @HEIGHT = 64
    constructor: (x, y, direct=DroidBullet.RIGHT) ->
        super x, y, DroidBullet.WIDTH, DroidBullet.HEIGHT, direct
        @image = Game.instance.assets[R.BULLET.DROID]


class EnemyBullet extends Bullet
    @WIDTH = 64
    @HEIGHT = 64
    constructor: (x, y, direct=DroidBullet.RIGHT) ->
        super x, y, EnemyBullet.WIDTH, EnemyBullet.HEIGHT, direct
        @image = Game.instance.assets[R.BULLET.ENEMY]
