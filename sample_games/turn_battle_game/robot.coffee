
R = Config.R

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

class Robot extends Sprite
    @MAX_HP = 4
    constructor: (width, height) ->
        super width, height
        @name = "robot"
        @game = Game.instance
        @iter = null
        @prevX = -1
        @prevY = -1
        @animated = false
        @hp = Robot.MAX_HP
        @cmdQueue = new CommandQueue
        @bltQueue = new ItemQueue [], 5
        @map = Map.instance
        @prevPlate = @map.plateMatrix[0][0]
        @currentPlate = @map.plateMatrix[0][0]
        pos = @currentPlate.getAbsolutePos()
        @x = pos.x
        @y = pos.y
    
    onViewUpdate: (views) ->

    onHpReduce: (views) ->

    onKeyInput: (input) ->

    createBullet: () ->

    onAnimateComplete: () =>
        @animated = false

    onCmdComplete: (id, ret) ->
        msgbox = @game.scene.views.msgbox
        switch id
            when Instruction.MOVE_RIGHT_UP, Instruction.MOVE_RIGHT_DOWN, Instruction.MOVE_LEFT_DOWN, Instruction.MOVE_LEFT_UP, Instruction.MOVE_LEFT, Instruction.MOVE_RIGHT
                if ret != false
                    msgbox.print R.String.move(@name, ret.x+1, ret.y+1)
                    @animated = true
                else
                    msgbox.print R.String.CANNOTMOVE
            when Instruction.SHOT
                if ret != false
                    msgbox.print R.String.shot(@name)
                else
                    msgbox.print R.String.CANNOTSHOT
            when Instruction.PICKUP
                if ret != false
                    msgbox.print R.String.pickup(@name)
                else
                    msgbox.print R.String.CANNOTPICKUP
        
        
    setCmdCollection: (@cmdCollection) ->

    isAnimated: () ->
        @tl.queue.length != 0

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
        @prevX = @x
        @prevY = @y
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
            ret = cmd.eval @
            #Debug.dump ret
            @onCmdComplete cmd.instruction.id, ret
            if cmd.instruction.id == Instruction.END
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
        @cmdPool = new CommandPool

    createBullet: () ->
        new DroidBullet(@x, @y, DroidBullet.RIGHT)

    onViewUpdate: (views) ->
        @prevPlate.setNormal()
        @currentPlate.setPlayerSelected()

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
            @cmdQueue.enqueue @cmdPool.shot
            @cmdQueue.enqueue @cmdPool.end
        else if input.q == true
            @cmdQueue.enqueue @cmdPool.pickup
            @cmdQueue.enqueue @cmdPool.end

class EnemyRobot extends Robot
    @SIZE = 64
    @UPDATE_FRAME = 10
    constructor: () ->
        super EnemyRobot.SIZE, EnemyRobot.SIZE
        @name = R.String.ENEMY
        @image = @game.assets[R.CHAR.ENEMY]
        @cmdPool = new CommandPool

    createBullet: () ->
        new DroidBullet(@x, @y, DroidBullet.RIGHT)

    onViewUpdate: (views) ->
        @prevPlate.setNormal()
        @currentPlate.setEnemySelected()

    onHpReduce: (views) ->
        scene = Game.instance.scene
        hpBar = scene.views.enemyHpBar
        hpBar.reduce()

    onKeyInput:(input) ->
        if input.i == true
            @cmdQueue.enqueue @cmdPool.moveUp
        else if input.j == true
            @cmdQueue.enqueue @cmdPool.moveLeft
        else if input.m == true
            @cmdQueue.enqueue @cmdPool.moveDown
        else if input.l == true
            @cmdQueue.enqueue @cmdPool.moveRight

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

            
