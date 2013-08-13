
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


class Robot extends Sprite
  @MAX_HP = 4
  constructor: (width, height, parentNode) ->
    super width, height
    @name = "robot"
    @game = Game.instance
    @animated = false
    @hp = Robot.MAX_HP
    @bltQueue = new ItemQueue [], 5
    @wideBltQueue = new ItemQueue [], 5
    @dualBltQueue = new ItemQueue [], 5
    @bulletQueue =
      normal : @bltQueue
      wide   : @wideBltQueue
      dual   : @dualBltQueue
    @barrierMap = new BarrierMap @
    @map = Map.instance
    @plateState = 0
    parentNode.addChild @
    plate = @map.getPlate(0,0)
    @prevPlate = @currentPlate = plate
    pos = plate.getAbsolutePos()
    @moveTo pos.x, pos.y
  
  onViewUpdate: (views) ->

  onHpReduce: (views) ->

  onKeyInput: (input) ->

  onAnimateComplete: () =>
    @animated = false

  onSetBarrier: (bulletType) ->

  onResetBarrier: (bulletType) ->

  onCmdComplete: (id, ret) ->
    msgbox = @scene.views.msgbox
    switch id
      when RobotInstruction.MOVE
        @prevPlate.onRobotAway(@)
        @currentPlate.onRobotRide(@)
        if ret != false
          msgbox.print R.String.move(@name, ret.x+1, ret.y+1)
          @animated = true
        else
          msgbox.print R.String.CANNOTMOVE
      when RobotInstruction.SHOT
        if ret != false
          msgbox.print R.String.shot(@name)
          @animated = true
        else
          msgbox.print R.String.CANNOTSHOT
      when RobotInstruction.PICKUP
        if ret != false
          msgbox.print R.String.pickup(@name)
          @animated = true
        else
          msgbox.print R.String.CANNOTPICKUP
    
  moveToPlate: (plate) ->
    @prevPlate.onRobotAway(@)
    @pravState = @currentPlate
    @currentPlate = plate
    @currentPlate.onRobotRide(@)
    pos = plate.getAbsolutePos()
    @moveTo pos.x, pos.y

  # return the direction the robot
  # is faceing
  getDirect: () ->
    switch @frame
      when 0
        Direct.RIGHT
      when 1
        Direct.UP
      when 2
        Direct.LEFT
      when 3
        Direct.DOWN
      when 4
        Direct.UP | Direct.RIGHT
      when 5
        Direct.DOWN | Direct.RIGHT
      when 6
        Direct.UP | Direct.LEFT
      when 7
        Direct.DOWN | Direct.LEFT

  damege: () ->
    @hp -= 1
    @onHpReduce()

  update: ->
    # Why the @ x @ y does it become a floating-point number?
    @x = Math.round @x
    @y = Math.round @y

    @onKeyInput @game.input
    return true

class DebugCommand
  @direct = [
    Direct.RIGHT
    Direct.RIGHT | Direct.UP
    Direct.RIGHT | Direct.DOWN
    Direct.LEFT
    Direct.LEFT | Direct.UP
    Direct.LEFT | Direct.DOWN
  ]
  @playerFrame = [
    0, 4, 5, 2, 6, 7
  ]
  constructor: (@robot) ->

  move: (directIndex) ->
    @robot.frame = DebugCommand.playerFrame[directIndex]
    plate = @robot.map.getTargetPoision(@robot.currentPlate, DebugCommand.direct[directIndex])
    ret = false
    @robot.prevPlate = @robot.currentPlate
    if plate? and plate.lock == false
      pos = plate.getAbsolutePos()
      @robot.tl.moveTo(pos.x, pos.y, PlayerRobot.UPDATE_FRAME).then(() => @onComplete())
      @robot.currentPlate = plate
      ret = new Point plate.ix, plate.iy
    else
      ret = false
    @robot.onCmdComplete(RobotInstruction.MOVE, ret)
    return ret

  type = [
    BulletType.NORMAL
    BulletType.WIDE
    BulletType.DUAL
  ]
  itemClass = [
    NormalBulletItem,
    WideBulletItem,
    DualBulletItem
  ]
  pickup: (queue, bltIndex) ->
    blt = BulletFactory.create(type[bltIndex], @robot)
    ret = queue.enqueue(blt)
    if ret != false
      item = new itemClass[bltIndex](@robot.x, @robot.y)
      @robot.scene.world.addChild item
      @robot.scene.world.items.push item
      item.setOnCompleteEvent(() => @onComplete())
      ret = blt
    @robot.onCmdComplete(RobotInstruction.PICKUP, ret)


  shot: (queue) ->
    ret = false
    unless queue.empty()
      for b in queue.dequeue()
        b.shot(@robot.x, @robot.y, @robot.getDirect())
        @robot.scene.world.bullets.push b
        @robot.scene.world.insertBefore b, @robot
        b.setOnDestoryEvent(() => @onComplete())
        ret = b
    @robot.onCmdComplete(RobotInstruction.SHOT ,ret)

  onComplete: () ->
    @robot.onAnimateComplete()

class PlayerRobot extends Robot
  @WIDTH = 64
  @HEIGHT = 74
  @UPDATE_FRAME = 10
  constructor: (parentNode) ->
    super PlayerRobot.WIDTH, PlayerRobot.HEIGHT, parentNode
    @name = R.String.PLAYER
    @image = @game.assets[R.CHAR.PLAYER]
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
    switch id
      when RobotInstruction.MOVE
        if Math.floor(Math.random() * (10)) == 1
          i = 1
          #plate = @map.getPlateRandom()
          #plate.setSpot(Spot.getRandomType())
      when RobotInstruction.SHOT
        if ret != false
          effect = new ShotEffect(@x, @y)
          @scene.addChild effect
          if ret instanceof WideBullet
            Util.dispatchEvent("dequeueBullet", {bulletType:BulletType.WIDE})
          else if ret instanceof NormalBullet
            Util.dispatchEvent("dequeueBullet", {bulletType:BulletType.NORMAL})
          else if ret instanceof DualBullet
            Util.dispatchEvent("dequeueBullet", {bulletType:BulletType.DUAL})
      when RobotInstruction.PICKUP
        if ret != false
          if ret instanceof WideBullet
            Util.dispatchEvent("enqueueBullet", {bulletType:BulletType.WIDE})
          else if ret instanceof NormalBullet
            Util.dispatchEvent("enqueueBullet", {bulletType:BulletType.NORMAL})
          else if ret instanceof DualBullet
            Util.dispatchEvent("enqueueBullet", {bulletType:BulletType.DUAL})


  onHpReduce: (views) ->
    scene = Game.instance.scene
    hpBar = scene.views.playerHpBar
    hpBar.reduce()

class EnemyRobot extends Robot
  @WIDTH = 64
  @HEIGHT = 74
  @UPDATE_FRAME = 10
  constructor: (parentNode) ->
    super EnemyRobot.WIDTH, EnemyRobot.HEIGHT, parentNode
    @name = R.String.ENEMY
    @image = @game.assets[R.CHAR.ENEMY]
    @plateState = Plate.STATE_ENEMY
    @debugCmd = new DebugCommand(@)

  onHpReduce: (views) ->
    hpBar = @scene.views.enemyHpBar
    hpBar.reduce()

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
