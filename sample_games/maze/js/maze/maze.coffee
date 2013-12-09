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
    @player.addEventListener 'move', (evt) ->
      console.log evt
