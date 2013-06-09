class SideSelectorArrow extends GroupedSprite
  constructor : (@parent) ->
    image = Resources.get("arrow")
    super(image.width, image.height)
    @image = image

class SideTipSelector extends SpriteGroup
  constructor : (x, y, @parent) -> 
    super(Resources.get("sidebar"))
   
    @tipGroup = new Group()

    @moveTo(x, y)
    @padding = 56 
    @capacity = 8 
    @scrollPosition = 0

    @topArrow = new SideSelectorArrow() 
    @bottomArrow = new SideSelectorArrow() 
    @topArrow.rotate(-90)
    @bottomArrow.rotate(90)

    @topArrow.moveTo(@sprite.width/2 - @topArrow.width/2, 0)
    @bottomArrow.moveTo(@sprite.width/2 - @bottomArrow.width/2, 
      @sprite.height - @bottomArrow.height)

    @addChild(@sprite)
    @addChild(@tipGroup)
    @addChild(@topArrow)
    @addChild(@bottomArrow)

    @topArrow.addEventListener('touchstart', () => @scrollDown())
    @bottomArrow.addEventListener('touchstart', () => @scrollUp())

  addTip : (tip) -> 
    uiTip = tip.clone()
    uiTip.moveTo(@padding, @padding + @getTipNum() * tip.getHeight())
    uiTip.setVisible(false)

    @tipGroup.addChild(uiTip)
    @updateVisibility()

  hideOuter : (tip) ->
    opacity = if @isOut(tip) then 0 else 1
    tip.opacity = opacity 
    tip.icon.opacity = opacity if tip.icon? 

  updateVisibility : () ->
    for tip, i in @tipGroup.childNodes
      tip.setVisible(!@isOuterIndex(i))

  isOuterIndex : (index) ->
    index < @scrollPosition || index >= (@capacity + @scrollPosition)

  getTipNum : () -> @tipGroup.childNodes.length

  isUpScrollable : () -> 
    rest = @getTipNum() - @scrollPosition
    rest > @capacity

  isDownScrollable : () -> @scrollPosition > 0

  scrollUp : () ->
    if @isUpScrollable()
      @scrollPosition += 1
      @tipGroup.moveBy(0, -Resources.get("emptyTip").height)
      @updateVisibility()

  scrollDown : () ->
    if @isDownScrollable()
      @scrollPosition -= 1
      @tipGroup.moveBy(0, Resources.get("emptyTip").height)
      @updateVisibility()


