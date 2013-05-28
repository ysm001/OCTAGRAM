
class InstructionPool
    constructor: ()->
        map = Map.instance
        @moveUp = new Instruction "moveUp", () ->
            @tl.moveBy 0, -Map.UNIT_SIZE, PlayerRobot.UPDATE_FRAME
        @moveDown = new Instruction "moveDown", () ->
            @tl.moveBy 0, Map.UNIT_SIZE, PlayerRobot.UPDATE_FRAME
        @moveLeft = new Instruction "moveLeft", () ->
            @tl.moveBy -Map.UNIT_SIZE, 0, PlayerRobot.UPDATE_FRAME
        @moveRight = new Instruction "moveRight", () ->
            @tl.moveBy Map.UNIT_SIZE, 0, PlayerRobot.UPDATE_FRAME

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
        @hp1 = new PlayerHp 0, 0, PlayerHp.YELLOW
        @addChild @hp1
        @hp2 = new PlayerHp Header.WIDTH/2, 0, PlayerHp.BLUE
        @hp2.direct "left"
        @addChild @hp2
        
    update: (robotGroup) ->
        player = robotGroup.player
        prevTile = @map.getTile player.prevX,player.prevY
        tile = @map.getTile player.x,player.y
        prevTile.setNormal()
        tile.setSelected()

class RobotGroup extends Group
    constructor: (@scene) ->
        super
        @_instrPool = new InstructionPool
        @game = Game.instance
        @map = Map.instance
        @player = new PlayerRobot
        @player.x = @map.getX 4
        @player.y = @map.getY 4
        @addChild @player
        cmdCollection = [
            new Command(@_instrPool.moveUp),
            new Command(@_instrPool.moveLeft),
            new Command(@_instrPool.moveDown),
            new Command(@_instrPool.moveRight),
        ]
        Debug.dump cmdCollection
        @player.setCmdCollection cmdCollection

    initialize: (bgGroup)->
        nextBtn = bgGroup.nextBtn
        hp1 = bgGroup.hp1
        nextBtn.setOnClickEventListener =>
            if @player.isAnimated() is false
                hp1.reduce()
                @player.update()

    update: (bgGroup)->

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
        @keybind(90, 'a'); # z
        @keybind(88, 'b'); # x
        @keybind(67, 'c'); # c

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




