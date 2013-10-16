class SpriteGroup extends Group
  constructor : (image) -> 
    super()
    if image
      @sprite = new Sprite(image.width, image.height)
      @sprite.image = image

  topGroup : () ->
    top = @
    while top.parentNode && !(top.parentNode instanceof Scene)
      top = top.parentNode

    top

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

  topGroup : () ->
    top = @
    while top.parentNode && !(top.parentNode instanceof Scene)
      top = top.parentNode

    top

class ImageSprite extends Sprite 
  constructor : (image, width, height) ->
    super(width || image.width, height || image.height)
    @image = image
