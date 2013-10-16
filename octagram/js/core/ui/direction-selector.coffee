class DirectionSelector extends Group
  constructor : (@transition, @range, type) ->
    super()

    @parent = @transition.parentNode

    key = if type == 'alter' then 'selectorAlter' else 'selector'
    @arrow = new UIButton(Resources.get(key))

    @arrow.ontouchmove = (e) =>
      @transition.onTouchMove(e)

      src = {
        x: @parent.x + @parent.getWidth() / 2,
        y: @parent.y + @parent.getHeight() / 2
      }
  
      theta = Vector.angle(src, e)
      @moveArrowByRotation(theta)

    @moveArrowByRotation(@transition.rotation)
    @addChild(@arrow)

  moveArrowByRotation : (theta) ->
    dir = Direction.create(theta)
    @moveArrow(dir)

    theta = Vector.angle({x:0,y:0}, dir)
    @rotateArrow(theta)


  moveArrow : (dir) ->
    rate = 1/Math.sqrt(dir.x * dir.x + dir.y * dir.y)
    @arrow.moveTo(@range * dir.x * rate - @arrow.width/2 + @parent.getWidth()/2, @range * dir.y * rate - @arrow.height/2 + @parent.getHeight()/2)

  rotateArrow : (theta) ->
    @arrow.rotation = theta+90

  show : () -> 
    @transition.touchEnabled = false
    @parent.addChild(@)

  hide : () -> @parent.removeChild(@)

  @createNormal : (transition) -> new DirectionSelector(transition, 50, 'normal')
  @createAlter : (transition) -> new DirectionSelector(transition, 50, 'alter')
