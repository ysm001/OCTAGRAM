class SpriteGroup extends Group
  constructor : (image) -> 
    super()
    @sprite = new Sprite(image.width, image.height)
    @sprite.image = image

  getAbsolutePosition : () ->
    pos = {x: @x, y: @y}
    parent = @parentNode
    while parent? && !(parent instanceof Scene)
      pos.x += parent.x
      pos.y += parent.y
      parent = parent.parentNode
    pos

  setOpacity : (opacity) ->
    for child in @childNodes
      if child instanceof Sprite
        child.opacity = opacity
      else if child instanceof SpriteGroup
        child.setOpacity(opacity)

  setVisible : (visible) ->
    for child in @childNodes
      if child instanceof Sprite
        child.visible = visible
      else if child instanceof SpriteGroup
        child.setVisible(opacity)
    
  getWidth : () -> @sprite.width
  getHeight : () -> @sprite.height

class GroupedSprite extends Sprite
  getAbsolutePosition : () ->
    pos = {x: @x, y: @y}
    parent = @parentNode
    while parent? && !(parent instanceof Scene)
      pos.x += parent.x
      pos.y += parent.y
      parent = parent.parentNode
    pos

class ImageSprite extends Sprite 
  constructor : (image) ->
    super(image.width, image.height)
    @image = image


