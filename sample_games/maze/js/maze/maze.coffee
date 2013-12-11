class Maze extends Group
  constructor: (data) ->
    super
    @x = if data.x? then data.x else 0
    @y = if data.y? then data.y else 0
    if !data.map?
      data.map = map
    @mazeMap = new MazeMap data.map
    @addChild @mazeMap
    @player = new RobotPlayer(@mazeMap)
    @addChild @player

class GoalMaze extends Maze

  constructor: (data) ->
    super data
    @player.addEventListener 'goal', (evt) ->
      @dispatchEvent(new MazeEvent("complete"))
      console.log "goal"

class DefeatMaze extends Maze

  constructor: (data) ->
    super data
    @count = 0
    @player.addEventListener 'kill', (evt) =>
      @count += 1
      if data.count <= @count
        @dispatchEvent(new MazeEvent("complete"))
        console.log "all defeat"


