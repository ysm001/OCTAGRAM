#####################################################
# Icon 
#####################################################
class Icon extends Sprite
  constructor : (icon, width, height) ->
    w = if width? then width else icon.width
    h = if height? then height else icon.height
    super(w, h)

    @image = icon
    @parent = null
    @hidden = true

    @touchEnabled = false

  fitPosition : () ->
    if @parentNode?
      @moveTo(@parentNode.getWidth()/2 - @width/2, 
        @parentNode.getWidth()/2 - @height/2)

  clone : () -> 
    obj = new Icon(@image, @width, @height)
    obj.frame = @frame 
    obj
