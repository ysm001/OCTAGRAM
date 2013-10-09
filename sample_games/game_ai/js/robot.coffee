R = Config.R

###
  store bullet objects
###
class ItemQueue
  constructor: (@collection = [], @max = -1) ->

  enqueue: (item) ->
    if @max != -1 and @max <= @collection.length
      return false
    else
      @collection.push item
      return true

  dequeue: (count=1) ->
    ret = []
    for i in [0...count]
      ret.push @collection.shift()
    return ret

  empty: () ->
    @collection.length == 0

  index: (i) ->
    @collection[i]

  size: () ->
    @collection.length

class BarrierMap extends Object

  constructor: (@robot) ->

  get:(key) ->
    ret = @[key]
    delete @[key]
    @robot.onResetBarrier(key)
    return ret

  isset:(key) ->
    return if @[key]? then true else false

class Robot extends SpriteModel
  @MAX_HP = 4

  DIRECT_FRAME                             = {}
  DIRECT_FRAME[Direct.RIGHT]               = 0
  DIRECT_FRAME[Direct.RIGHT | Direct.DOWN] = 5
  DIRECT_FRAME[Direct.LEFT | Direct.DOWN]  = 7
  DIRECT_FRAME[Direct.LEFT]                = 2
  DIRECT_FRAME[Direct.LEFT | Direct.UP]    = 6
  DIRECT_FRAME[Direct.RIGHT | Direct.UP]   = 4

  FRAME_DIRECT    = {}
  FRAME_DIRECT[0] = Direct.RIGHT
  FRAME_DIRECT[5] = Direct.RIGHT | Direct.DOWN
  FRAME_DIRECT[7] = Direct.LEFT | Direct.DOWN
  FRAME_DIRECT[2] = Direct.LEFT
  FRAME_DIRECT[6] = Direct.LEFT | Direct.UP
  FRAME_DIRECT[4] = Direct.RIGHT | Direct.UP
  
  constructor: (width, height) ->
    super width, height
    @name = "robot"
    # @hp = Robot.MAX_HP
    @setup("hp", Robot.MAX_HP)
    @bulletQueue =
      normal : new ItemQueue [], 5
      wide   : new ItemQueue [], 5
      dual   : new ItemQueue [], 5
    @barrierMap = new BarrierMap @
    @plateState = 0

    RobotWorld.instance.addChild @
    plate = Map.instance.getPlate(0,0)
    @prevPlate = @currentPlate = plate
    pos = plate.getAbsolutePos()
    @moveTo pos.x, pos.y

  properties:
    direct:
      get:() -> FRAME_DIRECT[@frame]
      set:(direct) -> @frame = DIRECT_FRAME[direct]

  move: (direct, onComplete) ->
    plate = Map.instance.getTargetPoision(@currentPlate, direct)
    @frame = @directFrame(direct)
    ret = @_move plate, () =>
      pos = plate.getAbsolutePos()
      @tl.moveTo(pos.x, pos.y,
        PlayerRobot.UPDATE_FRAME).then(onComplete)
    @dispatchEvent(new RobotEvent('move', ret))
    ret

  moveDirect: (plate) ->
    ret = @_move plate, () =>
      pos = plate.getAbsolutePos()
      @moveTo pos.x, pos.y
    ret

  _move: (plate, closure) ->
    ret = false
    @prevPlate = @currentPlate
    # plate is exists and not locked
    if plate? and plate.lock == false
      pos = plate.getAbsolutePos()
      closure()
      @currentPlate = plate
      @prevPlate.onRobotAway(@)
      @currentPlate.onRobotRide(@)
      ret = new Point plate.ix, plate.iy
    else
      ret = false
    ret

  shot: (bulletType, onComplete) ->
    switch bulletType
      when BulletType.NORMAL
        bltQueue = @bulletQueue.normal
      when BulletType.WIDE
        bltQueue = @bulletQueue.wide
      when BulletType.DUAL
        bltQueue = @bulletQueue.dual

    ret = false
    unless bltQueue.empty()
      for b in bltQueue.dequeue()
        b.shot(@x, @y, @direct)
        setTimeout(onComplete, Util.toMillisec(b.maxFrame))
        ret = type:bulletType
    @dispatchEvent(new RobotEvent('shot', ret))
    ret

  pickup: (bulletType, onComplete) ->
    ret = false
    blt = BulletFactory.create(bulletType, @)
    switch bulletType
      when BulletType.NORMAL
        bltQueue = @bulletQueue.normal
        itemClass = NormalBulletItem
      when BulletType.WIDE
        bltQueue = @bulletQueue.wide
        itemClass = WideBulletItem
      when BulletType.DUAL
        bltQueue = @bulletQueue.dual
        itemClass = DualBulletItem
    ret = bltQueue.enqueue(blt) if bltQueue?
    if ret != false
      item = new itemClass(@x, @y)
      item.setOnCompleteEvent(onComplete)
      ret = type:bulletType
    @dispatchEvent(new RobotEvent('pickup', ret))
    ret

  turn: (onComplete = () ->) ->
    setTimeout((() =>
      @direct = Direct.next(@direct)
      onComplete(@)
      @dispatchEvent(new RobotEvent('turn', {}))),
      Util.toMillisec(15)
    )

  damege: () ->
    @hp -= 1

  onKeyInput: (input) ->

  onSetBarrier: (bulletType) ->

  onResetBarrier: (bulletType) ->

  update: ->
    # Why the @x @y does it become a floating-point number?
    @x = Math.round @x
    @y = Math.round @y

    @onKeyInput Game.instance.input
    return true

  directFrame: (direct) ->
    DIRECT_FRAME[direct]

class PlayerRobot extends Robot
  @WIDTH = 64
  @HEIGHT = 74
  @UPDATE_FRAME = 10
  constructor: (parentNode) ->
    super PlayerRobot.WIDTH, PlayerRobot.HEIGHT, parentNode
    @name = R.String.PLAYER
    @image = Game.instance.assets[R.CHAR.PLAYER]
    @plateState = Plate.STATE_PLAYER
    @debugCmd = new DebugCommand(@)

  onKeyInput: (input) ->
    if @animated == true
      return
    if input.w == true and input.p == true
      #left Up
      @debugCmd.move(4)
    else if input.a == true and input.p == true
      #@cmdQueue.enqueue @cmdPool.moveLeft
      @debugCmd.move(3)
    else if input.x == true and input.p == true
      @debugCmd.move(5)
      #@cmdQueue.enqueue @cmdPool.moveleftDown
    else if input.d == true and input.p == true
      @debugCmd.move(0)
      #@cmdQueue.enqueue @cmdPool.moveRight
    else if input.e == true and input.p == true
      @debugCmd.move(1)
      #@cmdQueue.enqueue @cmdPool.moveRightUp
    else if input.c == true and input.p == true
      @debugCmd.move(2)
      #@cmdQueue.enqueue @cmdPool.moveRightDown
    else if input.q == true and input.m == true
      @debugCmd.pickup(@wideBltQueue,1)
    else if input.q == true and input.n == true
      @debugCmd.pickup(@dualBltQueue,2)
    else if input.q == true and input.l == true
      @debugCmd.pickup(@bltQueue,0)
    else if input.s == true and input.m == true
      @debugCmd.shot(@wideBltQueue)
    else if input.s == true and input.n == true
      @debugCmd.shot(@dualBltQueue)
    else if input.s == true and input.l == true
      @debugCmd.shot(@bltQueue)

  onSetBarrier: (bulletType) ->
    Util.dispatchEvent("setBarrier", {bulletType:bulletType})

  onResetBarrier: (bulletType) ->
    Util.dispatchEvent("resetBarrier", {bulletType:bulletType})

  onCmdComplete: (id, ret) ->
    super id, ret

class EnemyRobot extends Robot
  @WIDTH = 64
  @HEIGHT = 74
  @UPDATE_FRAME = 10
  constructor: (parentNode) ->
    super EnemyRobot.WIDTH, EnemyRobot.HEIGHT, parentNode
    @name = R.String.ENEMY
    @image = Game.instance.assets[R.CHAR.ENEMY]
    @plateState = Plate.STATE_ENEMY
    @debugCmd = new DebugCommand(@)

  onKeyInput: (input) ->
    if @animated == true
      return
    if input.w == true and input.o == true
      #left Up
      @debugCmd.move(4)
    else if input.a == true and input.o == true
      #@cmdQueue.enqueue @cmdPool.moveLeft
      @debugCmd.move(3)
    else if input.x == true and input.o == true
      @debugCmd.move(5)
      #@cmdQueue.enqueue @cmdPool.moveleftDown
    else if input.d == true and input.o == true
      @debugCmd.move(0)
      #@cmdQueue.enqueue @cmdPool.moveRight
    else if input.e == true and input.o == true
      @debugCmd.move(1)
      #@cmdQueue.enqueue @cmdPool.moveRightUp
    else if input.c == true and input.o == true
      @debugCmd.move(2)
      #@cmdQueue.enqueue @cmdPool.moveRightDown
