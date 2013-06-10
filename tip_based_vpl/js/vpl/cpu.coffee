#####################################################
# CPU 
#####################################################
class Cpu extends Group
  constructor : (x, y, @xnum, @ynum, startIdx) ->
    super(Resources.get("dummy"))
    @tipTable = []
    @sx = startIdx
    @sy = -1

    @createTips(x, y)

  putTip : (sx, sy, dir, newTip) ->
    dx = sx + dir.x
    dy = sy + dir.y

    if @replaceTip(newTip, sx, sy)
      newTip.setNext(dx, dy, @getTip(dx, dy)) 

  putBranchTip : (sx, sy, conseqDir, alterDir, newTip) ->
    cdx = sx + conseqDir.x
    cdy = sy + conseqDir.y
    adx = sx + alterDir.x
    ady = sy + alterDir.y

    if @replaceTip(newTip, sx, sy)
      newTip.setConseq(cdx, cdy, @getTip(cdx, cdy))
      newTip.setAlter(adx, ady, @getTip(adx, ady))

  putSingleTip : (sx, sy, newTip) -> @replaceTip(newTip, sx, sy)

  replaceTip : (newTip, xidx, yidx) ->
    if !@getTip(xidx, yidx).immutable
      oldTip = @getTip(xidx, yidx) 
      selected = oldTip.isSelected()
      oldTip.hide(this)

      newTip.moveTo(oldTip.x, oldTip.y)
      newTip.setIndex(xidx, yidx)
      newTip.show(this)
      if selected then newTip.select()

      @setTip(xidx, yidx, newTip)
      true
    else false

  addTip : (sx, sy, dir, newTip) -> 
    @replaceTip(newTip, sx + dir.x, sy + dir.y)

  putStartTip : (x, y) ->
    start = new SingleTransitionCodeTip(new StartTip)
    returnTip = TipFactory.createReturnTip(@sx, @sy) 
    dir = Direction.down
    @putTip(x, y, dir, start)
    @replaceTip(returnTip, @sx + dir.x, @sy + dir.y)

  createTips : (x, y) ->
    tip    = Resources.get("emptyTip")
    maptip = Resources.get("mapTip")
    width  = tip.width
    height = tip.height
    margin = (maptip.width - 1 - tip.width) / 2
    space = margin*2 + width

    for i in [-1...@ynum+1]
      @tipTable[i] = []
      for j in [-1...@xnum+1]
        tip = 
          if @isWall(j, i) then TipFactory.createWallTip(@sx, @sy)
          else TipFactory.createEmptyTip() 

        tip.moveTo(x+margin+j*space, y+margin+i*space)

        tip.setIndex(j, i)
        tip.show(this) 
        @tipTable[i][j] = tip

    @putStartTip(@sx, @sy)

  insertNewTip : (x, y, tip) ->
    newTip = tip.clone() 
    if newTip instanceof JumpTransitionCodeTip
      @putSingleTip(x, y, newTip)
    else if newTip.setNext? 
      dir = tip.getNextDir()
      dir = if dir? then dir else Direction.down
      @putTip(x, y, dir, newTip)
    else if newTip.setConseq?
      conseqDir = tip.getConseqDir()
      alterDir = tip.getAlterDir()
      conseqDir = if conseqDir? then conseqDir else Direction.down
      alterDir = if alterDir? then alterDir else Direction.right
      @putBranchTip(x, y, conseqDir, alterDir, newTip)
    else
      @putSingleTip(x, y, newTip)

  getNearestIndex : (x, y) ->
    minDist = 0xffffffff
    minX = -1
    minY = -1
    for i in [-1...@ynum+1]
      for j in [-1...@xnum+1]
        tmp = @getTip(j, i)
        dx = tmp.x - x
        dy = tmp.y - y
        dist = dx*dx + dy*dy
        if dist < minDist
          minDist = dist
          minX = j
          minY = i
    {x: minX, y: minY}

  insertTipOnNearestPosition : (x, y, tip) ->
    nearest = @getNearestIndex(x, y)
    @insertNewTip(nearest.x, nearest.y, tip)

  getTip : (x, y) -> @tipTable[y][x]
  setTip : (x, y, tip) -> @tipTable[y][x] = tip
  getStartTip : () -> @getTip(@sx, @sy)
  getStartPosition : () -> {x: @sx, y: @sy}
  getYnum : () -> @ynum
  getXnum : () -> @xnum

  isOuter : (x, y) -> (y == -1 || x == -1 || y == @ynum || x == @xnum)
  isStart : (x, y) -> (x == @sx && y == @sy)
  isWall  : (x, y) -> @isOuter(x, y) && !@isStart(x, y)
  isEmpty : (x, y) -> @getTip(x, y).code instanceof EmptyTip


