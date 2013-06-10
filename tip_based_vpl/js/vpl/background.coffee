class TipBackground extends Group
  constructor : (x, y, xnum, ynum) ->
    super()
    border     = Resources.get("mapBorder")
    background = Resources.get("mapTip")
    tip        = Resources.get("emptyTip")
    margin     = (background.width - 1 - tip.width) / 2
    space      = margin*2 + tip.width
    width  = background.width
    height = background.height

    x += border.height
    y += border.height

    for i in [-1...xnum+1]
      for j in [-1...ynum+1]
        map = new Sprite(width, height)         
        map.image = background
        map.moveTo(x+j*space, y+i*space)
        @addChild(map)
