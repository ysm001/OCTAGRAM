

class Item extends Sprite
  @WIDTH  : 48
  @HEIGHT : 48

  constructor: (@name = "item") ->
    super Item.WIDTH, Item.HEIGHT


class Key extends Item
  constructor: () ->
    super("key")
    @image = Game.instance.assets[R.CHAR.CHAR1]


