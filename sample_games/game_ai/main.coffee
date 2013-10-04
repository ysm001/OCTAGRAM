
R = Config.R

Random = new MersenneTwister()

class ViewGroup extends Group
  constructor: (x, y, scene) ->
    super
    scene.addChild @
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
    @map.update()

class RobotWorld extends GroupModel
  constructor: (x, y, scene) ->
    super()
    @_robots = []
    @setup("bullets", [])
    @setup("items", [])

    player = new PlayerRobot @
    plate = Map.instance.getPlate(6,4)
    player.moveToPlate(plate)

    enemy = new EnemyRobot @
    plate = Map.instance.getPlate(1,1)
    enemy.moveToPlate(plate)

    Game.instance.addInstruction(new RandomMoveInstruction(player))
    Game.instance.addInstruction(new MoveInstruction(player))
    Game.instance.addInstruction(new ShotInstruction(player))
    Game.instance.addInstruction(new PickupInstruction(player))
    Game.instance.addInstruction(new ItemScanMoveInstruction(player, enemy))
    Game.instance.addInstruction(new TurnEnemyScanInstruction(player, enemy))
    Game.instance.addInstruction(new EnemyScanInstructon(player, enemy))
    Game.instance.addInstruction(new HpBranchInstruction(player))
    Game.instance.addInstruction(new HoldBulletBranchInstruction(player))
    @_robots.push player
    @_robots.push enemy
    scene.addChild @
    @addChild player
    @addChild enemy

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
    for robot in @_robots
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
    i.update() for i in @_robots

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
    @keybind(80, 'p')

    @keybind(76, 'l')
    @keybind(77, 'm')
    @keybind(78, 'n')
    @keybind(74, 'j')
    @keybind(73, 'i')
    @keybind(75, 'k')
    @keybind(79, 'o')

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

window.onload = () ->
  game = new RobotGame Config.GAME_WIDTH, Config.GAME_HEIGHT
  game.start()




