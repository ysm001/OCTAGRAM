
R = Config.R

class Robot extends Sprite
    constructor: (width, height) ->
        super width, height
        @game = Game.instance
        @iter = null
        @prevX = -1
        @prevY = -1
        @animated = false

    setCmdCollection: (@cmdCollection) ->

    isAnimated: () ->
        @tl.queue.length != 0

    update: ->
        @prevX = @x
        @prevY = @y
        unless @cmdCollection?
            return
        unless @iter?
            @iter = new CommandIterator @cmdCollection
        unless @iter.hasNext()
            @iter = new CommandIterator @cmdCollection

        cmd = @iter.next()
        cmd.eval @

class PlayerRobot extends Robot
    @SIZE = 64
    @UPDATE_FRAME = 10
    constructor: () ->
        super PlayerRobot.SIZE, PlayerRobot.SIZE
        @image = @game.assets[R.CHAR.ROBOT]

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

            
