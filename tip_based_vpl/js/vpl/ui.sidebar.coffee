class SideTipSelector extends SpriteGroup
  constructor : (x, y, @parent) -> 
    super(Resources.get("sidebar"))
   
    @tipGroup = new Group()
    @padding = 56 
    @capacity = 8 
    @scrollPosition = 0

    @topArrow = new ImageSprite(Resources.get("arrow")) 
    @bottomArrow = new ImageSprite(Resources.get("arrow")) 
    @topArrow.rotate(-90)
    @bottomArrow.rotate(90)

    @moveTo(x, y)

    @topArrow.moveTo(@sprite.width/2 - @topArrow.width/2, 0)
    @bottomArrow.moveTo(@getWidth()/2 - @bottomArrow.width/2, 
      @getHeight() - @bottomArrow.height)

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

  updateVisibility : () ->
    for tip, i in @tipGroup.childNodes
      tip.setVisible(!@isOuterIndex(i))

  getTipNum : () -> @tipGroup.childNodes.length

  isUpScrollable : () -> 
    rest = @getTipNum() - @scrollPosition
    rest > @capacity

  isOuterIndex : (index) ->
    index < @scrollPosition || index >= (@capacity + @scrollPosition)

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


