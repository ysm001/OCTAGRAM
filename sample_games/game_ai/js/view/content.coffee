R = Config.R

class Plate extends ViewSprite
  @HEIGHT = 74
  @WIDTH = 64
  @STATE_NORMAL = 0
  @STATE_PLAYER = 1
  @STATE_ENEMY = 2
  @STATE_SELECTED = 3
  
  constructor: (x, y, @ix, @iy) ->
    super Plate.WIDTH, Plate.HEIGHT
    @x = x
    @y = y
    @lock = false
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.PLATE]
    @spotEnabled = false
    @pravState = Plate.STATE_NORMAL

  setState: (state) ->
    @pravState = @frame
    @frame = state
    if state is Plate.STATE_PLAYER or state is Plate.STATE_ENEMY
      @lock = true
    else
      @lock = false

  setPrevState: () ->
    @setState(@prevState)

  getAbsolutePos: () ->
    i = @parentNode
    offsetX = offsetY = 0
    while i?
      offsetX += i.x
      offsetY += i.y
      i = i.parentNode

    new Point(@x + offsetX, @y + offsetY)

  setSpot: (type) ->
    if @spotEnabled is false
      @spotEnabled = true
      @spot = new Spot type, @
      @parentNode.addChild @spot.effect

  onRobotAway: (robot) ->
    @setState(Plate.STATE_NORMAL)
    #Debug.log "onRobotAway #{@lock}"

  onRobotRide: (robot) ->
    @setState(robot.plateState)
    # Debug.log "onRobotRide #{@lock}"
    if @spotEnabled is true
      @parentNode.removeChild @spot.effect
      @spot.resultFunc robot, @
      @spot = null
      @spotEnabled = false

class Map extends ViewGroup
  @WIDTH = 9
  @HEIGHT = 7
  @UNIT_HEIGHT = Plate.HEIGHT
  @UNIT_WIDTH = Plate.WIDTH

  constructor: (x, y)->
    if Map.instance?
      return Map.instance
    super
    Map.instance = @
    @plateMatrix = []
    offset = 64/4
    # backgrond images
    for ty in [0...Map.HEIGHT]
      list = []
      for tx in [0...Map.WIDTH]
        if ty % 2 == 0
          plate = new Plate(tx * Map.UNIT_WIDTH , (ty * Map.UNIT_HEIGHT) - ty * offset, tx, ty)
        else
          plate = new Plate((tx * Map.UNIT_WIDTH+Map.UNIT_HEIGHT/2), (ty * Map.UNIT_HEIGHT)- ty * offset, tx, ty)
        list.push plate
        @addChild plate
        rand = Math.floor(Math.random() * 20)
        switch rand
          when 0
            plate.setSpot(Spot.TYPE_NORMAL_BULLET)
          when 1
            plate.setSpot(Spot.TYPE_WIDE_BULLET)
          when 2
            plate.setSpot(Spot.TYPE_DUAL_BULLET)
      @plateMatrix.push list
    @x = x
    @y = y
    @width = Map.WIDTH * Map.UNIT_WIDTH
    @height = (Map.HEIGHT-1) * (Map.UNIT_HEIGHT - offset) + Map.UNIT_HEIGHT + 16

  getPlate: (x, y) ->
    return @plateMatrix[y][x]

  getPlateRandom: () ->
    return @plateMatrix[Math.floor(Math.random() * (Map.HEIGHT))][Math.floor(Math.random() * (Map.WIDTH))]

  eachPlate: (plate, direct=Direct.RIGHT, func) ->
    ret = plate
    i = 0
    while ret?
      func(ret, i)
      ret = @getTargetPoision(ret, direct)
      i++

  eachSurroundingPlate : (plate, func) ->
    Direct.each((direct) =>
      target = @getTargetPoision(plate, direct)
      if target?
        func(target, direct)
    )

  isExistObject: (plate, direct=Direct.RIGHT, lenght) ->
    ret = plate
    for i in [0...lenght]
      ret = @getTargetPoision(ret, direct)
      if ret == null
        break
      else if ret.lock == true
        return true
    return false

  getTargetPoision:(plate, direct=Direct.RIGHT) ->
    if direct == Direct.RIGHT
      if @plateMatrix[plate.iy].length > plate.ix + 1
        return @plateMatrix[plate.iy][plate.ix+1]
      else
        return null
    else if direct == Direct.LEFT
      if plate.ix > 0
        return @plateMatrix[plate.iy][plate.ix-1]
      else
        return null

    if (direct & Direct.RIGHT) != 0 and (direct & Direct.UP) != 0
      offset = if plate.iy % 2 == 0 then 0 else 1
      if offset + plate.ix < Map.WIDTH and plate.iy > 0
        return @plateMatrix[plate.iy-1][offset + plate.ix]
      else
        return null
    else if (direct & Direct.RIGHT) != 0 and (direct & Direct.DOWN) != 0
      offset = if plate.iy % 2 == 0 then 0 else 1
      if offset + plate.ix < Map.WIDTH and plate.iy+1 < Map.HEIGHT
        return @plateMatrix[plate.iy+1][offset + plate.ix]
      else
        return null
    else if (direct & Direct.LEFT) != 0 and (direct & Direct.UP) != 0
      offset = if plate.iy % 2 == 0 then -1 else 0
      if offset + plate.ix >= 0 and plate.iy > 0
        return @plateMatrix[plate.iy-1][offset + plate.ix]
      else
        return null
    else if (direct & Direct.LEFT) != 0 and (direct & Direct.DOWN) != 0
      offset = if plate.iy % 2 == 0 then -1 else 0
      if offset + plate.ix >= 0 and plate.iy+1 < Map.HEIGHT
        return @plateMatrix[plate.iy+1][offset + plate.ix]
      else
        return null
    
    return null

  update: () ->
    return

