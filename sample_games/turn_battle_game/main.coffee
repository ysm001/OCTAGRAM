
class CommandPool
    constructor: ()->
        map = Map.instance
        moveUp = new Instruction "moveUp", () ->
            if @y - Map.UNIT_SIZE >= 0
                @tl.moveBy 0, -Map.UNIT_SIZE, PlayerRobot.UPDATE_FRAME
        @moveUp = new Command moveUp

        moveDown = new Instruction "moveDown", () ->
            if @y + Map.UNIT_SIZE <= Map.UNIT_SIZE * Map.HEIGHT
                @tl.moveBy 0, Map.UNIT_SIZE, PlayerRobot.UPDATE_FRAME
        @moveDown = new Command moveDown

        moveLeft = new Instruction "moveLeft", () ->
            if @x - Map.UNIT_SIZE >= 0
                @tl.moveBy -Map.UNIT_SIZE, 0, PlayerRobot.UPDATE_FRAME
        @moveLeft = new Command moveLeft

        moveRight = new Instruction "moveRight", () ->
            if @x + Map.UNIT_SIZE <= Map.UNIT_SIZE * (Map.WIDTH - 1)
                @tl.moveBy Map.UNIT_SIZE, 0, PlayerRobot.UPDATE_FRAME
        @moveRight = new Command moveRight


class BackgroundGroup extends Group

    constructor: (@scene) ->
        super
        @header = new Header 0, 0
        @addChild @header
        @map = new Map 0, 32
        @addChild @map
        @msgbox = new MsgBox(5, @map.y + @map.height + 5)
        @addChild @msgbox
        @nextBtn = new NextButton @msgbox.x + MsgBox.WIDTH + 8, @msgbox.y
        @addChild @nextBtn
        @playerHpBar = new PlayerHp 0, 0, PlayerHp.YELLOW
        @addChild @playerHpBar
        @enemyHpBar = new PlayerHp Header.WIDTH/2, 0, PlayerHp.BLUE
        @enemyHpBar.direct "left"
        @addChild @enemyHpBar

    update: (robotGroup) ->
        for i in robotGroup.robots
            i.onBackgoundUpdate(@)

class TurnSwitcher
    constructor: (@robots) ->
        @i = 0

    update: ->
        if @robots[@i].isAnimated() is false
            if @robots[@i].update()
                @i++
                @i = 0 if @i == @robots.length

class RobotGroup extends Group
    constructor: (@scene) ->
        super
        _cmdPool = new CommandPool
        @game = Game.instance
        @map = Map.instance
        @robots = []
        @player = new PlayerRobot
        @player.x = @map.getX 3
        @player.y = @map.getY 4
        @player.onBackgoundUpdate = (group) ->
            map = group.map
            prevTile = map.getTile @prevX, @prevY
            prevTile.setNormal()
            tile = map.getTile @x, @y
            tile.setPlayerSelected()
        @player.onHpReduce = (scene) ->
            hpBar = scene.bgGroup.playerHpBar
            hpBar.reduce()
        @player.onKeyInput = (input) ->
            if input.w == true
                @queue.enqueue _cmdPool.moveUp
            else if input.a == true
                @queue.enqueue _cmdPool.moveLeft
            else if input.x == true
                @queue.enqueue _cmdPool.moveDown
            else if input.d == true
                @queue.enqueue _cmdPool.moveRight

        @addChild @player
        @robots.push @player

        @enemy = new EnemyRobot
        @enemy.x = @map.getX 8
        @enemy.y = @map.getY 4
        @enemy.onBackgoundUpdate = (group) ->
            map = group.map
            prevTile = map.getTile @prevX, @prevY
            prevTile.setNormal()
            tile = map.getTile @x, @y
            tile.setEnemySelected()
        @enemy.onHpReduce = (scene) ->
            hpBar = scene.bgGroup.enemyHpBar
            hpBar.reduce()
        @enemy.onKeyInput = (input) ->
            if input.i == true
                @queue.enqueue _cmdPool.moveUp
            else if input.j == true
                @queue.enqueue _cmdPool.moveLeft
            else if input.m == true
                @queue.enqueue _cmdPool.moveDown
            else if input.l == true
                @queue.enqueue _cmdPool.moveRight

        @addChild @enemy
        @robots.push @enemy

        @swicher = new TurnSwitcher @robots

    initialize: (bgGroup)->
        nextBtn = bgGroup.nextBtn
        nextBtn.setOnClickEventListener =>
            #if @player.isAnimated() is false
            #    @player.update()

    update: (bgGroup)->
        @swicher.update()

class RobotScene extends Scene
    constructor: (@game) ->
        super @
        @backgroundColor = "#c0c0c0"
        @bgGroup = new BackgroundGroup @
        @robotGroup = new RobotGroup @
        @addChild @bgGroup
        @addChild @robotGroup

        @robotGroup.initialize @bgGroup

    onenterframe: ->
        @update()
        
    update: ->
        @robotGroup.update(@bgGroup)
        @bgGroup.update(@robotGroup)

class RobotGame extends Game
    constructor: (width, height) ->
        super width, height
        @_assetPreload()
        @keybind(87, 'w')
        @keybind(65, 'a')
        @keybind(88, 'x')
        @keybind(68, 'd')
        @keybind(83, 's')

        @keybind(76, 'l')
        @keybind(77, 'm')
        @keybind(74, 'j')
        @keybind(73, 'i')
        @keybind(75, 'k')

    _assetPreload: ->
        for k,path of Config.R.CHAR
            Debug.log "load image #{path}"
            @preload path
        for k,path of Config.R.BACKGROUND_IMAGE
            Debug.log "load image #{path}"
            @preload path
        for k,path of Config.R.UI
            Debug.log "load image #{path}"
            @preload path

    onload: ->
        scene = new RobotScene @
        @pushScene scene



window.onload = () ->
    game = new RobotGame Config.GAME_WIDTH, Config.GAME_WIDTH
    game.start()




