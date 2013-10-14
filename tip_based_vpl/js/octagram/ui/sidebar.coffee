class SideTipSelector extends EntityGroup
  VISIBLE_TIP_COUNT = 8

  constructor: (x, y) ->
    super(160, 500)

    @moveTo(x, y)
    @scrollPosition = 0


    # create background
    background = new ImageSprite(Resources.get('sidebar'))
    @addChild(background)


    tipHeight = Resources.get("emptyTip").height

    # create top arrow
    @topArrow = new UIButton(Resources.get('arrow'))
    @topArrow.rotate(-90)
    @topArrow.moveTo((@width - @topArrow.width) / 2, 0)
    @topArrow.on(Event.TOUCH_START, =>
      return if @scrollPosition <= 0
      @scrollPosition -= 1
      @tipGroup.moveBy(0, tipHeight)
      @_updateVisibility()
    )
    @addChild(@topArrow)


    # create bottom arrow
    @bottomArrow = new UIButton(Resources.get('arrow'))
    @bottomArrow.rotate(90)
    @bottomArrow.moveTo((@width - @bottomArrow.width)/2, @height - @bottomArrow.height)
    @bottomArrow.on(Event.TOUCH_START, =>
      return if @scrollPosition > @_getTipCount() - VISIBLE_TIP_COUNT - 1
      @scrollPosition += 1
      @tipGroup.moveBy(0, -tipHeight)
      @_updateVisibility()
    )
    @addChild(@bottomArrow)


    # create tip group
    @createTipGroup()
    @addChild(@tipGroup)

  createTipGroup: () ->
    @tipGroup = new EntityGroup(64, 0)
    @tipGroup.backgroundColor = '#ff0000'
    @tipGroup.moveTo(@topArrow.x, @topArrow.y + @topArrow.height)


  addTip: (tip) ->
    tipCount = @_getTipCount()

    uiTip = tip.clone()
    uiTip.setVisible(false) if tipCount >= VISIBLE_TIP_COUNT
    uiTip.moveTo(8, -6 + tipCount * tip.getHeight())
    uiTip.addEventListener('touchstart', uiTip.onTouchStart)
    uiTip.addEventListener('touchmove', uiTip.onTouchMove)
    uiTip.addEventListener('touchend', uiTip.onTouchEnd)

    @tipGroup.addChild(uiTip)


  _getTipCount: ->
    @tipGroup.childNodes.length


  _updateVisibility: ->
    update = (index, flag) =>
      @tipGroup.childNodes[index].setVisible(flag) if 0 <= index < @_getTipCount()

    # hide outside
    update(@scrollPosition - 1, false)
    update(@scrollPosition + VISIBLE_TIP_COUNT, false)

    # show inside
    update(@scrollPosition, true)
    update(@scrollPosition + VISIBLE_TIP_COUNT - 1, true)

  clearTip: () ->
    @removeChild(@tipGroup)
    @createTipGroup()
    @addChild(@tipGroup)

    @scrollPosition = 0
