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

class Robot extends SpriteModel
  @MAX_HP     : 6
  @MAX_ENERGY : 250

  DIRECT_FRAME                             = {}
  DIRECT_FRAME[Direct.NONE]                = 0
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
    @setup("hp", Robot.MAX_HP)
    @setup("energy", Robot.MAX_ENERGY)
    @_bulletQueue = new ItemQueue [], 5
    @plateState = 0

    plate = Map.instance.getPlate(0,0)
    @prevPlate = @currentPlate = plate
    @_animated = false
    RobotWorld.instance.addChild @
    pos = plate.getAbsolutePos()
    @moveTo pos.x, pos.y

  properties:
    direct:
      get:() ->
        if FRAME_DIRECT[@frame]? then FRAME_DIRECT[@frame] else FRAME_DIRECT[Direct.RIGHT]
      set:(direct) ->
        @frame = DIRECT_FRAME[direct] if DIRECT_FRAME[direct]?
    animated:
      get:() -> @_animated
      set:(value) -> @_animated = value
    pos:
      get: () -> @currentPlate.pos
    bulletQueue:
      get: () -> @_bulletQueue

  directFrame: (direct) ->
    DIRECT_FRAME[direct]

  # ===============
  # Robot API
  # * move
  # * moveDirect
  # * approach
  # * leave 
  # * shot
  # * turn
  # ===============

  move: (direct, onComplete = () ->) ->
    plate = Map.instance.getTargetPoision(@currentPlate, direct)
    @direct = direct
    ret = @_move plate, () =>
      pos = plate.getAbsolutePos()
      @prevPlate.dispatchEvent(new RobotEvent('away', robot:@))
      @currentPlate.dispatchEvent(new RobotEvent('ride', robot:@))
      @tl.moveTo(pos.x, pos.y,
        Config.Frame.ROBOT_MOVE).then () =>
          @dispatchEvent(new RobotEvent('move', ret))
          onComplete()
    ret

  approach: (robot, onComplete = () ->) ->
    ret = false
    enemyPos = robot.pos
    robotPos = @pos
    robotPos.sub(enemyPos)

    direct = Direct.NONE
    if robotPos.x > 0
     direct |=  Direct.LEFT
    else if robotPos.x < 0
     direct |=  Direct.RIGHT

    if robotPos.y > 0
      direct |=  Direct.UP
      if robotPos.x == 0
        direct |= Direct.RIGHT
    else if robotPos.y < 0
      direct |=  Direct.DOWN
      if robotPos.x == 0
        direct |= Direct.LEFT

    if direct != Direct.NONE and direct != Direct.UP and direct != Direct.DOWN
      ret = @move(direct, onComplete)
    if ret == false
      onComplete()
    ret

  leave: (robot, onComplete = () ->) ->
    ret = false
    enemyPos = robot.pos
    robotPos = @pos
    robotPos.sub(enemyPos)

    direct = Direct.NONE
    if robotPos.x >= 0
     direct |=  Direct.RIGHT
    else if robotPos.x < 0
     direct |=  Direct.LEFT

    if robotPos.y >= 0
      direct |=  Direct.DOWN
      if robotPos.x == 0
        direct |= Direct.LEFT
    else if robotPos.y < 0
      direct |=  Direct.UP
      if robotPos.x == 0
        direct |= Direct.RIGHT

    if direct != Direct.NONE and direct != Direct.UP and direct != Direct.DOWN
      ret = @move(direct, onComplete)
    if ret == false
      onComplete()
    ret


  moveDirect: (plate) ->
    ret = @_move plate, () =>
      pos = plate.getAbsolutePos()
      @moveTo pos.x, pos.y
      @prevPlate.dispatchEvent(new RobotEvent('away', robot:@))
      @currentPlate.dispatchEvent(new RobotEvent('ride', robot:@))
    ret

  _move: (plate, closure) ->
    ret = false
    @prevPlate = @currentPlate
    # plate is exists and not locked
    if plate? and plate.lock == false
      pos = plate.getAbsolutePos()
      @currentPlate = plate
      closure()
      ret = new Point plate.ix, plate.iy
    else
      ret = false
    ret

  shot: (onComplete = () ->) ->
    ret = false
    unless @bulletQueue.empty()
      for b in @bulletQueue.dequeue()
        b.shot(@x, @y, @direct)
        setTimeout(onComplete, Util.toMillisec(b.maxFrame))
        ret = type:BulletType.NORMAL
    @dispatchEvent(new RobotEvent('shot', ret))
    ret

  pickup: (onComplete = () ->) ->
    ret = false
    blt = BulletFactory.create(BulletType.NORMAL, @)
    ret = @bulletQueue.enqueue(blt) if @bulletQueue?
    if ret != false
      item = new NormalBulletItem(@x, @y)
      item.setOnCompleteEvent(onComplete)
      ret = type:BulletType.NORMAL
    @dispatchEvent(new RobotEvent('pickup', ret))
    ret

  turn: (onComplete = () ->) ->
    setTimeout((() =>
      @direct = Direct.next(@direct)
      onComplete(@)
      @dispatchEvent(new RobotEvent('turn', {}))),
      Util.toMillisec(Config.Frame.ROBOT_TURN)
    )

  damege: () ->
    @hp -= 1

  update: ->
    # Why the @x @y does it become a floating-point number?
    @x = Math.round @x
    @y = Math.round @y

    @onKeyInput Game.instance.input
    return true

  onKeyInput: (input) ->

class PlayerRobot extends Robot
  @WIDTH = 64
  @HEIGHT = 74
  @UPDATE_FRAME = 10
  constructor: (parentNode) ->
    super PlayerRobot.WIDTH, PlayerRobot.HEIGHT, parentNode
    @name = R.String.PLAYER
    @image = Game.instance.assets[R.CHAR.PLAYER]
    @plateState = Plate.STATE_PLAYER

  onKeyInput: (input) ->
    if @animated == true
      return

    ret = true
    if input.w == true and input.p == true
      @animated = true
      ret = @move(Direct.LEFT | Direct.UP, @onDebugComplete)
    else if input.a == true and input.p == true
      @animated = true
      ret = @move(Direct.LEFT, @onDebugComplete)
    else if input.x == true and input.p == true
      @animated = true
      ret = @move(Direct.LEFT | Direct.DOWN, @onDebugComplete)
    else if input.d == true and input.p == true
      @animated = true
      ret = @move(Direct.RIGHT, @onDebugComplete)
    else if input.e == true and input.p == true
      @animated = true
      ret = @move(Direct.RIGHT | Direct.UP, @onDebugComplete)
    else if input.c == true and input.p == true
      @animated = true
      ret = @move(Direct.RIGHT | Direct.DOWN, @onDebugComplete)
    else if input.q == true and input.m == true
      @animated = true
      ret = @pickup(@onDebugComplete)
    else if input.q == true and input.n == true
      @animated = true
      @animated = true
      ret = @shot(@onDebugComplete)

    if ret == false
      @onDebugComplete()

  onDebugComplete: () =>
    @animated = false

class EnemyRobot extends Robot
  @WIDTH = 64
  @HEIGHT = 74
  @UPDATE_FRAME = 10
  constructor: (parentNode) ->
    super EnemyRobot.WIDTH, EnemyRobot.HEIGHT, parentNode
    @name = R.String.ENEMY
    @image = Game.instance.assets[R.CHAR.ENEMY]
    @plateState = Plate.STATE_ENEMY

  onKeyInput: (input) ->
    if @animated == true
      return

    ret = true
    if input.w == true and input.o == true
      @animated = true
      ret = @move(Direct.LEFT | Direct.UP, @onDebugComplete)
    else if input.a == true and input.o == true
      @animated = true
      ret = @move(Direct.LEFT, @onDebugComplete)
    else if input.x == true and input.o == true
      @animated = true
      ret = @move(Direct.LEFT | Direct.DOWN, @onDebugComplete)
    else if input.d == true and input.o == true
      @animated = true
      ret = @move(Direct.RIGHT, @onDebugComplete)
    else if input.e == true and input.o == true
      @animated = true
      ret = @move(Direct.RIGHT | Direct.UP, @onDebugComplete)
    else if input.c == true and input.o == true
      @animated = true
      ret = @move(Direct.RIGHT | Direct.DOWN, @onDebugComplete)

    if ret == false
      @onDebugComplete()

  onDebugComplete: () =>
    @animated = false
