R = Config.R

class MazeWorld extends Group
  constructor: () ->
    super
    maze = MazeDefine.get(window.location.hash)
    @maze = new GoalMaze {x:0, y:0, map:maze.map}
    @addChild @maze
    @player = @maze.createPlayer()
    @player.direction = maze.direction
    @maze.setPlayer(@player)
    @maze.addEventListener 'complete', () =>
      @octagram.getInstance(@playerProgramId).stop()
      @dispatchEvent(new MazeEvent('gameend'))

  initInstructions: (@octagram) ->
    playerProgram = @octagram.createProgramInstance()
    @playerProgramId = playerProgram.id
    playerProgram.addEventListener 'onstart', () =>

    # dummy
    enemyProgram = @octagram.createProgramInstance()
    @enemyProgramId = enemyProgram.id

    playerProgram.addInstruction(new StraightMoveInstruction(@maze.player))
    playerProgram.addInstruction(new TurnInstruction(@maze.player))
    playerProgram.addInstruction(new CheckMapInstruction(@maze.player))
    @octagram.showProgram(@playerProgramId)

  reloadNewMap: (hash) ->
    @removeChild @maze
    maze = MazeDefine.get(hash)
    @player.direction = maze.direction
    @maze = new GoalMaze {x:0, y:0, map:maze.map}
    @addChild @maze
    @maze.setPlayer(@player)
    @maze.addEventListener 'complete', () =>
      @octagram.getInstance(@playerProgramId).stop()
      @dispatchEvent(new MazeEvent('gameend'))
    
  initInstructions: (@octagram) ->
    playerProgram = @octagram.createProgramInstance()
    @playerProgramId = playerProgram.id
    playerProgram.addEventListener 'onstart', () =>

    # dummy
    enemyProgram = @octagram.createProgramInstance()
    @enemyProgramId = enemyProgram.id

    playerProgram.addInstruction(new StraightMoveInstruction(@maze.player))
    playerProgram.addInstruction(new TurnInstruction(@maze.player))
    playerProgram.addInstruction(new CheckMapInstruction(@maze.player))
    @octagram.showProgram(@playerProgramId)

class MazeScene extends Scene
  constructor: (@game) ->
    super
    @world = new MazeWorld
    @addChild @world

  onenterframe: ->
    @update()

  restart: () =>
    @world.reloadNewMap(window.location.hash)

  update: ->

class MazeGame extends Core
  constructor: (width, height, @options) ->
    super width, height
    @_assetPreload()

  _assetPreload: ->
    load = (hash) =>
      for k,path of hash
        #Debug.log "load image #{path}"
        @preload path

    load R.MAP
    load R.CHAR
    load R.TIP
    load R.EFFECT

  onload: ->
    @scene = new MazeScene @
    @pushScene @scene
    @octagram = new Octagram(Config.OCTAGRAM_DIR)
    @octagram.onload = () =>
      @scene.world.initInstructions(@octagram)
      if @options and @options.onload then @options.onload()
      @scene.world.addEventListener "gameend", (evt) =>
        tipCount = @octagram.getTipCount(@scene.world.playerProgramId)
        if @options and @options.onend then @options.onend(evt.params || tipCount)

    @assets["font0.png"] = @assets['resources/ui/font0.png']
    @assets["apad.png"] = @assets['resources/ui/apad.png']
    @assets["icon0.png"] = @assets['resources/ui/icon0.png']
    @assets["pad.png"] = @assets['resources/ui/pad.png']

    window.addEventListener "hashchange", () =>
      @scene.world.reloadNewMap(window.location.hash)

runGame = (options) ->
  game = new MazeGame Config.GAME_WIDTH, Config.GAME_HEIGHT, options
  game.start()



class Timer extends Sprite
  constructor: (@startFrame=0, @limit=null) ->
    super

  getProgress: (g)->
    progress = parseInt(g.frame/g.fps)
    console.log progress, g.frame, g.fps
    progress
  
  getTime: (g)->
    time = if @limit? then @limit - @getProgress(g) else @getProgress(g)

  onenterframe: ->
    time = @getTime(Game.instance)
    console.log @getTimeLabel(time)
    if time <= 0 then @timeUp()

  timeUp: () ->
    # タイムアップ時の処理

  getTimeLabel: (time)->
    "リミット : " + time

