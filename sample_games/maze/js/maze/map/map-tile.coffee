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
    target = null
    for e in @elementData
      e.onride(player)
      target = e if e.enabled == false
    
    if target
      @elementData.some (v, i) =>
        @elementData.splice(i, 1) if v == target

  check: (player) ->
    target = null
    for e in @elementData
      e.check(player)
      target = e if e.enabled == false
    
    if target
      @elementData.some (v, i) =>
        @elementData.splice(i, 1) if v == target

  isThrough: () -> @elementData.every (e) -> e.isThrough

