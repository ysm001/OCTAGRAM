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
  constructor: (w, h, @type) ->
    super w, h
    @rotate 90

  shot: (@x, @y, @direct=Direct.RIGHT) ->

  setOnDestoryEvent: (@event) ->

  hit: (robot) ->
    if robot.barrierMap.isset @type
      effect = robot.barrierMap.get(@type)
      effect.show(robot.x, robot.y, @scene)
    else
      robot.damege()
      explosion = new Explosion robot.x, robot.y
      @scene.addChild explosion
    @onDestroy()

  onDestroy: () =>
    if @animated
      @event @ if @event?
      @animated = false
      @parentNode.removeChild @

###
  grouping Bullet Class
  behave like Bullet Class
###
class BulletGroup extends Group
  constructor: (@type) ->
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

  setOnDestoryEvent: (@event) ->

  hit: (robot) ->
    if robot.barrierMap.isset @type
      effect = robot.barrierMap.get(@type)
      effect.show(robot.x, robot.y, @scene)
    else
      robot.damege()
      explosion = new Explosion robot.x, robot.y
      @scene.addChild explosion
    @onDestroy()

  within: (s, value) ->
    for i in @bullets
      animated = i.within s, value
      return true if animated == true
    return false

  onDestroy: () =>
    if @animated is true
      @event(@) if @event?
      for i in @bullets
        i.onDestroy()


###
  straight forward 2 plates
###
class NormalBullet extends Bullet
  @WIDTH = 64
  @HEIGHT = 64
  LENGHT = 4
  MAX_FRAME = 15

  constructor: () ->
    super NormalBullet.WIDTH, NormalBullet.HEIGHT, BulletType.NORMAL
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
    point = Util.toCartesianCoordinates(68*LENGHT, Util.toRad(rotate))
    @tl.fadeOut(MAX_FRAME).and().moveBy(toi(point.x), toi(point.y), MAX_FRAME).then(() -> @onDestroy())

###
  spread in 2 directions`
###
class WideBulletPart extends Bullet
  @WIDTH = 64
  @HEIGHT = 64
  MAX_FRAME = 10
  LENGHT = 2

  constructor: (@parent, @left=true) ->
    super WideBulletPart.WIDTH, WideBulletPart.HEIGHT, BulletType.WIDE
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
    point = Util.toCartesianCoordinates(68*LENGHT, Util.toRad(rotate))
    @tl.fadeOut(MAX_FRAME).and().moveBy(toi(point.x), toi(point.y), MAX_FRAME).then(() -> @parent.onDestroy())
    
class WideBullet extends BulletGroup
  constructor: () ->
    super BulletType.WIDE
    @bullets.push new WideBulletPart(@, true)
    @bullets.push new WideBulletPart(@, false)
    for i in @bullets
      @addChild i

class DualBulletPart extends Bullet
  @WIDTH = 64
  @HEIGHT = 64
  MAX_FRAME = 10
  LENGHT = 2

  constructor: (@parent, @back=true) ->
    super DualBulletPart.WIDTH, DualBulletPart.HEIGHT, BulletType.DUAL
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
    point = Util.toCartesianCoordinates(68*LENGHT, Util.toRad(rotate))
    @tl.moveBy(toi(point.x), toi(point.y), MAX_FRAME).then(() -> @parent.onDestroy())

class DualBullet extends BulletGroup
  constructor: () ->
    super BulletType.DUAL
    @bullets.push new DualBulletPart(@, true)
    @bullets.push new DualBulletPart(@, false)
    for i in @bullets
      @addChild i
