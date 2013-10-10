
R = Config.R

Random = new MersenneTwister()

class ViewWorld extends Group
  constructor: (x, y, scene) ->
    super()
    scene.addChild @
    @x = x
    @y = y

    @background = new Background 0, 0
    @header = new Header 16, 16
    @map = new Map 16, 48
    @footer = new Footer(25, @map.y + @map.height)

    @addChild @background
    @addChild @header
    @addChild @map
    @addChild @footer
  
  initEvent: (world) ->
    @footer.initEvent(world)
    @map.initEvent(world)
    @header.initEvent(world)

  update: (world) ->
    @map.update()

class RobotWorld extends GroupModel
  constructor: (x, y, scene) ->
    if RobotWorld.instance?
      return RobotWorld.instance
    super()
    RobotWorld.instance = @
    @_robots = []
    @setup("bullets", [])
    @setup("items", [])

    @addObserver "bullets", (data, method) =>
      if method == "push"
        @insertBefore(data, @_robots[0])

    @addObserver "items", (data, method) =>
      if method == "push"
        @addChild(data)

    player = new PlayerRobot @
    enemy = new EnemyRobot @

    Game.instance.addInstruction(new MoveInstruction(player))
    Game.instance.addInstruction(new RandomMoveInstruction(player))
    Game.instance.addInstruction(new ApproachInstruction(player, enemy))
    Game.instance.addInstruction(new LeaveInstruction(player, enemy))
    Game.instance.addInstruction(new ItemScanMoveInstruction(player, enemy))
    Game.instance.addInstruction(new ShotInstruction(player))
    Game.instance.addInstruction(new TurnEnemyScanInstruction(player, enemy))
    Game.instance.addInstruction(new HpBranchInstruction(player))
    Game.instance.addInstruction(new HoldBulletBranchInstruction(player))
    @_robots.push player
    @_robots.push enemy
    scene.addChild @

  properties:
    player:
      get:() -> @_robots[0]
    enemy:
      get:() -> @_robots[1]

  initialize: (views)->
    plate = Map.instance.getPlate(6,4)
    @player.moveDirect(plate)

    plate = Map.instance.getPlate(1,1)
    @enemy.moveDirect(plate)

  collisionBullet: (bullet, robot) ->
    return bullet.holder != robot and bullet.within(robot, 32)

  updateItems: () ->
    del = -1
    for v,i in @items
      if v.animated == false
        del = i
        @items[i] = false
    if del != -1
      @items.some (v, i) =>
        @items.splice(i, 1) if v == false
    

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
      @bullets.some (v, i) =>
        @bullets.splice(i, 1) if v == false

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
    @views = new ViewWorld Config.GAME_OFFSET_X, Config.GAME_OFFSET_Y, @
    @world = new RobotWorld Config.GAME_OFFSET_X, Config.GAME_OFFSET_Y, @
    @views.initEvent @world
    @world.initialize()

  onenterframe: ->
    @update()
    
  update: ->
    @world.update(@views)
    @views.update(@world)

class RobotGame extends TipBasedVPL
  constructor: (width, height) ->
    super width, height, "./js/tip_based_vpl/resource/"
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




