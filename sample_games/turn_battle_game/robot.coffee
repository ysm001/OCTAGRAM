
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

class Robot extends Sprite
    @MAX_HP = 4
    bit = 1
    @LEFT = bit << 0
    @RIGHT = bit << 1
    @UP = bit << 2
    @DOWN = bit << 3
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

    
    onViewUpdate: (views) ->

    onHpReduce: (views) ->

    onKeyInput: (input) ->

    onCmdComplete: (id, ret) ->
        msgbox = @game.scene.views.msgbox
        switch id
            when Instruction.MOVE_UP, Instruction.MOVE_DOWN, Instruction.MOVE_LEFT, Instruction.MOVE_RIGHT
                if ret != false
                    msgbox.print R.String.move(@name, ret.x+1, ret.y+1)
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
                Robot.RIGHT
            when 1
                Robot.UP
            when 2
                Robot.LEFT
            when 3
                Robot.DOWN


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
            Debug.dump cmd
            Debug.log "id : #{cmd.instruction.id}"
            ret = cmd.eval @
            Debug.dump ret
            @onCmdComplete cmd.instruction.id, ret
            if cmd.instruction.id == Instruction.END
                ret = true
                break
        return ret

class PlayerRobot extends Robot
    @SIZE = 64
    @UPDATE_FRAME = 10
    constructor: () ->
        super PlayerRobot.SIZE, PlayerRobot.SIZE
        @name = R.String.PLAYER
        @image = @game.assets[R.CHAR.PLAYER]
        @cmdPool = new CommandPool

    onViewUpdate: (views) ->
        map = views.map
        prevTile = map.getTile @prevX, @prevY
        prevTile.setNormal()
        tile = map.getTile @x, @y
        tile.setPlayerSelected()

    onHpReduce: (views) ->
        scene = Game.instance.scene
        hpBar = scene.views.playerHpBar
        hpBar.reduce()

    onKeyInput: (input) ->
        if input.w == true
            @cmdQueue.enqueue @cmdPool.moveUp
            @cmdQueue.enqueue @cmdPool.end
        else if input.a == true
            @cmdQueue.enqueue @cmdPool.moveLeft
            @cmdQueue.enqueue @cmdPool.end
        else if input.x == true
            @cmdQueue.enqueue @cmdPool.moveDown
            @cmdQueue.enqueue @cmdPool.end
        else if input.d == true
            @cmdQueue.enqueue @cmdPool.moveRight
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

    getDirect: () ->
        switch @frame
            when 0
                Robot.RIGHT
            when 1
                Robot.UP
            when 2
                Robot.LEFT
            when 3
                Robot.DOWN

    onViewUpdate: (views) ->
        map = views.map
        prevTile = map.getTile @prevX, @prevY
        prevTile.setNormal()
        tile = map.getTile @x, @y
        tile.setEnemySelected()

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

            
