class Maze extends Group
  constructor: (data) ->
    super
    @x = if data.x? then data.x else 0
    @y = if data.y? then data.y else 0
    if !data.map?
      data.map = map
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


