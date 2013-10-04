// Generated by CoffeeScript 1.6.3
var Background, Button, EnemyHp, Footer, Header, HpBar, HpEnclose, HpEnclosePart, HpView, Map, MsgBox, MsgWindow, NextButton, Plate, PlayerHp, R, RemainingBullet, RemainingBullets, RemainingBulletsGroup, Spot, StatusBarrier, StatusBarrierGroup, StatusBox, StatusWindow, ViewGroup, ViewSprite,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

R = Config.R;

ViewGroup = (function(_super) {
  __extends(ViewGroup, _super);

  function ViewGroup(x, y) {
    ViewGroup.__super__.constructor.call(this, x, y);
    this._childs = [];
  }

  ViewGroup.prototype.addView = function(view) {
    this._childs.push(view);
    return this.addChild(view);
  };

  ViewGroup.prototype.initEvent = function(world) {
    var view, _i, _len, _ref, _results;
    _ref = this._childs;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      view = _ref[_i];
      _results.push(view.initEvent(world));
    }
    return _results;
  };

  return ViewGroup;

})(Group);

ViewSprite = (function(_super) {
  __extends(ViewSprite, _super);

  function ViewSprite(x, y) {
    ViewSprite.__super__.constructor.call(this, x, y);
  }

  ViewSprite.prototype.initEvent = function(world) {};

  return ViewSprite;

})(Sprite);

Background = (function(_super) {
  __extends(Background, _super);

  Background.SIZE = 640;

  function Background(x, y) {
    Background.__super__.constructor.call(this, Background.SIZE, Background.SIZE);
    this.image = Game.instance.assets[R.BACKGROUND_IMAGE.SPACE];
    this.x = x;
    this.y = y;
  }

  return Background;

})(ViewSprite);

HpBar = (function(_super) {
  __extends(HpBar, _super);

  HpBar.HEIGHT = 24;

  HpBar.MAX_VALUE = 256;

  function HpBar(x, y, resource) {
    if (resource == null) {
      resource = PlayerHp.YELLOW;
    }
    HpBar.__super__.constructor.call(this, x, y);
    this.height = HpBar.HEIGHT;
    this.value = HpBar.MAX_VALUE;
    this.maxValue = HpBar.MAX_VALUE;
    switch (resource) {
      case PlayerHp.BLUE:
        this.image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_BULE];
        break;
      case PlayerHp.YELLOW:
        this.image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_YELLOW];
    }
  }

  return HpBar;

})(Bar);

HpEnclosePart = (function(_super) {
  __extends(HpEnclosePart, _super);

  HpEnclosePart.WIDTH = HpBar.MAX_VALUE / 4;

  HpEnclosePart.HEIGHT = HpBar.HEIGHT;

  function HpEnclosePart(x, y, i) {
    HpEnclosePart.__super__.constructor.call(this, HpEnclosePart.WIDTH, HpEnclosePart.HEIGHT);
    this.x = x;
    this.y = y;
    if (i === 0) {
      this.frame = 0;
    } else if (i === PlayerHp.MAX_HP - 1) {
      this.frame = 2;
    } else {
      this.frame = 1;
    }
    this.image = Game.instance.assets[R.BACKGROUND_IMAGE.HP_ENCLOSE];
  }

  return HpEnclosePart;

})(ViewSprite);

HpEnclose = (function(_super) {
  __extends(HpEnclose, _super);

  HpEnclose.WIDTH = HpBar.MAX_VALUE;

  HpEnclose.HEIGHT = HpBar.HEIGHT;

  function HpEnclose(x, y) {
    var i, _i;
    HpEnclose.__super__.constructor.call(this, HpEnclose.WIDTH, HpEnclose.HEIGHT);
    this.x = x;
    this.y = y;
    for (i = _i = 0; _i <= 3; i = ++_i) {
      this.addChild(new HpEnclosePart(i * HpEnclosePart.WIDTH, 0, i));
    }
  }

  return HpEnclose;

})(ViewGroup);

HpView = (function(_super) {
  __extends(HpView, _super);

  HpView.YELLOW = 1;

  HpView.BLUE = 2;

  HpView.MAX_HP = 4;

  function HpView(x, y, resource) {
    HpView.__super__.constructor.apply(this, arguments);
    this.hp = new HpBar(x, y, resource);
    this.addChild(this.hp);
    this.underBar = new HpEnclose(x, y);
    this.addChild(this.underBar);
  }

  HpView.prototype.reduce = function() {
    if (this.hp.value > 0) {
      return this.hp.value -= this.hp.maxValue / PlayerHp.MAX_HP;
    }
  };

  return HpView;

})(ViewGroup);

EnemyHp = (function(_super) {
  __extends(EnemyHp, _super);

  function EnemyHp(x, y) {
    EnemyHp.__super__.constructor.call(this, x, y, HpView.BLUE);
  }

  EnemyHp.prototype.initEvent = function(world) {
    var _this = this;
    return world.enemy.addObserver("hp", function(hp) {
      if (hp < world.enemy.hp) {
        return _this.reduce();
      }
    });
  };

  return EnemyHp;

})(HpView);

PlayerHp = (function(_super) {
  __extends(PlayerHp, _super);

  function PlayerHp(x, y) {
    PlayerHp.__super__.constructor.call(this, x, y, HpView.YELLOW);
  }

  PlayerHp.prototype.initEvent = function(world) {
    var _this = this;
    return world.player.addObserver("hp", function(hp) {
      if (hp < player.enemy.hp) {
        return _this.reduce();
      }
    });
  };

  return PlayerHp;

})(HpView);

Header = (function(_super) {
  __extends(Header, _super);

  Header.WIDTH = 600;

  function Header(x, y) {
    Header.__super__.constructor.apply(this, arguments);
    this.x = x;
    this.y = y;
    this.addView(new PlayerHp(16, 0));
    this.addView(new EnemyHp(Header.WIDTH / 2 + 16, 0));
  }

  return Header;

})(ViewGroup);

Spot = (function() {
  Spot.TYPE_NORMAL_BULLET = 1;

  Spot.TYPE_WIDE_BULLET = 2;

  Spot.TYPE_DUAL_BULLET = 3;

  Spot.SIZE = 3;

  function Spot(type, point) {
    this.type = type;
    switch (this.type) {
      case Spot.TYPE_NORMAL_BULLET:
        this.effect = new SpotNormalEffect(point.x, point.y + 5);
        this.resultFunc = function(robot, plate) {
          robot.barrierMap[BulletType.NORMAL] = new NormalBarrierEffect();
          point = plate.getAbsolutePos();
          robot.parentNode.addChild(new NormalEnpowerEffect(point.x, point.y));
          return robot.onSetBarrier(BulletType.NORMAL);
        };
        break;
      case Spot.TYPE_WIDE_BULLET:
        this.effect = new SpotWideEffect(point.x, point.y + 5);
        this.resultFunc = function(robot, plate) {
          robot.barrierMap[BulletType.WIDE] = new WideBarrierEffect();
          point = plate.getAbsolutePos();
          robot.parentNode.addChild(new WideEnpowerEffect(point.x, point.y));
          return robot.onSetBarrier(BulletType.WIDE);
        };
        break;
      case Spot.TYPE_DUAL_BULLET:
        this.effect = new SpotDualEffect(point.x, point.y + 5);
        this.resultFunc = function(robot, plate) {
          robot.barrierMap[BulletType.DUAL] = new DualBarrierEffect();
          point = plate.getAbsolutePos();
          robot.parentNode.addChild(new DualEnpowerEffect(point.x, point.y));
          return robot.onSetBarrier(BulletType.DUAL);
        };
    }
  }

  Spot.createRandom = function(point) {
    var type;
    type = Math.floor(Math.random() * Spot.SIZE) + 1;
    return new Spot(type, poit);
  };

  Spot.getRandomType = function() {
    return Math.floor(Math.random() * Spot.SIZE) + 1;
  };

  return Spot;

})();

Plate = (function(_super) {
  __extends(Plate, _super);

  Plate.HEIGHT = 74;

  Plate.WIDTH = 64;

  Plate.STATE_NORMAL = 0;

  Plate.STATE_PLAYER = 1;

  Plate.STATE_ENEMY = 2;

  Plate.STATE_SELECTED = 3;

  function Plate(x, y, ix, iy) {
    this.ix = ix;
    this.iy = iy;
    Plate.__super__.constructor.call(this, Plate.WIDTH, Plate.HEIGHT);
    this.x = x;
    this.y = y;
    this.lock = false;
    this.image = Game.instance.assets[R.BACKGROUND_IMAGE.PLATE];
    this.spotEnabled = false;
    this.pravState = Plate.STATE_NORMAL;
  }

  Plate.prototype.setState = function(state) {
    this.pravState = this.frame;
    this.frame = state;
    if (state === Plate.STATE_PLAYER || state === Plate.STATE_ENEMY) {
      return this.lock = true;
    } else {
      return this.lock = false;
    }
  };

  Plate.prototype.setPrevState = function() {
    return this.setState(this.prevState);
  };

  Plate.prototype.getAbsolutePos = function() {
    var i, offsetX, offsetY;
    i = this.parentNode;
    offsetX = offsetY = 0;
    while (i != null) {
      offsetX += i.x;
      offsetY += i.y;
      i = i.parentNode;
    }
    return new Point(this.x + offsetX, this.y + offsetY);
  };

  Plate.prototype.setSpot = function(type) {
    if (this.spotEnabled === false) {
      this.spotEnabled = true;
      this.spot = new Spot(type, this);
      return this.parentNode.addChild(this.spot.effect);
    }
  };

  Plate.prototype.onRobotAway = function(robot) {
    return this.setState(Plate.STATE_NORMAL);
  };

  Plate.prototype.onRobotRide = function(robot) {
    this.setState(robot.plateState);
    if (this.spotEnabled === true) {
      this.parentNode.removeChild(this.spot.effect);
      this.spot.resultFunc(robot, this);
      this.spot = null;
      return this.spotEnabled = false;
    }
  };

  return Plate;

})(ViewSprite);

Map = (function(_super) {
  __extends(Map, _super);

  Map.WIDTH = 9;

  Map.HEIGHT = 7;

  Map.UNIT_HEIGHT = Plate.HEIGHT;

  Map.UNIT_WIDTH = Plate.WIDTH;

  function Map(x, y) {
    var list, offset, plate, rand, tx, ty, _i, _j, _ref, _ref1;
    if (Map.instance != null) {
      return Map.instance;
    }
    Map.__super__.constructor.apply(this, arguments);
    Map.instance = this;
    this.plateMatrix = [];
    offset = 64 / 4;
    for (ty = _i = 0, _ref = Map.HEIGHT; 0 <= _ref ? _i < _ref : _i > _ref; ty = 0 <= _ref ? ++_i : --_i) {
      list = [];
      for (tx = _j = 0, _ref1 = Map.WIDTH; 0 <= _ref1 ? _j < _ref1 : _j > _ref1; tx = 0 <= _ref1 ? ++_j : --_j) {
        if (ty % 2 === 0) {
          plate = new Plate(tx * Map.UNIT_WIDTH, (ty * Map.UNIT_HEIGHT) - ty * offset, tx, ty);
        } else {
          plate = new Plate(tx * Map.UNIT_WIDTH + Map.UNIT_HEIGHT / 2, (ty * Map.UNIT_HEIGHT) - ty * offset, tx, ty);
        }
        list.push(plate);
        this.addChild(plate);
        rand = Math.floor(Math.random() * 20);
        switch (rand) {
          case 0:
            plate.setSpot(Spot.TYPE_NORMAL_BULLET);
            break;
          case 1:
            plate.setSpot(Spot.TYPE_WIDE_BULLET);
            break;
          case 2:
            plate.setSpot(Spot.TYPE_DUAL_BULLET);
        }
      }
      this.plateMatrix.push(list);
    }
    this.x = x;
    this.y = y;
    this.width = Map.WIDTH * Map.UNIT_WIDTH;
    this.height = (Map.HEIGHT - 1) * (Map.UNIT_HEIGHT - offset) + Map.UNIT_HEIGHT + 16;
  }

  Map.prototype.getPlate = function(x, y) {
    return this.plateMatrix[y][x];
  };

  Map.prototype.getPlateRandom = function() {
    return this.plateMatrix[Math.floor(Math.random() * Map.HEIGHT)][Math.floor(Math.random() * Map.WIDTH)];
  };

  Map.prototype.eachPlate = function(plate, direct, func) {
    var i, ret, _results;
    if (direct == null) {
      direct = Direct.RIGHT;
    }
    ret = plate;
    i = 0;
    _results = [];
    while (ret != null) {
      func(ret, i);
      ret = this.getTargetPoision(ret, direct);
      _results.push(i++);
    }
    return _results;
  };

  Map.prototype.eachSurroundingPlate = function(plate, func) {
    var _this = this;
    return Direct.each(function(direct) {
      var target;
      target = _this.getTargetPoision(plate, direct);
      if (target != null) {
        return func(target, direct);
      }
    });
  };

  Map.prototype.isExistObject = function(plate, direct, lenght) {
    var i, ret, _i;
    if (direct == null) {
      direct = Direct.RIGHT;
    }
    ret = plate;
    for (i = _i = 0; 0 <= lenght ? _i < lenght : _i > lenght; i = 0 <= lenght ? ++_i : --_i) {
      ret = this.getTargetPoision(ret, direct);
      if (ret === null) {
        break;
      } else if (ret.lock === true) {
        return true;
      }
    }
    return false;
  };

  Map.prototype.getTargetPoision = function(plate, direct) {
    var offset;
    if (direct == null) {
      direct = Direct.RIGHT;
    }
    if (direct === Direct.RIGHT) {
      if (this.plateMatrix[plate.iy].length > plate.ix + 1) {
        return this.plateMatrix[plate.iy][plate.ix + 1];
      } else {
        return null;
      }
    } else if (direct === Direct.LEFT) {
      if (plate.ix > 0) {
        return this.plateMatrix[plate.iy][plate.ix - 1];
      } else {
        return null;
      }
    }
    if ((direct & Direct.RIGHT) !== 0 && (direct & Direct.UP) !== 0) {
      offset = plate.iy % 2 === 0 ? 0 : 1;
      if (offset + plate.ix < Map.WIDTH && plate.iy > 0) {
        return this.plateMatrix[plate.iy - 1][offset + plate.ix];
      } else {
        return null;
      }
    } else if ((direct & Direct.RIGHT) !== 0 && (direct & Direct.DOWN) !== 0) {
      offset = plate.iy % 2 === 0 ? 0 : 1;
      if (offset + plate.ix < Map.WIDTH && plate.iy + 1 < Map.HEIGHT) {
        return this.plateMatrix[plate.iy + 1][offset + plate.ix];
      } else {
        return null;
      }
    } else if ((direct & Direct.LEFT) !== 0 && (direct & Direct.UP) !== 0) {
      offset = plate.iy % 2 === 0 ? -1 : 0;
      if (offset + plate.ix >= 0 && plate.iy > 0) {
        return this.plateMatrix[plate.iy - 1][offset + plate.ix];
      } else {
        return null;
      }
    } else if ((direct & Direct.LEFT) !== 0 && (direct & Direct.DOWN) !== 0) {
      offset = plate.iy % 2 === 0 ? -1 : 0;
      if (offset + plate.ix >= 0 && plate.iy + 1 < Map.HEIGHT) {
        return this.plateMatrix[plate.iy + 1][offset + plate.ix];
      } else {
        return null;
      }
    }
    return null;
  };

  Map.prototype.update = function() {};

  return Map;

})(ViewGroup);

Button = (function(_super) {
  __extends(Button, _super);

  Button.WIDTH = 120;

  Button.HEIGHT = 50;

  function Button(x, y) {
    Button.__super__.constructor.call(this, Button.WIDTH, Button.HEIGHT);
    this.x = x;
    this.y = y;
  }

  Button.prototype.setOnClickEventListener = function(listener) {
    return this.on_click_event = listener;
  };

  Button.prototype.ontouchstart = function() {
    if (this.on_click_event != null) {
      this.on_click_event();
    }
    return this.frame = 1;
  };

  Button.prototype.ontouchend = function() {
    return this.frame = 0;
  };

  return Button;

})(ViewSprite);

NextButton = (function(_super) {
  __extends(NextButton, _super);

  function NextButton(x, y) {
    NextButton.__super__.constructor.call(this, x, y);
    this.image = Game.instance.assets[R.BACKGROUND_IMAGE.NEXT_BUTTON];
  }

  return NextButton;

})(Button);

MsgWindow = (function(_super) {
  __extends(MsgWindow, _super);

  MsgWindow.WIDTH = 320;

  MsgWindow.HEIGHT = 128;

  function MsgWindow(x, y) {
    MsgWindow.__super__.constructor.call(this, MsgWindow.WIDTH, MsgWindow.HEIGHT);
    this.x = x;
    this.y = y;
    this.image = Game.instance.assets[R.BACKGROUND_IMAGE.MSGBOX];
  }

  return MsgWindow;

})(ViewSprite);

MsgBox = (function(_super) {
  __extends(MsgBox, _super);

  function MsgBox(x, y) {
    MsgBox.__super__.constructor.call(this, MsgWindow.WIDTH, MsgWindow.HEIGHT);
    this.x = x;
    this.y = y;
    this.window = new MsgWindow(0, 0);
    this.addChild(this.window);
    this.label = new Label;
    this.label.font = "16px 'Meiryo UI'";
    this.label.color = '#FFF';
    this.label.x = 10;
    this.label.y = 30;
    this.addChild(this.label);
    this.label.width = MsgWindow.WIDTH * 0.9;
  }

  MsgBox.prototype.initEvent = function(world) {
    var _this = this;
    world.player.addEventListener('move', function(evt) {
      var player, point;
      player = evt.target;
      point = evt.params;
      if (point !== false) {
        return _this.print(R.String.move(player.name, point.x + 1, point.y + 1));
      } else {
        return _this.print(R.String.CANNOTMOVE);
      }
    });
    return world.player.addEventListener('shot', function(evt) {
      var player, ret;
      player = evt.target;
      ret = evt.params;
      if (ret !== false) {
        return _this.print(R.String.shot(player.name));
      } else {
        return _this.print(R.String.CANNOTSHOT);
      }
    });
  };

  MsgBox.prototype.print = function(msg) {
    return this.label.text = "" + msg;
  };

  return MsgBox;

})(ViewGroup);

StatusWindow = (function(_super) {
  __extends(StatusWindow, _super);

  StatusWindow.WIDTH = 160;

  StatusWindow.HEIGHT = 128;

  function StatusWindow(x, y) {
    StatusWindow.__super__.constructor.call(this, StatusWindow.WIDTH, StatusWindow.HEIGHT);
    this.x = x;
    this.y = y;
    this.image = Game.instance.assets[R.BACKGROUND_IMAGE.STATUS_BOX];
  }

  return StatusWindow;

})(ViewSprite);

RemainingBullet = (function(_super) {
  __extends(RemainingBullet, _super);

  RemainingBullet.SIZE = 24;

  function RemainingBullet(x, y, frame) {
    RemainingBullet.__super__.constructor.call(this, RemainingBullet.SIZE, RemainingBullet.SIZE);
    this.x = x;
    this.y = y;
    this.frame = frame;
    this.image = Game.instance.assets[R.ITEM.STATUS_BULLET];
  }

  return RemainingBullet;

})(ViewSprite);

RemainingBullets = (function(_super) {
  __extends(RemainingBullets, _super);

  RemainingBullets.HEIGHT = 30;

  RemainingBullets.WIDTH = 120;

  function RemainingBullets(x, y, type) {
    var b, i, _i;
    this.type = type;
    RemainingBullets.__super__.constructor.call(this, RemainingBullets.WIDTH, RemainingBullets.HEIGHT);
    this.x = x;
    this.y = y;
    this.size = 0;
    this.array = [];
    for (i = _i = 0; _i <= 4; i = ++_i) {
      b = new RemainingBullet(i * RemainingBullet.SIZE, 0, this.type);
      this.array.push(b);
      this.addChild(b);
    }
  }

  RemainingBullets.prototype.increment = function() {
    if (this.size < 5) {
      this.array[this.size].frame = this.type - 1;
      return this.size++;
    }
  };

  RemainingBullets.prototype.decrement = function() {
    if (this.size > 0) {
      this.size--;
      return this.array[this.size].frame = this.type;
    }
  };

  return RemainingBullets;

})(ViewGroup);

StatusBarrier = (function(_super) {
  __extends(StatusBarrier, _super);

  StatusBarrier.SIZE = 24;

  function StatusBarrier(x, y, type) {
    this.type = type;
    StatusBarrier.__super__.constructor.call(this, StatusBarrier.SIZE, StatusBarrier.SIZE);
    this.x = x;
    this.y = y;
    this.frame = this.type;
    this.image = Game.instance.assets[R.ITEM.STATUS_BARRIER];
  }

  StatusBarrier.prototype.set = function() {
    return this.frame = this.type - 1;
  };

  StatusBarrier.prototype.reset = function() {
    return this.frame = this.type;
  };

  return StatusBarrier;

})(ViewSprite);

StatusBarrierGroup = (function(_super) {
  __extends(StatusBarrierGroup, _super);

  function StatusBarrierGroup(x, y) {
    this.reset = __bind(this.reset, this);
    this.set = __bind(this.set, this);
    StatusBarrierGroup.__super__.constructor.apply(this, arguments);
    this.normal = new StatusBarrier(30, 0, 1);
    this.wide = new StatusBarrier(55, 0, 3);
    this.dual = new StatusBarrier(80, 0, 5);
    this.addChild(this.normal);
    this.addChild(this.wide);
    this.addChild(this.dual);
    document.addEventListener("setBarrier", this.set);
    document.addEventListener("resetBarrier", this.reset);
  }

  StatusBarrierGroup.prototype.set = function(evt) {
    switch (evt.bulletType) {
      case BulletType.NORMAL:
        return this.normal.set();
      case BulletType.WIDE:
        return this.wide.set();
      case BulletType.DUAL:
        return this.dual.set();
    }
  };

  StatusBarrierGroup.prototype.reset = function(evt) {
    switch (evt.bulletType) {
      case BulletType.NORMAL:
        return this.normal.reset();
      case BulletType.WIDE:
        return this.wide.reset();
      case BulletType.DUAL:
        return this.dual.reset();
    }
  };

  return StatusBarrierGroup;

})(ViewGroup);

RemainingBulletsGroup = (function(_super) {
  __extends(RemainingBulletsGroup, _super);

  function RemainingBulletsGroup(x, y) {
    this.dequeue = __bind(this.dequeue, this);
    this.enqueue = __bind(this.enqueue, this);
    RemainingBulletsGroup.__super__.constructor.apply(this, arguments);
    this.normal = new RemainingBullets(30, 30, 1);
    this.wide = new RemainingBullets(30, 30 + RemainingBullet.SIZE, 3);
    this.dual = new RemainingBullets(30, 30 + RemainingBullet.SIZE * 2, 5);
    this.addChild(this.normal);
    this.addChild(this.wide);
    this.addChild(this.dual);
    document.addEventListener("enqueueBullet", this.enqueue);
    document.addEventListener("dequeueBullet", this.dequeue);
  }

  RemainingBulletsGroup.prototype.initEvent = function(world) {
    var _this = this;
    world.player.addEventListener('pickup', function(evt) {});
    return world.player.addEventListener('shot', function(evt) {});
  };

  RemainingBulletsGroup.prototype.enqueue = function(evt) {
    switch (evt.bulletType) {
      case BulletType.NORMAL:
        return this.normal.increment();
      case BulletType.WIDE:
        return this.wide.increment();
      case BulletType.DUAL:
        return this.dual.increment();
    }
  };

  RemainingBulletsGroup.prototype.dequeue = function(evt) {
    switch (evt.bulletType) {
      case BulletType.NORMAL:
        return this.normal.decrement();
      case BulletType.WIDE:
        return this.wide.decrement();
      case BulletType.DUAL:
        return this.dual.decrement();
    }
  };

  return RemainingBulletsGroup;

})(ViewGroup);

StatusBox = (function(_super) {
  __extends(StatusBox, _super);

  function StatusBox(x, y) {
    StatusBox.__super__.constructor.call(this, StatusWindow.WIDTH, StatusWindow.HEIGHT);
    this.x = x;
    this.y = y;
    this.addView(new StatusBarrierGroup());
    this.addView(new RemainingBulletsGroup());
  }

  return StatusBox;

})(ViewGroup);

Footer = (function(_super) {
  __extends(Footer, _super);

  function Footer(x, y) {
    Footer.__super__.constructor.apply(this, arguments);
    this.x = x;
    this.y = y;
    this.addView(new MsgBox(20, 0));
    this.addView(new StatusBox(x + MsgWindow.WIDTH + 32, 16));
  }

  return Footer;

})(ViewGroup);
