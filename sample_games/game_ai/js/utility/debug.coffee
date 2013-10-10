
DEBUG = true
class Debug
  @log: (obj) ->
    DEBUG && console.log "[AIGame Log]#{obj}"
  @dump: (obj) ->
    DEBUG && console.log obj

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
  type = null
  itemClass = null

  constructor: (@robot) ->
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
        



