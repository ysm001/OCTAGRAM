var Bullet, BulletFactory, BulletGroup, BulletType, DualBullet, DualBulletPart, NormalBullet, SpritePool, WideBullet, WideBulletPart,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SpritePool = (function() {
  function SpritePool(createFunc, maxAllocSize, maxPoolSize) {
    this.createFunc = createFunc;
    this.maxAllocSize = maxAllocSize;
    this.maxPoolSize = maxPoolSize;
    this.sprites = [];
    this.count = 0;
    this.freeCallback = null;
  }

  SpritePool.prototype.setDestructor = function(destructor) {
    this.destructor = destructor;
  };

  SpritePool.prototype.alloc = function() {
    var sprite;
    if (this.count > this.maxAllocSize) {
      return null;
    }
    if (this.sprites.length === 0) {
      sprite = this.createFunc();
    } else {
      sprite = this.sprites.pop();
    }
    this.count++;
    return sprite;
  };

  SpritePool.prototype.free = function(sprite) {
    if (this.sprites.length < this.maxPoolSize) {
      this.sprites[this.sprites.length] = sprite;
    }
    this.count--;
    if (this.destructor != null) {
      return this.destructor(sprite);
    }
  };

  return SpritePool;

})();

BulletFactory = (function() {
  function BulletFactory() {}

  BulletFactory.create = function(type, robot) {
    var bullet;
    bullet = null;
    switch (type) {
      case BulletType.NORMAL:
        bullet = new NormalBullet();
        break;
      case BulletType.WIDE:
        bullet = new WideBullet();
        break;
      case BulletType.DUAL:
        bullet = new DualBullet();
        break;
      default:
        return false;
    }
    bullet.holder = robot;
    return bullet;
  };

  return BulletFactory;

})();

BulletType = (function() {
  function BulletType() {}

  BulletType.NORMAL = 1;

  BulletType.WIDE = 2;

  BulletType.DUAL = 3;

  return BulletType;

})();

Bullet = (function(_super) {
  __extends(Bullet, _super);

  function Bullet(w, h, type, maxFrame) {
    this.type = type;
    this.maxFrame = maxFrame != null ? maxFrame : Config.Frame.BULLET;
    this.onDestroy = __bind(this.onDestroy, this);
    Bullet.__super__.constructor.call(this, w, h);
    this.rotate(90);
  }

  Bullet.prototype._getRotate = function(direct) {};

  Bullet.prototype.shot = function(x, y, direct) {
    this.x = x;
    this.y = y;
    this.direct = direct != null ? direct : Direct.RIGHT;
    return RobotWorld.instance.bullets.push(this);
  };

  Bullet.prototype.setOnDestoryEvent = function(event) {
    this.event = event;
  };

  Bullet.prototype.hit = function(robot) {
    var explosion;
    robot.damege();
    explosion = new Explosion(robot.x, robot.y);
    this.scene.addChild(explosion);
    return this.onDestroy();
  };

  Bullet.prototype.onDestroy = function() {
    if (this.animated) {
      if (this.event != null) {
        this.event(this);
      }
      this.animated = false;
      return this.parentNode.removeChild(this);
    }
  };

  Bullet.prototype.withinRange = function(offset, target, direct) {
    var i, point, rotate, _i, _ref;
    if (direct == null) {
      direct = Direct.RIGHT;
    }
    rotate = this._getRotate(direct);
    for (i = _i = 1, _ref = this.length; 1 <= _ref ? _i <= _ref : _i >= _ref; i = 1 <= _ref ? ++_i : --_i) {
      point = Util.toCartesianCoordinates(68 * i, Util.toRad(rotate));
      point.x = toi(point.x) + offset.x;
      point.y = toi(point.y) + offset.y;
      if (Util.lengthPointToPoint(point, target) <= 32) {
        return true;
      }
    }
    return false;
  };

  return Bullet;

})(Sprite);

/*
  grouping Bullet Class
  behave like Bullet Class
*/


BulletGroup = (function(_super) {
  __extends(BulletGroup, _super);

  function BulletGroup(type, maxFrame) {
    var _this = this;
    this.type = type;
    this.maxFrame = maxFrame;
    this.onDestroy = __bind(this.onDestroy, this);
    BulletGroup.__super__.constructor.apply(this, arguments);
    this.bullets = [];
    Object.defineProperty(this, "animated", {
      get: function() {
        var animated, i, _i, _len, _ref;
        animated = true;
        _ref = _this.bullets;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          i = _ref[_i];
          animated = animated && i.animated;
        }
        return animated;
      }
    });
    Object.defineProperty(this, "holder", {
      get: function() {
        return _this.bullets[0].holder;
      },
      set: function(robot) {
        var v, _i, _len, _ref, _results;
        _ref = _this.bullets;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          v = _ref[_i];
          _results.push(v.holder = robot);
        }
        return _results;
      }
    });
  }

  BulletGroup.prototype.shot = function(x, y, direct) {
    var i, _i, _len, _ref, _results;
    if (direct == null) {
      direct = Direct.RIGHT;
    }
    _ref = this.bullets;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      _results.push(i.shot(x, y, direct));
    }
    return _results;
  };

  BulletGroup.prototype.setOnDestoryEvent = function(event) {
    this.event = event;
  };

  BulletGroup.prototype.hit = function(robot) {
    var explosion;
    robot.damege();
    explosion = new Explosion(robot.x, robot.y);
    this.scene.addChild(explosion);
    return this.onDestroy();
  };

  BulletGroup.prototype.within = function(s, value) {
    var animated, i, _i, _len, _ref;
    _ref = this.bullets;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      animated = i.within(s, value);
      if (animated === true) {
        return true;
      }
    }
    return false;
  };

  BulletGroup.prototype.onDestroy = function() {
    var i, _i, _len, _ref, _results;
    if (this.animated === true) {
      if (this.event != null) {
        this.event(this);
      }
      _ref = this.bullets;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        i = _ref[_i];
        _results.push(i.onDestroy());
      }
      return _results;
    }
  };

  BulletGroup.prototype.withinRange = function(offset, target, direct) {
    var i, _i, _len, _ref;
    if (direct == null) {
      direct = Direct.RIGHT;
    }
    _ref = this.bullets;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      if (i.withinRange(offset, target, direct) === true) {
        return true;
      }
    }
    return false;
  };

  return BulletGroup;

})(Group);

/*
  straight forward 2 plates
*/


NormalBullet = (function(_super) {
  __extends(NormalBullet, _super);

  NormalBullet.WIDTH = 64;

  NormalBullet.HEIGHT = 64;

  function NormalBullet() {
    this.length = 4;
    NormalBullet.__super__.constructor.call(this, NormalBullet.WIDTH, NormalBullet.HEIGHT, BulletType.NORMAL);
    this.image = Game.instance.assets[R.BULLET.NORMAL];
  }

  NormalBullet.prototype._getRotate = function(direct) {
    var rotate;
    rotate = 0;
    if ((direct & Direct.LEFT) !== 0) {
      rotate += 180;
    }
    if ((direct & Direct.UP) !== 0) {
      if ((direct & Direct.LEFT) !== 0) {
        rotate += 60;
      } else {
        rotate -= 60;
      }
    } else if ((direct & Direct.DOWN) !== 0) {
      if ((direct & Direct.LEFT) !== 0) {
        rotate -= 60;
      } else {
        rotate += 60;
      }
    }
    return rotate;
  };

  NormalBullet.prototype.shot = function(x, y, direct) {
    var point, rotate;
    this.x = x;
    this.y = y;
    this.direct = direct != null ? direct : Direct.RIGHT;
    NormalBullet.__super__.shot.call(this, this.x, this.y, this.direct);
    this.animated = true;
    if (this._rorateDeg != null) {
      this.rotate(-this._rorateDeg);
    }
    rotate = this._getRotate(this.direct);
    this.rotate(rotate);
    this._rorateDeg = rotate;
    point = Util.toCartesianCoordinates(68 * this.length, Util.toRad(rotate));
    return this.tl.fadeOut(this.maxFrame).and().moveBy(toi(point.x), toi(point.y), this.maxFrame).then(function() {
      return this.onDestroy();
    });
  };

  return NormalBullet;

})(Bullet);

/*
  spread in 2 directions`
*/


WideBulletPart = (function(_super) {
  __extends(WideBulletPart, _super);

  WideBulletPart.WIDTH = 64;

  WideBulletPart.HEIGHT = 64;

  WideBulletPart.MAX_FRAME = 20;

  function WideBulletPart(parent, left) {
    this.parent = parent;
    this.left = left != null ? left : true;
    WideBulletPart.__super__.constructor.call(this, WideBulletPart.WIDTH, WideBulletPart.HEIGHT, BulletType.WIDE, WideBulletPart.MAX_FRAME);
    this.length = 2;
    this.image = Game.instance.assets[R.BULLET.WIDE];
    this.frame = 1;
  }

  WideBulletPart.prototype._getRotate = function(direct) {
    var rotate;
    rotate = 0;
    if ((direct & Direct.LEFT) !== 0) {
      rotate += 180;
    }
    if ((direct & Direct.UP) !== 0) {
      if ((direct & Direct.LEFT) !== 0) {
        rotate += 60;
      } else {
        rotate -= 60;
      }
    } else if ((direct & Direct.DOWN) !== 0) {
      if ((direct & Direct.LEFT) !== 0) {
        rotate -= 60;
      } else {
        rotate += 60;
      }
    }
    if (this.left === true) {
      rotate -= 60;
    } else {
      rotate += 60;
    }
    return rotate;
  };

  WideBulletPart.prototype.shot = function(x, y, direct) {
    var point, rotate;
    this.x = x;
    this.y = y;
    this.direct = direct != null ? direct : Direct.RIGHT;
    WideBulletPart.__super__.shot.call(this, this.x, this.y, this.direct);
    this.animated = true;
    if (this._rorateDeg != null) {
      this.rotate(-this._rorateDeg);
    }
    rotate = this._getRotate(this.direct);
    this.rotate(rotate);
    this._rorateDeg = rotate;
    point = Util.toCartesianCoordinates(68 * this.length, Util.toRad(rotate));
    return this.tl.fadeOut(this.maxFrame).and().moveBy(toi(point.x), toi(point.y), this.maxFrame).then(function() {
      return this.parent.onDestroy();
    });
  };

  return WideBulletPart;

})(Bullet);

WideBullet = (function(_super) {
  __extends(WideBullet, _super);

  function WideBullet() {
    var i, _i, _len, _ref;
    WideBullet.__super__.constructor.call(this, BulletType.WIDE, WideBulletPart.MAX_FRAME);
    this.bullets.push(new WideBulletPart(this, true));
    this.bullets.push(new WideBulletPart(this, false));
    _ref = this.bullets;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      this.addChild(i);
    }
  }

  return WideBullet;

})(BulletGroup);

DualBulletPart = (function(_super) {
  __extends(DualBulletPart, _super);

  DualBulletPart.WIDTH = 64;

  DualBulletPart.HEIGHT = 64;

  DualBulletPart.MAX_FRAME = 20;

  function DualBulletPart(parent, back) {
    this.parent = parent;
    this.back = back != null ? back : true;
    DualBulletPart.__super__.constructor.call(this, DualBulletPart.WIDTH, DualBulletPart.HEIGHT, BulletType.DUAL, DualBulletPart.MAX_FRAME);
    this.length = 2;
    this.image = Game.instance.assets[R.BULLET.DUAL];
    this.frame = 1;
  }

  DualBulletPart.prototype._getRotate = function(direct) {
    var rotate;
    rotate = 0;
    if ((this.direct & Direct.LEFT) !== 0) {
      rotate += 180;
    }
    if ((this.direct & Direct.UP) !== 0) {
      if ((this.direct & Direct.LEFT) !== 0) {
        rotate += 60;
      } else {
        rotate -= 60;
      }
    } else if ((this.direct & Direct.DOWN) !== 0) {
      if ((this.direct & Direct.LEFT) !== 0) {
        rotate -= 60;
      } else {
        rotate += 60;
      }
    }
    if (this.back === true) {
      rotate += 180;
    }
    return rotate;
  };

  DualBulletPart.prototype.shot = function(x, y, direct) {
    var point, rotate;
    this.x = x;
    this.y = y;
    this.direct = direct != null ? direct : Direct.RIGHT;
    DualBulletPart.__super__.shot.call(this, this.x, this.y, this.direct);
    this.animated = true;
    if (this._rorateDeg != null) {
      this.rotate(-this._rorateDeg);
    }
    rotate = this._getRotate(this.direct);
    this.rotate(rotate);
    this._rorateDeg = rotate;
    point = Util.toCartesianCoordinates(68 * this.length, Util.toRad(rotate));
    return this.tl.moveBy(toi(point.x), toi(point.y), this.maxFrame).then(function() {
      return this.parent.onDestroy();
    });
  };

  return DualBulletPart;

})(Bullet);

DualBullet = (function(_super) {
  __extends(DualBullet, _super);

  function DualBullet() {
    var i, _i, _len, _ref;
    DualBullet.__super__.constructor.call(this, BulletType.DUAL, DualBulletPart.MAX_FRAME);
    this.bullets.push(new DualBulletPart(this, true));
    this.bullets.push(new DualBulletPart(this, false));
    _ref = this.bullets;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      this.addChild(i);
    }
  }

  return DualBullet;

})(BulletGroup);
