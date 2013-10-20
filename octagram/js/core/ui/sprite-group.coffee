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
      if child.setOpacity?
        child.setOpacity(opacity)
      else if child.opacity?
        child.opacity = opacity

  setVisible : (visible) ->
    for child in @childNodes
      if child.setVisible?
        child.setVisible(opacity)
      else if child.visible?
        child.visible = visible
    
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

octagram.SpriteGroup = SpriteGroup
octagram.GroupedSprite = GroupedSprite
