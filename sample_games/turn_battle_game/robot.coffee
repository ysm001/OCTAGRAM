
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
                else
                    msgbox.print R.String.CANNOTSHOT
            when RobotInstruction.PICKUP
                if ret != false
                    msgbox.print R.String.pickup(@name)
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

class PlayerRobot extends Robot
    @WIDTH = 64
    @HEIGHT = 74
    @UPDATE_FRAME = 10
    constructor: (parentNode) ->
        super PlayerRobot.WIDTH, PlayerRobot.HEIGHT, parentNode
        @name = R.String.PLAYER
        @image = @game.assets[R.CHAR.PLAYER]
        @plateState = Plate.STATE_PLAYER

    onSetBarrier: (bulletType) ->
        statusBox = @scene.views.footer.statusBox
        switch bulletType
            when BulletType.NORMAL
                statusBox.statusNormalBarrier.set()
            when BulletType.WIDE
                statusBox.statusWideBarrier.set()
            when BulletType.DUAL
                statusBox.statusDualBarrier.set()

    onResetBarrier: (bulletType) ->
        statusBox = @scene.views.footer.statusBox
        switch bulletType
            when BulletType.NORMAL
                statusBox.statusNormalBarrier.reset()
            when BulletType.WIDE
                statusBox.statusWideBarrier.reset()
            when BulletType.DUAL
                statusBox.statusDualBarrier.reset()

    onCmdComplete: (id, ret) ->
        super id, ret
        statusBox = @scene.views.footer.statusBox
        switch id
            when RobotInstruction.MOVE
                if Math.floor(Math.random() * (10)) == 1
                    plate = @map.getPlateRandom()
                    plate.setSpot(Spot.getRandomType())
            when RobotInstruction.SHOT
                if ret != false
                    effect = new ShotEffect(@x, @y)
                    @scene.addChild effect
                    if ret instanceof WideBullet
                        statusBox.wideRemain.decrement()
                    else if ret instanceof NormalBullet
                        statusBox.normalRemain.decrement()
                    else if ret instanceof DualBullet
                        statusBox.dualRemain.decrement()
            when RobotInstruction.PICKUP
                if ret != false
                    if ret instanceof WideBullet
                        statusBox.wideRemain.increment()
                    else if ret instanceof NormalBullet
                        statusBox.normalRemain.increment()
                    else if ret instanceof DualBullet
                        statusBox.dualRemain.increment()


    onHpReduce: (views) ->
        scene = Game.instance.scene
        hpBar = scene.views.playerHpBar
        hpBar.reduce()

class EnemyRobot extends Robot
    @SIZE = 64
    @UPDATE_FRAME = 10
    constructor: (parentNode) ->
        super EnemyRobot.SIZE, EnemyRobot.SIZE, parentNode
        @name = R.String.ENEMY
        @image = @game.assets[R.CHAR.ENEMY]
        @plateState = Plate.STATE_ENEMY

    onHpReduce: (views) ->
        hpBar = @scene.views.enemyHpBar
        hpBar.reduce()
