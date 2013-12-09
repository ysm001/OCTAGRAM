class Maze extends Group
  constructor: (x = 0, y = 0) ->
    super
    @x = x
    @y = y
    map = [
      [  4,  4,  4,  4,  4, 13,  4],
      [  4,  0,  4,  0,  0,  0,  4],
      [  4,  0,  4,  0,  4,  4,  4],
      [  4,  0,  4,  0,  4,  0,  4],
      [  4,  0,  0,  0,  4,  0,  4],
      [  4,  0,  4,  0,  0,  0,  4],
      [  4, 14,  4,  4,  4,  4,  4],
    ]
    @mazeMap = new MazeMap map
    @addChild @mazeMap
    @player = new RobotPlayer(@mazeMap)
    @addChild @player
    @player.addEventListener 'move', (evt) ->
      console.log evt
