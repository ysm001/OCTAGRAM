#####################################################
# 遷移のCV 
#####################################################
class TipTransition extends GroupedSprite
  constructor : (image, @src, @dst) ->
    super(image.width, image.height)
    @image = image
    @link(@src, @dst) if @src && @dst
    @parent = null
    @touchEnabled = false

  link : (src, dst) ->
    pos = @calcPosition(src, dst)
    theta = @calcRotation(src, dst)
    @moveTo(pos.x, pos.y)
    @rotate(theta)

  calcPosition : (src, dst) ->
    dx = dst.x - src.x
    dy = dst.y - src.y
    x = dx/2 + @image.width/2
    y = dy/2 + @image.height/2
    {x:x, y:y}

  calcRotation : (src, dst) ->
    dx = dst.x - src.x
    dy = dst.y - src.y
    cos = dx / Math.sqrt(dx*dx + dy*dy)
      
    theta = Math.acos(cos) * 180 / Math.PI
    if dy < 0 then theta *= -1
    theta

  rotateToDirection : (theta) ->
    if       -22.5 < theta <=   22.5 then Direction.right
    else if   22.5 < theta <=   67.5 then Direction.rightDown
    else if   67.5 < theta <=  112.5 then Direction.down
    else if  112.5 < theta <=  157.5 then Direction.leftDown
    else if -157.5 < theta <= -112.5 then Direction.leftUp
    else if -112.5 < theta <=  -67.5 then Direction.up
    else if  -67.5 < theta <=  -22.5 then Direction.rightUp
    else if theta > 157.5 || theta <= -157.5 <= 22.5 then Direction.left

  onTouchMove : (e) ->
    @parent = @parent || @topGroup()
    tip = TipFactory.createEmptyTip()

    src = {
      x: @src.x + tip.getWidth() / 2,
      y: @src.y + tip.getHeight() / 2
    }

    theta  = @calcRotation(src, e)
    dir    = @rotateToDirection(theta)
    srcIdx = @src.getIndex()

    nx  = srcIdx.x + dir.x
    ny  = srcIdx.y + dir.y

    dst = @parent.cpu.getTip(nx, ny)

    if dst != @dst
      @dst = dst
      if @src.setConseq?
        if this instanceof AlterTransition
          @src.setAlter(nx, ny, dst)
        else 
          @src.setConseq(nx, ny, dst)
      else @src.setNext(nx, ny, dst)

  hide : (parent) -> @parentNode.removeChild(this)
  show : (parent) -> parent.addChild(this)

#####################################################
# 通常遷移のCV 
#####################################################
class NormalTransition extends TipTransition
  constructor : (src, dst) -> 
    super(Resources.get("transition"), src, dst)

#####################################################
# 分岐時遷移のCV 
#####################################################
class AlterTransition extends TipTransition
  constructor : (src, dst) -> 
    super(Resources.get("alterTransition"), src, dst)

octagram.TipTransition = TipTransition
octagram.NormalTransition = NormalTransition
octagram.AlterTransition = AlterTransition
