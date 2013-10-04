class Item extends Sprite

  constructor:(w, h) ->
    super w, h
    @animated = true
    RobotWorld.instance.items.push(@)

  onComplete: () =>
    @event(@) if @event?
    @animated = false
    @parentNode.removeChild @

  setOnCompleteEvent: (@event) ->


class NormalBulletItem extends Item
  @SIZE = 64
  FRAME = 40

  constructor:(x, y) ->
    super NormalBulletItem.SIZE, NormalBulletItem.SIZE
    @x = x
    @y = y-8
    @image = Game.instance.assets[R.ITEM.NORMAL_BULLET]
    @tl.fadeOut(FRAME).and().moveBy(0, -48, FRAME).then(() -> @onComplete())

class WideBulletItem extends Item
  @SIZE = 64
  FRAME = 40

  constructor:(x, y) ->
    super WideBulletItem.SIZE, WideBulletItem.SIZE
    @x = x
    @y = y-8
    @image = Game.instance.assets[R.ITEM.WIDE_BULLET]
    @tl.fadeOut(FRAME).and().moveBy(0, -48, FRAME).then(() -> @onComplete())
    
class DualBulletItem extends Item
  @SIZE = 64
  FRAME = 40

  constructor:(x, y) ->
    super DualBulletItem.SIZE, DualBulletItem.SIZE
    @x = x
    @y = y-8
    @image = Game.instance.assets[R.ITEM.DUAL_BULLET]
    @tl.fadeOut(FRAME).and().moveBy(0, -48, FRAME).then(() -> @onComplete())
    
