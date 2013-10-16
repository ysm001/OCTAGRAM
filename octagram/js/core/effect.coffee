class TouchEffect extends ImageSprite
  constructor : () ->
    super(Resources.get("touchEffect"))
    @touchEnabled = false
    @scaleX = 0
    @scaleY = 0

  show : (parent, x, y, time) ->
    @moveTo(x, y)
    parent.addChild(@)
    @tl.scaleTo(1, time).and().fadeOut(time).then(() => parent.removeChild(@))

  @single : (parent, x, y, time) -> new TouchEffect().show(parent, x, y, time)
  @double : (parent, x, y, time) -> 
    @single(parent, x, y, time)
    console.log(time/4)
    f = () => @single(parent, x, y, time)
    setTimeout(f, 100)
