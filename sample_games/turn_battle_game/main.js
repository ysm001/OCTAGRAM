// Generated by CoffeeScript 1.6.2
var CommandPool, R, RobotGame, RobotScene, RobotWorld, TurnSwitcher, ViewGroup,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

R = Config.R;

CommandPool = (function() {
  function CommandPool(robot) {
    var end;

    end = new Instruction(Instruction.END, function() {
      return true;
    });
    this.end = new Command(end);
    this.moveLeftUp = new Command(new MoveLeftUp);
    this.moveleftDown = new Command(new MoveLeftDown);
    this.moveRightUp = new Command(new MoveRightUp);
    this.moveRightDown = new Command(new MoveRightDown);
    this.moveRight = new Command(new MoveRight);
    this.moveLeft = new Command(new MoveLeft);
    this.pickupNormal = new Command(new Pickup(), [BulletType.NORMAL, NormalBulletItem, robot.bltQueue]);
    this.pickupWide = new Command(new Pickup(), [BulletType.WIDE, WideBulletItem, robot.wideBltQueue]);
    this.pickupDual = new Command(new Pickup(), [BulletType.DUAL, DualBulletItem, robot.dualBltQueue]);
    this.shotNormal = new Command(new Shot(), [robot.bltQueue]);
    this.shotWide = new Command(new Shot(), [robot.wideBltQueue]);
    this.shotDual = new Command(new Shot(), [robot.dualBltQueue]);
    this.search = new Command(new Searching);
    this.getHp = new Command(new GetHp);
    this.getBulletQueueSize = Command(new GetBulletQueueSize);
  }

  return CommandPool;

})();

ViewGroup = (function(_super) {
  __extends(ViewGroup, _super);

  function ViewGroup(x, y, scene) {
    this.scene = scene;
    ViewGroup.__super__.constructor.apply(this, arguments);
    this.x = x;
    this.y = y;
    this.background = new Background(0, 0);
    this.addChild(this.background);
    this.header = new Header(16, 16);
    this.playerHpBar = this.header.playerHpBar;
    this.enemyHpBar = this.header.enemyHpBar;
    this.addChild(this.header);
    this.map = new Map(16, 48);
    this.addChild(this.map);
    this.footer = new Footer(25, this.map.y + this.map.height);
    this.msgbox = this.footer.msgbox;
    this.addChild(this.footer);
  }

  ViewGroup.prototype.update = function(world) {
    var i, _i, _len, _ref;

    _ref = world.robots;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      i.onViewUpdate(this);
    }
    return this.map.update();
  };

  return ViewGroup;

})(Group);

TurnSwitcher = (function() {
  function TurnSwitcher(world) {
    this.world = world;
    this.i = 0;
  }

  TurnSwitcher.prototype.update = function() {
    var animated, bullet, i, _i, _j, _len, _len1, _ref, _ref1;

    animated = bullet = false;
    _ref = this.world.bullets;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      bullet = i.animated;
      if (bullet === true) {
        break;
      }
    }
    _ref1 = this.world.robots;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      i = _ref1[_j];
      animated = i.isAnimated();
      if (animated === true) {
        break;
      }
    }
    if (bullet === false && animated === false) {
      if (this.world.robots[this.i].update()) {
        this.i++;
        if (this.i === this.world.robots.length) {
          return this.i = 0;
        }
      }
    }
  };

  return TurnSwitcher;

})();

RobotWorld = (function(_super) {
  __extends(RobotWorld, _super);

  function RobotWorld(x, y, scene) {
    var plate, pos;

    this.scene = scene;
    RobotWorld.__super__.constructor.apply(this, arguments);
    this.game = Game.instance;
    this.map = Map.instance;
    this.robots = [];
    this.bullets = [];
    this.items = [];
    this.player = new PlayerRobot;
    plate = this.map.getPlate(4, 5);
    pos = plate.getAbsolutePos();
    this.player.currentPlate = plate;
    this.player.x = pos.x;
    this.player.y = pos.y;
    this.addChild(this.player);
    this.robots.push(this.player);
    this.enemy = new EnemyRobot;
    this.addChild(this.enemy);
    this.robots.push(this.enemy);
  }

  RobotWorld.prototype.initialize = function(views) {};

  RobotWorld.prototype.collisionBullet = function(bullet, robot) {
    return bullet.holder !== robot && bullet.within(robot, 32);
  };

  RobotWorld.prototype.updateItems = function() {
    var del, i, v, _i, _len, _ref;

    del = -1;
    _ref = this.items;
    for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
      v = _ref[i];
      if (v.animated === false) {
        del = i;
        this.items[i] = false;
      }
    }
    if (del !== -1) {
      return this.items = _.compact(this.items);
    }
  };

  RobotWorld.prototype.updateBullets = function() {
    var del, i, robot, v, _i, _j, _len, _len1, _ref, _ref1;

    del = -1;
    _ref = this.robots;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      robot = _ref[_i];
      _ref1 = this.bullets;
      for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
        v = _ref1[i];
        if (v !== false) {
          if (this.collisionBullet(v, robot)) {
            del = i;
            v.hit(robot);
            this.bullets[i] = false;
          } else if (v.animated === false) {
            del = i;
            this.bullets[i] = false;
          }
        }
      }
    }
    if (del !== -1) {
      return this.bullets = _.compact(this.bullets);
    }
  };

  RobotWorld.prototype._isAnimated = function(array, func) {
    var animated, i, _i, _len;

    animated = false;
    for (_i = 0, _len = array.length; _i < _len; _i++) {
      i = array[_i];
      animated = func(i);
      if (animated === true) {
        break;
      }
    }
    return animated;
  };

  RobotWorld.prototype.updateRobots = function() {
    var animated, i, _i, _j, _len, _len1, _ref, _ref1, _results;

    animated = false;
    _ref = [this.bullets, this.robots, this.items];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      i = _ref[_i];
      animated = this._isAnimated(i, function(x) {
        return x.animated;
      });
      if (animated === true) {
        break;
      }
    }
    if (animated === false) {
      _ref1 = this.robots;
      _results = [];
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        i = _ref1[_j];
        _results.push(i.update());
      }
      return _results;
    }
  };

  RobotWorld.prototype.update = function(views) {
    this.updateItems();
    this.updateRobots();
    return this.updateBullets();
  };

  return RobotWorld;

})(Group);

RobotScene = (function(_super) {
  __extends(RobotScene, _super);

  function RobotScene(game) {
    this.game = game;
    RobotScene.__super__.constructor.call(this, this);
    this.backgroundColor = "#c0c0c0";
    this.views = new ViewGroup(Config.GAME_OFFSET_X, Config.GAME_OFFSET_Y, this);
    this.world = new RobotWorld(Config.GAME_OFFSET_X, Config.GAME_OFFSET_Y, this);
    this.addChild(this.views);
    this.addChild(this.world);
    this.world.initialize(this.views);
  }

  RobotScene.prototype.onenterframe = function() {
    return this.update();
  };

  RobotScene.prototype.update = function() {
    this.world.update(this.views);
    return this.views.update(this.world);
  };

  return RobotScene;

})(Scene);

RobotGame = (function(_super) {
  __extends(RobotGame, _super);

  function RobotGame(width, height) {
    RobotGame.__super__.constructor.call(this, width, height);
    this._assetPreload();
    this.keybind(87, 'w');
    this.keybind(65, 'a');
    this.keybind(88, 'x');
    this.keybind(68, 'd');
    this.keybind(83, 's');
    this.keybind(81, 'q');
    this.keybind(69, 'e');
    this.keybind(67, 'c');
    this.keybind(76, 'l');
    this.keybind(77, 'm');
    this.keybind(74, 'j');
    this.keybind(73, 'i');
    this.keybind(75, 'k');
  }

  RobotGame.prototype._assetPreload = function() {
    var load,
      _this = this;

    load = function(hash) {
      var k, path, _results;

      _results = [];
      for (k in hash) {
        path = hash[k];
        Debug.log("load image " + path);
        _results.push(_this.preload(path));
      }
      return _results;
    };
    load(R.CHAR);
    load(R.BACKGROUND_IMAGE);
    load(R.UI);
    load(R.EFFECT);
    load(R.BULLET);
    return load(R.ITEM);
  };

  RobotGame.prototype.onload = function() {
    this.assets["font0.png"] = this.assets['resources/ui/font0.png'];
    this.assets["apad.png"] = this.assets['resources/ui/apad.png'];
    this.assets["icon0.png"] = this.assets['resources/ui/icon0.png'];
    this.assets["pad.png"] = this.assets['resources/ui/pad.png'];
    this.scene = new RobotScene(this);
    return this.pushScene(this.scene);
  };

  return RobotGame;

})(Game);

window.onload = function() {
  var game;

  game = new RobotGame(Config.GAME_WIDTH, Config.GAME_HEIGHT);
  return game.start();
};
