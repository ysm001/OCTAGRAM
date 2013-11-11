var DualBulletItem, Item, NormalBulletItem, WideBulletItem,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Item = (function(_super) {
  __extends(Item, _super);

  function Item(w, h) {
    this.onComplete = __bind(this.onComplete, this);
    Item.__super__.constructor.call(this, w, h);
    this.animated = true;
    RobotWorld.instance.items.push(this);
  }

  Item.prototype.onComplete = function() {
    if (this.event != null) {
      this.event(this);
    }
    this.animated = false;
    return this.parentNode.removeChild(this);
  };

  Item.prototype.setOnCompleteEvent = function(event) {
    this.event = event;
  };

  return Item;

})(Sprite);

NormalBulletItem = (function(_super) {
  var FRAME;

  __extends(NormalBulletItem, _super);

  NormalBulletItem.SIZE = 64;

  FRAME = 40;

  function NormalBulletItem(x, y) {
    NormalBulletItem.__super__.constructor.call(this, NormalBulletItem.SIZE, NormalBulletItem.SIZE);
    this.x = x;
    this.y = y - 8;
    this.image = Game.instance.assets[R.ITEM.NORMAL_BULLET];
    this.tl.fadeOut(FRAME).and().moveBy(0, -48, FRAME).then(function() {
      return this.onComplete();
    });
  }

  return NormalBulletItem;

})(Item);

WideBulletItem = (function(_super) {
  var FRAME;

  __extends(WideBulletItem, _super);

  WideBulletItem.SIZE = 64;

  FRAME = 40;

  function WideBulletItem(x, y) {
    WideBulletItem.__super__.constructor.call(this, WideBulletItem.SIZE, WideBulletItem.SIZE);
    this.x = x;
    this.y = y - 8;
    this.image = Game.instance.assets[R.ITEM.WIDE_BULLET];
    this.tl.fadeOut(FRAME).and().moveBy(0, -48, FRAME).then(function() {
      return this.onComplete();
    });
  }

  return WideBulletItem;

})(Item);

DualBulletItem = (function(_super) {
  var FRAME;

  __extends(DualBulletItem, _super);

  DualBulletItem.SIZE = 64;

  FRAME = 40;

  function DualBulletItem(x, y) {
    DualBulletItem.__super__.constructor.call(this, DualBulletItem.SIZE, DualBulletItem.SIZE);
    this.x = x;
    this.y = y - 8;
    this.image = Game.instance.assets[R.ITEM.DUAL_BULLET];
    this.tl.fadeOut(FRAME).and().moveBy(0, -48, FRAME).then(function() {
      return this.onComplete();
    });
  }

  return DualBulletItem;

})(Item);
