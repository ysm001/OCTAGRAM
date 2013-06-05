class TipBackground 
  constructor : (x, y, xnum, ynum) ->
    border     = Resources.get("mapBorder")
    background = Resources.get("mapTip")
    tip        = Resources.get("emptyTip")
    margin     = (background.width - 1 - tip.width) / 2
    space      = margin*2 + tip.width

    x += border.height
    y += border.height

    for i in [-1...xnum+1]
      for j in [-1...ynum+1]
        image = background 
        map = new Sprite(image.width, image.height)         
        map.image = image 
        map.moveTo(x+j*space, y+i*space)

        LayerUtil.setOrder(map, Environment.layer.background)
        Game.instance.currentScene.addChild(map)
