
R = Config.R

putTestCode = (player) ->
    ###
    Game.instance.addInstruction(new MoveInstruction(@player))
    Game.instance.addInstruction(new ShotInstruction(@player))
    Game.instance.addInstruction(new PickupInstruction(@player))
    Game.instance.addInstruction(new HpBranchInstruction(@player))
    Game.instance.addInstruction(new HoldBulletBranchInstruction(@player))
    Game.instance.addInstruction(new SearchDirectRobotBranchInstruction(@player))
    Game.instance.addInstruction(new SearchDirectItemBranchInstruction(@player))
    ###

    # instructions
    moveInstruction = new MoveInstruction(player)
    moveRightInstruction = moveInstruction.clone()
    moveRightInstruction._id = 0

    moveRightUpInstruction = moveInstruction.clone()
    moveRightUpInstruction._id = 1

    moveRightDownInstruction = moveInstruction.clone()
    moveRightDownInstruction._id = 2

    moveLeftInstruction = moveInstruction.clone()
    moveLeftInstruction._id = 3

    moveLeftUpInstruction = moveInstruction.clone()
    moveLeftUpInstruction._id = 4

    moveLeftDownInstruction = moveInstruction.clone()
    moveLeftDownInstruction._id = 5

    pickupInstruction = new PickupInstruction(player)
    pickupNormalInstruction = pickupInstruction.clone()
    pickupNormalInstruction._id = 0

    pickupWideInstruction = pickupInstruction.clone()
    pickupWideInstruction._id = 1

    pickupDualInstruction = pickupInstruction.clone()
    pickupDualInstruction._id = 2

    shotInstruction = new ShotInstruction(player)
    shotNormalInstruction = shotInstruction.clone()
    shotNormalInstruction._id = 0

    searchDirectRobotBranchInstruction = new SearchDirectRobotBranchInstruction(player)
    searchDirectLeftRobotBranchInstruction = searchDirectRobotBranchInstruction.clone()
    searchDirectLeftRobotBranchInstruction._id = 3
    searchDirectLeftRobotBranchInstruction.lenght = 4

    currentDirectBranchInstruction = new CurrentDirectBranchInstruction(player)
    currentDirectLeftBranchInstruction = currentDirectBranchInstruction.clone()
    currentDirectLeftBranchInstruction._id = 3

    holdBulletBranchInstruction = new HoldBulletBranchInstruction(player)
    holdBullet1BranchInstruction = holdBulletBranchInstruction.clone()
    holdBullet1BranchInstruction._id = 0
    holdBullet1BranchInstruction.bulletSize = 1

    # tips
    left1Tip = TipFactory.createInstructionTip(moveLeftInstruction.clone())
    left2Tip = TipFactory.createInstructionTip(moveLeftInstruction.clone())

    leftUpTip = TipFactory.createInstructionTip(moveLeftUpInstruction.clone())

    rightUpTip = TipFactory.createInstructionTip(moveRightUpInstruction.clone())

    rightDownTip = TipFactory.createInstructionTip(moveRightDownInstruction.clone())

    randomBranchInstruction = new RandomBranchInstruction()
    randomBranchInstruction.threthold = 15
    random1Tip = TipFactory.createInstructionTip(randomBranchInstruction)
    randomBranchInstruction = randomBranchInstruction.clone()
    randomBranchInstruction.threthold = 30
    random2Tip = TipFactory.createInstructionTip(randomBranchInstruction)
    randomBranchInstruction = randomBranchInstruction.clone()
    randomBranchInstruction.threthold = 75
    random3Tip = TipFactory.createInstructionTip(randomBranchInstruction)
    randomBranchInstruction = randomBranchInstruction.clone()
    randomBranchInstruction.threthold = 90
    random4Tip = TipFactory.createInstructionTip(randomBranchInstruction)

    pickupNormalTip = TipFactory.createInstructionTip(pickupNormalInstruction.clone())

    shotNormalTip = TipFactory.createInstructionTip(shotNormalInstruction.clone())

    returnTip1 = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    returnTip2 = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    returnTip3 = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    returnTip4 = TipFactory.createReturnTip(Environment.startX, Environment.startY)
    returnTip5 = TipFactory.createReturnTip(Environment.startX, Environment.startY)

    searchLeftTip = TipFactory.createInstructionTip(searchDirectLeftRobotBranchInstruction.clone())
    currentLeftTip = TipFactory.createInstructionTip(currentDirectLeftBranchInstruction.clone())
    holdTip = TipFactory.createInstructionTip(holdBullet1BranchInstruction.clone())

    # 条件分岐チップの設定
    # x, y, 進行方向(true), 進行方向(false), チップ
    Game.instance.vpl.cpu.putBranchTip(4,0,Direction.leftDown,Direction.rightDown,searchLeftTip)
    Game.instance.vpl.cpu.putBranchTip(3,1,Direction.leftDown,Direction.rightDown,currentLeftTip)
    Game.instance.vpl.cpu.putBranchTip(2,2,Direction.leftDown,Direction.rightDown,holdTip)
    Game.instance.vpl.cpu.putTip(4, 2, Direction.down, left1Tip)
    Game.instance.vpl.cpu.putTip(3, 3, Direction.right, pickupNormalTip)
    Game.instance.vpl.cpu.putSingleTip(4, 3,returnTip4)
    Game.instance.vpl.cpu.putTip(1, 3, Direction.down, shotNormalTip)
    Game.instance.vpl.cpu.putSingleTip(1, 4,returnTip5)

    Game.instance.vpl.cpu.putBranchTip(5,1,Direction.right,Direction.down,random1Tip)
    Game.instance.vpl.cpu.putBranchTip(5,2,Direction.right,Direction.down,random2Tip)
    Game.instance.vpl.cpu.putBranchTip(5,3,Direction.right,Direction.down,random3Tip)
    Game.instance.vpl.cpu.putBranchTip(5,4,Direction.right,Direction.down,random4Tip)

    Game.instance.vpl.cpu.putTip(6, 1, Direction.rightDown, left2Tip)
    Game.instance.vpl.cpu.putSingleTip(7, 2,returnTip1)
    Game.instance.vpl.cpu.putTip(6, 2, Direction.right, leftUpTip)
    Game.instance.vpl.cpu.putTip(6, 3, Direction.rightUp, rightUpTip)
    Game.instance.vpl.cpu.putTip(6, 4, Direction.right, rightDownTip)
    Game.instance.vpl.cpu.putSingleTip(7, 4,returnTip2)
    Game.instance.vpl.cpu.putSingleTip(5, 5,returnTip3)
    # 遷移先の無いチップの設定
    # x, y, チップ
    #Game.instance.vpl.cpu.putSingleTip(6,0,stopTip)
            
class ViewGroup extends Group
    constructor: (x, y, @scene) ->
        super
        @x = x
        @y = y
        @background = new Background 0, 0
        @addChild @background

        @header = new Header 16, 16
        @playerHpBar = @header.playerHpBar
        @enemyHpBar = @header.enemyHpBar
        @addChild @header

        @map = new Map 16, 48
        @addChild @map

        @footer = new Footer(25, @map.y + @map.height)
        @msgbox = @footer.msgbox
        @addChild @footer
        #@nextBtn = new NextButton @msgbox.x + MsgBox.WIDTH + 8, @msgbox.y
        #@addChild @nextBtn

    update: (world) ->
        for i in world.robots
            i.onViewUpdate(@)
        @map.update()

class TurnSwitcher
    constructor: (@world) ->
        @i = 0

    update: ->
        animated = bullet = false
        for i in @world.bullets
            bullet = i.animated
            break if bullet == true
        for i in @world.robots
            animated = i.isAnimated()
            break if animated == true

        if bullet is false and animated is false
            if @world.robots[@i].update()
                @i++
                @i = 0 if @i == @world.robots.length

class RobotWorld extends Group
    constructor: (x, y, @scene) ->
        super
        @game = Game.instance
        @map = Map.instance
        @robots = []
        @bullets = []
        @items = []
        @player = new PlayerRobot @
        @addChild @player
        @robots.push @player
        plate = @map.getPlate(6,4)
        @player.moveToPlate(plate)

        @enemy = new EnemyRobot @
        @addChild @enemy
        @robots.push @enemy
        plate = @map.getPlate(1,1)
        @enemy.moveToPlate(plate)

        Game.instance.addInstruction(new MoveInstruction(@player))
        Game.instance.addInstruction(new ShotInstruction(@player))
        Game.instance.addInstruction(new PickupInstruction(@player))
        Game.instance.addInstruction(new HpBranchInstruction(@player))
        Game.instance.addInstruction(new HoldBulletBranchInstruction(@player))
        Game.instance.addInstruction(new SearchDirectRobotBranchInstruction(@player))
        Game.instance.addInstruction(new SearchDirectItemBranchInstruction(@player))
        Game.instance.addInstruction(new CurrentDirectBranchInstruction(@player))
        # @swicher = new TurnSwitcher @

    initialize: (views)->

    collisionBullet: (bullet, robot) ->
        return bullet.holder != robot and bullet.within(robot, 32)

    updateItems: () ->
        del = -1
        for v,i in @items
            if v.animated == false
                del = i
                @items[i] = false
        if del != -1
            @items = _.compact(@items)
        

    updateBullets: () ->
        del = -1
        for robot in @robots
            for v,i in @bullets
                if v != false
                    if @collisionBullet(v, robot)
                        del = i
                        v.hit(robot)
                        @bullets[i] = false
                    else if v.animated == false
                        del = i
                        @bullets[i] = false
        if del != -1
            @bullets = _.compact(@bullets)

    _isAnimated: (array, func) ->
        animated = false
        for i in array
            animated = func(i)
            break if animated == true
        return animated

    updateRobots: () ->
        animated = false
        for i in [@bullets, @robots, @items]
            animated = @_isAnimated(i, (x) -> x.animated)
            break if animated == true

        if animated is false
            for i in @robots
                i.update()

    update: (views)->
        #@swicher.update()
        @updateItems()
        @updateRobots()
        @updateBullets()

class RobotScene extends Scene
    constructor: (@game) ->
        super @
        @views = new ViewGroup Config.GAME_OFFSET_X, Config.GAME_OFFSET_Y, @
        @world = new RobotWorld Config.GAME_OFFSET_X, Config.GAME_OFFSET_Y, @
        @addChild @views
        @addChild @world

        @world.initialize @views

    onenterframe: ->
        @update()
        
    update: ->
        @world.update(@views)
        @views.update(@world)

class RobotGame extends TipBasedVPL
    constructor: (width, height) ->
        super width, height, "./tip_based_vpl/resource/"
        @_assetPreload()
        @keybind(87, 'w')
        @keybind(65, 'a')
        @keybind(88, 'x')
        @keybind(68, 'd')
        @keybind(83, 's')
        @keybind(81, 'q')
        @keybind(69, 'e')
        @keybind(67, 'c')

        @keybind(76, 'l')
        @keybind(77, 'm')
        @keybind(74, 'j')
        @keybind(73, 'i')
        @keybind(75, 'k')

    _assetPreload: ->
        load = (hash) =>
            for k,path of hash
                Debug.log "load image #{path}"
                @preload path

        load R.CHAR
        load R.BACKGROUND_IMAGE
        load R.UI
        load R.EFFECT
        load R.BULLET
        load R.ITEM
        load R.TIP

    onload: ->
        @scene = new RobotScene @
        @pushScene @scene
        super
        @assets["font0.png"] = @assets['resources/ui/font0.png']
        @assets["apad.png"] = @assets['resources/ui/apad.png']
        @assets["icon0.png"] = @assets['resources/ui/icon0.png']
        @assets["pad.png"] = @assets['resources/ui/pad.png']
        Game.instance.loadInstruction()
        putTestCode(Game.instance.scene.world.player)

window.onload = () ->
    game = new RobotGame Config.GAME_WIDTH, Config.GAME_HEIGHT
    game.start()




