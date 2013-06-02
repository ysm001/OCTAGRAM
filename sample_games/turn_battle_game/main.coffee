
R = Config.R

class CommandPool

    constructor: () ->
        map = Map.instance
        @game = Game.instance

        end = new Instruction Instruction.END, () ->
            return true
        @end = new Command end

        moveUp = new Instruction Instruction.MOVE_UP, () ->
            ret = true
            @frame = 1
            y = @y - Map.UNIT_SIZE
            if !@map.isIntersect(@x, y) and y >= 0
                @tl.moveBy 0, -Map.UNIT_SIZE, PlayerRobot.UPDATE_FRAME
                ret = @map.getPos(@x, @y - Map.UNIT_SIZE)
            else
                ret = false
            return ret
        @moveUp = new Command moveUp

        moveDown = new Instruction Instruction.MOVE_DOWN, () ->
            ret = true
            @frame = 3
            y = @y + Map.UNIT_SIZE
            if !@map.isIntersect(@x, y) and y <= (Map.UNIT_SIZE * Map.HEIGHT)
                @tl.moveBy 0, Map.UNIT_SIZE, PlayerRobot.UPDATE_FRAME
                ret = @map.getPos(@x, @y + Map.UNIT_SIZE)
            else
                ret = false
            return ret
        @moveDown = new Command moveDown

        moveLeft = new Instruction Instruction.MOVE_LEFT, () ->
            ret = true
            @frame = 2
            x = @x - Map.UNIT_SIZE
            if !@map.isIntersect(x, @y) and x >= 0
                @tl.moveBy -Map.UNIT_SIZE, 0, PlayerRobot.UPDATE_FRAME
                ret = @map.getPos(@x - Map.UNIT_SIZE, @y)
            else
                ret = false
            return ret
        @moveLeft = new Command moveLeft

        moveRight = new Instruction Instruction.MOVE_RIGHT, () ->
            ret = true
            @frame = 0
            x = @x + Map.UNIT_SIZE
            if !@map.isIntersect(x, @y) and x <= (Map.UNIT_SIZE * (Map.WIDTH - 1))
                @tl.moveBy Map.UNIT_SIZE, 0, PlayerRobot.UPDATE_FRAME
                ret = @map.getPos(@x + Map.UNIT_SIZE, @y)
            else
                ret = false
            return ret
        @moveRight = new Command moveRight

        shot = new Instruction Instruction.SHOT, () ->
            scene = Game.instance.scene
            unless @bltQueue.empty()
                for b in @bltQueue.dequeue()
                    b.set(@x, @y, @getDirect())
                    scene.world.bullets.push b
                    scene.world.addChild b
                return true
            return false
        @shot = new Command shot

        search = new Instruction Instruction.SEARCH, () ->
            world = Game.instance.scene.world
            robot = if @ == world.player then world.enemy else @
            return new Point(@map.getPosX(robot.x - @x), @map.getPosY(robot.y - @y))

        @search = new Command search

        pickup = new Instruction Instruction.PICKUP, () ->
            ret = @bltQueue.enqueue(new DroidBullet(@x, @y, DroidBullet.RIGHT))
            return ret
        @pickup = new Command pickup
            
class ViewGroup extends Group

    constructor: (@scene) ->
        super
        @header = new Background 0, 0
        @addChild @header
        @header = new Header 0, 0
        @addChild @header
        @map = new Map 0, 32
        @addChild @map
        @msgbox = new MsgBox(5, @map.y + @map.height + 5)
        @addChild @msgbox
        #@nextBtn = new NextButton @msgbox.x + MsgBox.WIDTH + 8, @msgbox.y
        #@addChild @nextBtn
        @playerHpBar = new PlayerHp 0, 0, PlayerHp.YELLOW
        @addChild @playerHpBar
        @enemyHpBar = new PlayerHp Header.WIDTH/2, 0, PlayerHp.BLUE
        @enemyHpBar.direct "left"
        @addChild @enemyHpBar

    update: (world) ->
        for i in world.robots
            i.onViewUpdate(@)

class TurnSwitcher
    constructor: (@world) ->
        @i = 0

    update: ->
        animated = bullet = false
        for i in @world.bullets
            bullet = i.enabled
            break if bullet == true
        for i in @world.robots
            animated = i.isAnimated()
            break if animated == true

        if bullet is false and animated is false
            if @world.robots[@i].update()
                @i++
                @i = 0 if @i == @world.robots.length


class RobotWorld extends Group
    constructor: (@scene) ->
        super
        @game = Game.instance
        @map = Map.instance
        @robots = []
        @bullets = []
        @player = new PlayerRobot
        @player.x = @map.getX 3
        @player.y = @map.getY 4
        @addChild @player
        @robots.push @player

        @enemy = new EnemyRobot
        @enemy.x = @map.getX 8
        @enemy.y = @map.getY 4
        @addChild @enemy
        @robots.push @enemy

        @swicher = new TurnSwitcher @

    initialize: (views)->

    collisionBullet: (bullet, robot) ->
        #Debug.log "#{@map.getPosX(bullet.x)}, #{@map.getPosY(bullet.y)}"
        #Debug.log "#{@map.getPosX(robot.x)}, #{@map.getPosY(robot.y)}"
        return robot.within(bullet, 32)
        @map.getPosX(bullet.x) == @map.getPosX(robot.x) and
            @map.getPosY(bullet.y) == @map.getPosY(robot.y)


    updateBullets: () ->
        del = -1
        for v,i in @bullets
            if @collisionBullet(v, @enemy)
                del = i
                v.hit(@enemy)
                @bullets[i] = false
            else if v.enabled == false
                del = i
                @bullets[i] = false
            v.update()
        if del != -1
            @bullets = _.compact(@bullets)

    updateRobots: () ->
        animated = bullet = false
        for i in @bullets
            bullet = i.enabled
            break if bullet == true
        for i in @robots
            animated = i.isAnimated()
            break if animated == true

        if bullet is false and animated is false
            for i in @robots
                i.update()

    update: (views)->
        #@swicher.update()
        @updateRobots()
        @updateBullets()

class RobotScene extends Scene
    constructor: (@game) ->
        super @
        @backgroundColor = "#c0c0c0"
        @views = new ViewGroup @
        @world = new RobotWorld @
        @addChild @views
        @addChild @world

        @world.initialize @views

    onenterframe: ->
        @update()
        
    update: ->
        @world.update(@views)
        @views.update(@world)

class RobotGame extends Game
    constructor: (width, height) ->
        super width, height
        @_assetPreload()
        @keybind(87, 'w')
        @keybind(65, 'a')
        @keybind(88, 'x')
        @keybind(68, 'd')
        @keybind(83, 's')
        @keybind(81, 'q')

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
        for k,path of Config.R.EFFECT
            Debug.log "load image #{path}"
            @preload path
        for k,path of Config.R.BULLET
            Debug.log "load image #{path}"
            @preload path

    onload: ->
        @scene = new RobotScene @
        @pushScene @scene



window.onload = () ->
    game = new RobotGame Config.GAME_WIDTH, Config.GAME_WIDTH
    game.start()




