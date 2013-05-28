
R = Config.R

class Robot extends Sprite
    @MAX_HP = 4
    constructor: (width, height) ->
        super width, height
        @game = Game.instance
        @iter = null
        @prevX = -1
        @prevY = -1
        @animated = false
        @hp = Robot.MAX_HP
        @queue = new CommandQueue

    setCmdCollection: (@cmdCollection) ->

    isAnimated: () ->
        @tl.queue.length != 0
    
    onBackgoundUpdate: (bgGroup) ->

    onHpReduce: (scene) ->

    onKeyInput: (input) ->

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
        unless @queue.empty()
            cmd = @queue.dequeue()
            cmd.eval @

class PlayerRobot extends Robot
    @SIZE = 64
    @UPDATE_FRAME = 10
    constructor: () ->
        super PlayerRobot.SIZE, PlayerRobot.SIZE
        @image = @game.assets[R.CHAR.ROBOT]

class EnemyRobot extends Robot
    @SIZE = 64
    @UPDATE_FRAME = 10
    constructor: () ->
        super EnemyRobot.SIZE, EnemyRobot.SIZE
        @image = @game.assets[R.CHAR.E_ROBOT]

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

            
