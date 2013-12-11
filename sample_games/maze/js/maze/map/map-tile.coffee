class MapTile extends Group
  @WIDTH  : 48
  @HEIGHT : 48

  class TileSprite extends Sprite
    constructor: () ->
      super MapTile.WIDTH, MapTile.HEIGHT
      @image = Game.instance.assets[R.MAP.SRC]

  constructor: (x, y) ->
    super
    @tile = new TileSprite
    @addChild @tile
    @elementData = []
    @index =
      x: x
      y: y
    @x = MapTile.WIDTH * x
    @y = MapTile.HEIGHT * y

  pushElement: (element) ->
    @elementData.push(element)
    @addChild(element)

  onride: (player) ->
    e.onride(player) for e in @elementData

  isThrough: () -> @elementData.every (e) -> e.isThrough()

