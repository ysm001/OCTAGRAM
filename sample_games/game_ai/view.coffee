R = Config.R

class ViewGroup extends Group

  constructor: (x, y) ->
    super(x,y)
    @_childs = []

  addView: (view) ->
    @_childs.push(view)
    @addChild(view)

  initEvent: (world) ->
    view.initEvent(world) for view in @_childs

class ViewSprite extends Sprite

  constructor: (x, y) ->
    super(x,y)

  initEvent: (world) ->

class Background extends ViewSprite
  @SIZE = 640
  constructor: (x, y) ->
    super Background.SIZE, Background.SIZE
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.SPACE]
    @x = x
    @y = y

class HpBar extends Bar
  @HEIGHT = 24
  @MAX_VALUE = 256
  constructor: (x,y,resource=PlayerHp.YELLOW) ->
    super x, y
    @height = HpBar.HEIGHT
    @value = HpBar.MAX_VALUE
    @maxValue = HpBar.MAX_VALUE
    switch resource
      when PlayerHp.BLUE
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_BULE]
      when PlayerHp.YELLOW
        @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_YELLOW]

class HpEnclosePart extends ViewSprite
  @WIDTH = HpBar.MAX_VALUE / 4
  @HEIGHT = HpBar.HEIGHT
  constructor: (x, y, i) ->
    super HpEnclosePart.WIDTH, HpEnclosePart.HEIGHT
    @x = x
    @y = y
    if i == 0
      @frame = 0
    else if i == PlayerHp.MAX_HP - 1
      @frame = 2
    else
      @frame = 1
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_ENCLOSE]

class HpEnclose extends ViewGroup
  @WIDTH = HpBar.MAX_VALUE
  @HEIGHT = HpBar.HEIGHT
  constructor: (x, y) ->
    super HpEnclose.WIDTH, HpEnclose.HEIGHT
    @x = x
    @y = y
    for i in [0..3]
      @addChild new HpEnclosePart(i*HpEnclosePart.WIDTH ,0, i)

class HpView extends ViewGroup
  @YELLOW = 1
  @BLUE = 2
  @MAX_HP = 4
  constructor: (x,y, resource) ->
    super
    @hp = new HpBar x, y, resource
    @addChild @hp
    @underBar = new HpEnclose x, y
    @addChild @underBar

  reduce: () ->
    @hp.value -= @hp.maxValue / PlayerHp.MAX_HP if @hp.value > 0

class EnemyHp extends HpView
  constructor: (x, y) ->
    super(x, y, HpView.BLUE)

  initEvent: (world) ->
    # callback on the HP of enemy changed
    world.enemy.addObserver "hp", (hp) =>
      @reduce() if hp < world.enemy.hp

class PlayerHp extends HpView
  constructor: (x, y) ->
    super(x, y, HpView.YELLOW)

  initEvent: (world) ->
    # callback on the HP of player changed
    world.player.addObserver "hp", (hp) =>
      @reduce() if hp < player.enemy.hp

class Header extends ViewGroup
  @WIDTH = 600
  constructor: (x, y) ->
    super
    @x = x
    @y = y
    @addView(new PlayerHp(16, 0))
    @addView(new EnemyHp(Header.WIDTH/2 + 16, 0))

class Spot
  
  @TYPE_NORMAL_BULLET = 1
  @TYPE_WIDE_BULLET = 2
  @TYPE_DUAL_BULLET = 3
  @SIZE = 3

  constructor: (@type, point) ->
    switch @type
      when Spot.TYPE_NORMAL_BULLET
        @effect = new SpotNormalEffect(point.x, point.y + 5)
        @resultFunc = (robot, plate) ->
          robot.barrierMap[BulletType.NORMAL] = new NormalBarrierEffect()
          point = plate.getAbsolutePos()
          robot.parentNode.addChild new NormalEnpowerEffect(point.x, point.y)
          robot.onSetBarrier(BulletType.NORMAL)
      when Spot.TYPE_WIDE_BULLET
        @effect = new SpotWideEffect(point.x, point.y + 5)
        @resultFunc = (robot, plate) ->
          robot.barrierMap[BulletType.WIDE] = new WideBarrierEffect()
          point = plate.getAbsolutePos()
          robot.parentNode.addChild new WideEnpowerEffect(point.x, point.y)
          robot.onSetBarrier(BulletType.WIDE)
      when Spot.TYPE_DUAL_BULLET
        @effect = new SpotDualEffect(point.x, point.y + 5)
        @resultFunc = (robot, plate) ->
          robot.barrierMap[BulletType.DUAL] = new DualBarrierEffect()
          point = plate.getAbsolutePos()
          robot.parentNode.addChild new DualEnpowerEffect(point.x, point.y)
          robot.onSetBarrier(BulletType.DUAL)

  @createRandom: (point) ->
    type = Math.floor(Math.random() * (Spot.SIZE)) + 1
    return new Spot(type, poit)

  @getRandomType: () ->
    return Math.floor(Math.random() * (Spot.SIZE)) + 1

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

class Button extends ViewSprite
  @WIDTH = 120
  @HEIGHT = 50
  constructor: (x,y) ->
    super Button.WIDTH, Button.HEIGHT
    @x = x
    @y = y
  setOnClickEventListener: (listener) ->
    @on_click_event = listener
  ontouchstart: ->
    @on_click_event() if @on_click_event?
    @frame = 1

  ontouchend: ->
    @frame = 0

class NextButton extends Button
  constructor: (x,y) ->
    super x, y
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.NEXT_BUTTON]

class MsgWindow extends ViewSprite
  @WIDTH = 320
  @HEIGHT = 128
  constructor: (x,y) ->
    super MsgWindow.WIDTH, MsgWindow.HEIGHT
    @x = x
    @y = y
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.MSGBOX]

class MsgBox extends ViewGroup

  constructor: (x,y) ->
    super MsgWindow.WIDTH, MsgWindow.HEIGHT
    @x = x
    @y = y
    @window = new MsgWindow 0, 0
    @addChild @window
    @label = new Label
    @label.font = "16px 'Meiryo UI'"
    @label.color = '#FFF'
    @label.x = 10
    @label.y = 30
    @addChild @label
    @label.width = MsgWindow.WIDTH * 0.9

  initEvent: (world) ->
    world.player.addEventListener 'move', (evt) =>
      player = evt.target
      point = evt.params
      if point != false
        @print R.String.move(player.name, point.x+1, point.y+1)
      else
        @print R.String.CANNOTMOVE

    world.player.addEventListener 'shot', (evt) =>
      player = evt.target
      ret = evt.params
      if ret != false
        @print R.String.shot(player.name)
      else
        @print R.String.CANNOTSHOT

    world.player.addEventListener 'pickup', (evt) =>
      player = evt.target
      ret = evt.params
      if ret != false
        @print R.String.pickup(player.name)
      else
        @print R.String.CANNOTPICKUP

  print: (msg) ->
    @label.text = "#{msg}"

class StatusWindow extends ViewSprite
  @WIDTH = 160
  @HEIGHT = 128
  constructor: (x,y) ->
    super StatusWindow.WIDTH, StatusWindow.HEIGHT
    @x = x
    @y = y
    @image = Game.instance.assets[R.BACKGROUND_IMAGE.STATUS_BOX]

class RemainingBullet extends ViewSprite
  @SIZE = 24
  constructor: (x, y, frame) ->
    super RemainingBullet.SIZE, RemainingBullet.SIZE
    @x = x
    @y = y
    @frame = frame
    @image = Game.instance.assets[R.ITEM.STATUS_BULLET]

class RemainingBullets extends ViewGroup
  @HEIGHT = 30
  @WIDTH = 120

  constructor: (x, y, @type) ->
    super RemainingBullets.WIDTH, RemainingBullets.HEIGHT
    @x = x
    @y = y
    @size = 0
    @array = []
    for i in [0..4]
      b = new RemainingBullet(i * RemainingBullet.SIZE, 0, @type)
      @array.push b
      @addChild b

  increment: () ->
    if @size < 5
      @array[@size].frame = @type - 1
      @size++

  decrement: () ->
    if @size > 0
      @size--
      @array[@size].frame = @type

class StatusBarrier extends ViewSprite
  @SIZE = 24
  constructor: (x, y, @type) ->
    super StatusBarrier.SIZE, StatusBarrier.SIZE
    @x = x
    @y = y
    @frame = @type
    @image = Game.instance.assets[R.ITEM.STATUS_BARRIER]

  set: () ->
    @frame = @type - 1

  reset: () ->
    @frame = @type

class StatusBarrierGroup extends ViewGroup

  constructor : (x, y) ->
    super
    @normal  = new StatusBarrier(30, 0, 1)
    @wide    = new StatusBarrier(55, 0, 3)
    @dual    = new StatusBarrier(80, 0, 5)

    @addChild @normal
    @addChild @wide
    @addChild @dual

    document.addEventListener("setBarrier", @set)
    document.addEventListener("resetBarrier", @reset)

  set : (evt) =>
    switch evt.bulletType
      when BulletType.NORMAL
        @normal.set()
      when BulletType.WIDE
        @wide.set()
      when BulletType.DUAL
        @dual.set()

  reset : (evt) =>
    switch evt.bulletType
      when BulletType.NORMAL
        @normal.reset()
      when BulletType.WIDE
        @wide.reset()
      when BulletType.DUAL
        @dual.reset()

class RemainingBulletsGroup extends ViewGroup

  constructor : (x, y) ->
    super
    @normal = new RemainingBullets(30, 30, 1)
    @wide   = new RemainingBullets(30, 30 + RemainingBullet.SIZE, 3)
    @dual   = new RemainingBullets(30, 30 + RemainingBullet.SIZE * 2, 5)

    @addChild @normal
    @addChild @wide
    @addChild @dual

  initEvent: (world) ->
    world.player.addEventListener 'pickup', (evt) =>
      player = evt.target
      effect = new ShotEffect(player.x, player.y)
      @addChild effect
      switch evt.params.type
        when BulletType.NORMAL
          @normal.increment()
        when BulletType.WIDE
          @wide.increment()
        when BulletType.DUAL
          @dual.increment()

    world.player.addEventListener 'shot', (evt) =>
      switch evt.params.type
        when BulletType.NORMAL
          @normal.decrement()
        when BulletType.WIDE
          @wide.decrement()
        when BulletType.DUAL
          @dual.decrement()

class StatusBox extends ViewGroup

  constructor: (x,y) ->
    super StatusWindow.WIDTH, StatusWindow.HEIGHT
    @x = x
    @y = y
    
    @addView(new StatusBarrierGroup())
    @addView(new RemainingBulletsGroup())

class Footer extends ViewGroup
  constructor: (x,y) ->
    super
    @x = x
    @y = y
    @addView(new MsgBox(20, 0))
    @addView(new StatusBox(x+MsgWindow.WIDTH+32, 16))
