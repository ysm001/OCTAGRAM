
class SpritePool
    constructor: (@createFunc, @maxAllocSize ,@maxPoolSize) ->
        @sprites = []
        @count = 0
        @freeCallback = null

    setDestructor: (@destructor) ->

    alloc: ->
        if @count > @maxAllocSize
            return null
        if @sprites.length == 0
            sprite = @createFunc()
        else
            sprite = @sprites.pop()
        @count++
        return sprite

    free: (sprite) ->
        if @sprites.length < @maxPoolSize
            @sprites[@sprites.length] = sprite
        @count--
        if @destructor?
            @destructor sprite
            
class BulletFactory
    @create:(type, robot) ->
        bullet = null
        switch type
            when BulletType.NORMAL
                bullet = new NormalBullet()
            when BulletType.WIDE
                bullet = new WideBullet()
            when BulletType.DUAL
                bullet = new DualBullet()
            else
                return false
        bullet.holder = robot
        return bullet

class BulletType
    @NORMAL = 1
    @WIDE = 2
    @DUAL = 3

class Bullet extends Sprite

    @MAX_FRAME = 15
    constructor: (w, h) ->
        super w, h
        @rotate 90

    shot: (@x, @y, @direct=Direct.RIGHT) ->

    hit: (robot) ->
        explosion = new Explosion robot.x, robot.y
        @scene.addChild explosion
        @onDestroy()
        robot.damege()

    onDestroy: () =>
        if @animated
            @animated = false
            @parentNode.removeChild @

###
    grouping Bullet Class
    behave like Bullet Class
###
class BulletGroup extends Group
    constructor: () ->
        super
        @bullets = []
        Object.defineProperty @, "animated",
            get : () =>
                animated = true
                for i in @bullets
                    animated = animated && i.animated
                return animated

    shot: (x, y, direct=Direct.RIGHT) ->
        for i in @bullets
            i.shot(x, y, direct)

    hit: (robot) ->
        for i in @bullets
            i.onDestroy()
        explosion = new Explosion robot.x, robot.y
        @scene.addChild explosion
        robot.damege()

    within: (s, value) ->
        for i in @bullets
            animated = i.within s, value
            return true if animated == true
        return false

    onDestroy: () =>
        for i in @bullets
            i.onDestroy(robot)


###
    straight forward 2 plates
###
class NormalBullet extends Bullet
    @WIDTH = 64
    @HEIGHT = 64
    MAX_FRAME = 15

    constructor: () ->
        super NormalBullet.WIDTH, NormalBullet.HEIGHT
        @image = Game.instance.assets[R.BULLET.NORMAL]

    shot: (@x, @y, @direct=Direct.RIGHT) ->
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
        @tl.fadeOut(MAX_FRAME).and().moveBy(toi(point.x), toi(point.y), MAX_FRAME).then(() -> @onDestroy())

###
    spread in 2 directions`
###
class WideBulletPart extends Bullet
    @WIDTH = 64
    @HEIGHT = 64
    MAX_FRAME = 10

    constructor: (@left=true) ->
        super WideBulletPart.WIDTH, WideBulletPart.HEIGHT
        @image = Game.instance.assets[R.BULLET.WIDE]
        @frame = 1

    shot: (@x, @y, @direct=Direct.RIGHT) ->
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

        if @left == true
            rotate -= 60
        else
            rotate += 60
        @rotate rotate
        @_rorateDeg = rotate
        point = Util.toCartesianCoordinates(70, Util.toRad(rotate))
        @tl.fadeOut(MAX_FRAME).and().moveBy(toi(point.x), toi(point.y), MAX_FRAME).then(() -> @onDestroy())
        
class WideBullet extends BulletGroup
    constructor: () ->
        super
        @bullets.push new WideBulletPart(true)
        @bullets.push new WideBulletPart(false)
        for i in @bullets
            @addChild i

class DualBulletPart extends Bullet
    @WIDTH = 64
    @HEIGHT = 64
    MAX_FRAME = 10

    constructor: (@back=true) ->
        super DualBulletPart.WIDTH, DualBulletPart.HEIGHT
        @image = Game.instance.assets[R.BULLET.DUAL]
        @frame = 1

    shot: (@x, @y, @direct=Direct.RIGHT) ->
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

        if @back == true
            rotate += 180
        @rotate rotate
        @_rorateDeg = rotate
        point = Util.toCartesianCoordinates(70, Util.toRad(rotate))
        @tl.moveBy(toi(point.x), toi(point.y), MAX_FRAME).then(() -> @onDestroy())

class DualBullet extends BulletGroup
    constructor: () ->
        super
        @bullets.push new DualBulletPart(true)
        @bullets.push new DualBulletPart(false)
        for i in @bullets
            @addChild i
