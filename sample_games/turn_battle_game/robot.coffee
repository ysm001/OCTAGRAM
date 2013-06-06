
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

    constructor: () ->

    get:(key) ->
        ret = @[key]
        delete @[key]
        return ret

    isset:(key) ->
        return if @[key]? then true else false


class Robot extends Sprite
    @MAX_HP = 4
    constructor: (width, height) ->
        super width, height
        @name = "robot"
        @game = Game.instance
        @animated = false
        @hp = Robot.MAX_HP
        @cmdQueue = new CommandQueue
        @bltQueue = new ItemQueue [], 5
        @wideBltQueue = new ItemQueue [], 5
        @dualBltQueue = new ItemQueue [], 5
        @barrierMap = new BarrierMap
        @map = Map.instance
        @prevPlate = @map.plateMatrix[0][0]
        @currentPlate = @map.plateMatrix[0][0]
        pos = @currentPlate.getAbsolutePos()
        @x = pos.x
        @y = pos.y
    
    onViewUpdate: (views) ->
        @prevPlate.setNormal()
        @currentPlate.onRobotRide(@)

    onHpReduce: (views) ->

    onKeyInput: (input) ->

    onAnimateComplete: () =>
        @animated = false

    onCmdComplete: (id, ret) ->
        msgbox = @scene.views.msgbox
        switch id
            when RobotInstruction.MOVE
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
        # unless @cmdCollection?
        #     return
        # unless @iter?
        #     @iter = new CommandIterator @cmdCollection
        # unless @iter.hasNext()
        #     @iter = new CommandIterator @cmdCollection

        # cmd = @iter.next()
        @onKeyInput @game.input
        ret = false
        while @cmdQueue.empty() == false
            cmd = @cmdQueue.dequeue()
            #Debug.dump cmd
            #Debug.log "id : #{cmd.instruction.id}"
            ret = cmd.eval()
            #Debug.dump ret
            @onCmdComplete cmd.instruction.id, ret
            if cmd.instruction.id == RobotInstruction.END
                ret = true
                break
        return ret

class PlayerRobot extends Robot
    @WIDTH = 64
    @HEIGHT = 74
    @UPDATE_FRAME = 10
    constructor: () ->
        super PlayerRobot.WIDTH, PlayerRobot.HEIGHT
        @name = R.String.PLAYER
        @image = @game.assets[R.CHAR.PLAYER]
        @cmdPool = new CommandPool @

    onCmdComplete: (id, ret) ->
        super id, ret
        statusBox = @scene.views.footer.statusBox
        switch id
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

    onKeyInput: (input) ->
        if input.w == true
            @cmdQueue.enqueue @cmdPool.moveLeftUp
            @cmdQueue.enqueue @cmdPool.end
        else if input.a == true
            @cmdQueue.enqueue @cmdPool.moveLeft
            @cmdQueue.enqueue @cmdPool.end
        else if input.x == true
            @cmdQueue.enqueue @cmdPool.moveleftDown
            @cmdQueue.enqueue @cmdPool.end
        else if input.d == true
            @cmdQueue.enqueue @cmdPool.moveRight
            @cmdQueue.enqueue @cmdPool.end
        else if input.e == true
            @cmdQueue.enqueue @cmdPool.moveRightUp
            @cmdQueue.enqueue @cmdPool.end
        else if input.c == true
            @cmdQueue.enqueue @cmdPool.moveRightDown
            @cmdQueue.enqueue @cmdPool.end
        else if input.s == true
            @cmdQueue.enqueue @cmdPool.search
            rand = Math.floor(Math.random() * 3)
            switch rand
                when 0
                    @cmdQueue.enqueue @cmdPool.shotNormal
                when 1
                    @cmdQueue.enqueue @cmdPool.shotWide
                when 2
                    @cmdQueue.enqueue @cmdPool.shotDual
                else
                    @cmdQueue.enqueue @cmdPool.shotNormal
            @cmdQueue.enqueue @cmdPool.end
        else if input.q == true
            rand = Math.floor(Math.random() * 3)
            switch rand
                when 0
                    @cmdQueue.enqueue @cmdPool.pickupNormal
                when 1
                    @cmdQueue.enqueue @cmdPool.pickupWide
                when 2
                    @cmdQueue.enqueue @cmdPool.pickupDual
                else
                    @cmdQueue.enqueue @cmdPool.pickupNormal
            @cmdQueue.enqueue @cmdPool.end

class EnemyRobot extends Robot
    @SIZE = 64
    @UPDATE_FRAME = 10
    constructor: () ->
        super EnemyRobot.SIZE, EnemyRobot.SIZE
        @name = R.String.ENEMY
        @image = @game.assets[R.CHAR.ENEMY]
        @cmdPool = new CommandPool @

    onHpReduce: (views) ->
        hpBar = @scene.views.enemyHpBar
        hpBar.reduce()

    onKeyInput:(input) ->
        if input.w == true
            @cmdQueue.enqueue @cmdPool.moveLeftUp
            @cmdQueue.enqueue @cmdPool.end
        else if input.a == true
            @cmdQueue.enqueue @cmdPool.moveLeft
            @cmdQueue.enqueue @cmdPool.end
        else if input.x == true
            @cmdQueue.enqueue @cmdPool.moveleftDown
            @cmdQueue.enqueue @cmdPool.end
        else if input.d == true
            @cmdQueue.enqueue @cmdPool.moveRight
            @cmdQueue.enqueue @cmdPool.end
        else if input.e == true
            @cmdQueue.enqueue @cmdPool.moveRightUp
            @cmdQueue.enqueue @cmdPool.end
        else if input.c == true
            @cmdQueue.enqueue @cmdPool.moveRightDown
            @cmdQueue.enqueue @cmdPool.end
        else if input.s == true
            @cmdQueue.enqueue @cmdPool.search
            rand = Math.floor(Math.random() * 3)
            switch rand
                when 0
                    @cmdQueue.enqueue @cmdPool.shotNormal
                when 1
                    @cmdQueue.enqueue @cmdPool.shotWide
                else
                    @cmdQueue.enqueue @cmdPool.shotNormal
            @cmdQueue.enqueue @cmdPool.end
        else if input.q == true
            rand = Math.floor(Math.random() * 3)
            switch rand
                when 0
                    @cmdQueue.enqueue @cmdPool.pickupNormal
                when 1
                    @cmdQueue.enqueue @cmdPool.pickupWide
                else
                    @cmdQueue.enqueue @cmdPool.pickupNormal
            @cmdQueue.enqueue @cmdPool.end
