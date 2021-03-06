
R = Config.R

Random = new MersenneTwister()

class ViewWorld extends Group
  constructor: (x, y, scene) ->
    super()
    scene.addChild @
    @x = x
    @y = y

    @background = new Background 0, 0
    @header = new Header 0, 0
    @map = new Map 16, 68
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

  reset: () ->
    @map.reset()

class RobotWorld extends GroupModel
  @TIME_LIMIT : 13 * 8

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

    @_player = new PlayerRobot @
    @_enemy = new EnemyRobot @

    @_robots.push @_player
    @_robots.push @_enemy
    scene.addChild @
    @addChild @_player
    @addChild @_enemy

    @diePlayer = false
    @_start = false

    @player.addEventListener "die", (evt) =>
      if @diePlayer == false
        @_start = false
        @diePlayer = @player
        @dispatchEvent(new RobotEvent('gameend', {lose:@player, win:@enemy, type:RobotAIGame.END.KILL}))

    @enemy.addEventListener "die", (evt) =>
      if @diePlayer == false
        @_start = false
        @diePlayer = @enemy
        @dispatchEvent(new RobotEvent('gameend', {win:@player, lose:@enemy, type:RobotAIGame.END.KILL}))

    @_timer = 0

  properties:
    player:
      get:() -> @_player
    enemy:
      get:() -> @_enemy
    robots:
      get:() -> @_robots
    timer:
      get: () -> @_timer

  initInstructions: (@octagram) ->
    playerProgram = @octagram.createProgramInstance()
    enemyProgram = @octagram.createProgramInstance()
    @playerProgramId = playerProgram.id
    @enemyProgramId  = enemyProgram.id

    playerProgram.addEventListener 'onstart', () =>
      @_start = true
      @_timer = 0
    playerProgram.addInstruction(new MoveInstruction(@_player))
    playerProgram.addInstruction(new RandomMoveInstruction(@_player))
    playerProgram.addInstruction(new ApproachInstruction(@_player, @_enemy))
    playerProgram.addInstruction(new LeaveInstruction(@_player, @_enemy))
    playerProgram.addInstruction(new ShotInstruction(@_player))
    playerProgram.addInstruction(new SupplyInstruction(@_player))
    playerProgram.addInstruction(new TurnEnemyScanInstruction(@_player, @_enemy))
    playerProgram.addInstruction(new HpBranchInstruction(@_player))
    playerProgram.addInstruction(new EnemyDistanceInstruction(@_player, @_enemy))
    playerProgram.addInstruction(new EnergyBranchInstruction(@_player))
    playerProgram.addInstruction(new EnemyEnergyBranchInstruction(@_enemy))
    playerProgram.addInstruction(new ResourceBranchInstruction(@_player))

    enemyProgram.addInstruction(new MoveInstruction(@_enemy))
    enemyProgram.addInstruction(new RandomMoveInstruction(@_enemy))
    enemyProgram.addInstruction(new ApproachInstruction(@_enemy, @_player))
    enemyProgram.addInstruction(new LeaveInstruction(@_enemy, @_player))
    enemyProgram.addInstruction(new ShotInstruction(@_enemy))
    enemyProgram.addInstruction(new SupplyInstruction(@_enemy))
    enemyProgram.addInstruction(new TurnEnemyScanInstruction(@_enemy, @_player))
    enemyProgram.addInstruction(new HpBranchInstruction(@_enemy))
    enemyProgram.addInstruction(new EnemyDistanceInstruction(@_enemy, @_player))
    enemyProgram.addInstruction(new EnergyBranchInstruction(@_enemy))
    enemyProgram.addInstruction(new EnemyEnergyBranchInstruction(@_player))
    enemyProgram.addInstruction(new ResourceBranchInstruction(@_enemy))

    @octagram.showProgram(@playerProgramId)

  initialize: (views)->
    plate = Map.instance.getPlate(1, 1)
    @player.moveImmediately(plate)

    plate = Map.instance.getPlate(7, 5)
    @enemy.moveImmediately(plate)

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

  _lose: () ->
    if @player.hp > @enemy.hp
      return @enemy
    else if @player.hp < @enemy.hp
      return @player
    else
      if @player.consumptionEnergy > @enemy.consumptionEnergy
        return @player
      else if @player.consumptionEnergy < @enemy.consumptionEnergy
        return @enemy
      else
        return @enemy

  _win: () ->
    if @player.hp > @enemy.hp
      return @player
    else if @player.hp < @enemy.hp
      return @enemy
    else
      if @player.consumptionEnergy > @enemy.consumptionEnergy
        return @enemy
      else if @player.consumptionEnergy < @enemy.consumptionEnergy
        return @player
      else
        return @player

  reset: () ->
    @enemy.reset(7, 5)
    @player.reset(1, 1)
    @diePlayer = false

  updateRobots: () ->
    i.update() for i in @_robots

  update: (views) ->
    if @_start and @age % Config.Frame.GAME_TIMER_CLOCK == 0
      @_timer += 1
      @dispatchEvent(new RobotEvent('ontimer'), {timer:@timer})
      if @timer >= RobotWorld.TIME_LIMIT and @diePlayer == false
        @diePlayer = @_lose()
        @_start = false
        @dispatchEvent(new RobotEvent('gameend', {win:@_win(), lose:@diePlayer, type:RobotAIGame.END.TIME_LIMIT}))

    @updateItems()
    @updateRobots()
    @updateBullets()

class RobotScene extends Scene
  constructor: (@game) ->
    super @
    @views = new ViewWorld Config.GAME_OFFSET_X, Config.GAME_OFFSET_Y, @
    @world = new RobotWorld Config.GAME_OFFSET_X, Config.GAME_OFFSET_Y, @
    __this = @
    @world.addEventListener 'gameend', (evt) ->
      #console.log "scene gameend"
      params = evt.params
      for id in [@enemyProgramId, @playerProgramId]
        prg = @octagram.getInstance(id)
        prg.stop()
      __this.dispatchEvent(new RobotEvent("gameend", params))

    @views.initEvent @world
    @world.initialize()

  onenterframe: ->
    @update()

  restart: () =>
    @views.reset()
    @world.reset()
    
  update: ->
    @world.update(@views)
    @views.update(@world)

class RobotGame extends Core
  constructor: (width, height, @options) ->
    super width, height
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
        #Debug.log "load image #{path}"
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

    @octagram = new Octagram(Config.OCTAGRAM_DIR)
    @octagram.onload = () =>
      @scene.world.initInstructions(@octagram)
      if @options and @options.onload then @options.onload()
      @scene.addEventListener "gameend", (evt) =>
        if @options and @options.onend then @options.onend(evt.params)

    @assets["font0.png"] = @assets['resources/ui/font0.png']
    @assets["apad.png"] = @assets['resources/ui/apad.png']
    @assets["icon0.png"] = @assets['resources/ui/icon0.png']
    @assets["pad.png"] = @assets['resources/ui/pad.png']

runGame = (options) ->
  game = new RobotGame Config.GAME_WIDTH, Config.GAME_HEIGHT, options
  game.start()
