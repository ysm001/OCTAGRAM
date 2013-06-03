
class Bullet extends Sprite

    @MAX_FRAME = 15
    constructor: (x, y, w, h) ->
        super w, h
        @rotate 90

    shot: (@x, @y, @direct=Direct.RIGHT) ->
        @offsetX = @x
        @offsetY = @y
        @dstPoint = new Point 0, 0
        @animated = true
        if @_rorateDeg?
            @rotate -@_rorateDeg

        rotate = 0
        if (@direct & Direct.LEFT) != 0
            rotate += 180

        if (@direct & Direct.UP) != 0
            if (@direct & Direct.LEFT) != 0
                rotate += 60
            else
                rotate -= 60
        else if (@direct & Direct.DOWN) != 0
            if (@direct & Direct.LEFT) != 0
                rotate -= 60
            else
                rotate += 60

        @rotate rotate
        @_rorateDeg = rotate
        point = Util.toCartesianCoordinates(70*2, Util.toRad(rotate))
        @tl.moveBy(toi(point.x), toi(point.y), Bullet.MAX_FRAME).then(() -> @onDestroy())

    hit: (robot) ->
        explosion = new Explosion robot.x, robot.y
        @parentNode.addChild explosion
        @onDestroy()
        robot.damege()

    onDestroy: () =>
        if @animated
            @animated = false
            @parentNode.removeChild @


class DroidBullet extends Bullet
    @WIDTH = 64
    @HEIGHT = 64
    constructor: (x, y) ->
        super x, y, DroidBullet.WIDTH, DroidBullet.HEIGHT
        @image = Game.instance.assets[R.BULLET.DROID]


class EnemyBullet extends Bullet
    @WIDTH = 64
    @HEIGHT = 64
    constructor: (x, y) ->
        super x, y, EnemyBullet.WIDTH, EnemyBullet.HEIGHT
        @image = Game.instance.assets[R.BULLET.ENEMY]


class Item extends Sprite

    constructor:(w, h) ->
        super w, h
        @animated = true

    onComplete: () =>
        @animated = false
        @parentNode.removeChild @


class BulletItem extends Item
    @SIZE = 64
    @FRAME = 20
    constructor:(x, y) ->
        super BulletItem.SIZE, BulletItem.SIZE
        @x = x
        @y = y-8
        @image = Game.instance.assets[R.ITEM.BULLET]
        @tl.fadeOut(BulletItem.FRAME).and().moveBy(0, -48, BulletItem.FRAME).then(() -> @onComplete())

