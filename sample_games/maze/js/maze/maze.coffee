class Maze extends Group
  constructor: (data) ->
    super
    @x = if data.x? then data.x else 0
    @y = if data.y? then data.y else 0
    if !data.map?
      data.map = map
    @background = new Background
    @addChild @background
    @mazeMap = new MazeMap data.map
    @addChild @mazeMap

  createPlayer: () -> new RobotPlayer(@mazeMap)

  setPlayer: (@player) ->
    @player.initPosition(@mazeMap, @mazeMap.startTile)
    @addChild @player

class GoalMaze extends Maze

  constructor: (data) ->
    super data

  setPlayer: (player) ->
    super player
    @player.addEventListener 'goal', (evt) =>
      @dispatchEvent(new MazeEvent("complete"))
      console.log "goal"

class DefeatMaze extends Maze

  constructor: (data) ->
    super data

  setPlayer: (player) ->
    super player
    @count = 0
    @player.addEventListener 'kill', (evt) =>
      @count += 1
      if data.count <= @count
        @dispatchEvent(new MazeEvent("complete"))
        console.log "all defeat"

class Background extends Group

  class BackgroundColor extends Sprite
    @WIDTH  : 640
    @HEIGHT : 640
    constructor: ()->
      super BackgroundColor.WIDTH, BackgroundColor.HEIGHT
      @image = Game.instance.assets[R.MAP.BACKGROUND1]

  class BackgroundTransparent extends Sprite
    @WIDTH  : 640
    @HEIGHT : 640
    constructor: ()->
      super BackgroundTransparent.WIDTH, BackgroundTransparent.HEIGHT
      @image = Game.instance.assets[R.MAP.BACKGROUND_TRANSPARENT]

  class BackgroundEffect extends Sprite
    @WIDTH  : 1280
    @HEIGHT : 640
    constructor: ()->
      super BackgroundEffect.WIDTH, BackgroundEffect.HEIGHT
      @image = Game.instance.assets[R.MAP.BACKGROUND_EFFECT]
      @reset()
    
    reset: () ->
      @x = BackgroundEffect.WIDTH
    
    onenterframe: () ->
      @x -= 20
      if @age % 120 == 0
        @reset()

  constructor: (data = {}) ->
    super
    @x = if data.x? then data.x else 0
    @y = if data.y? then data.y else 0
    backgroundColor = new BackgroundColor
    backgroundTransparent = new BackgroundTransparent
    @addChild backgroundColor
    @addChild backgroundTransparent
    @addChild new BackgroundEffect()
