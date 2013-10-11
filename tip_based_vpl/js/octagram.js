var LocalStorage, ServerStorage;

LocalStorage = (function() {
  function LocalStorage() {}

  LocalStorage.prototype.save = function(key, value) {
    return localStorage.setItem(key, JSON.stringify(value));
  };

  LocalStorage.prototype.load = function(key) {
    return JSON.parse(localStorage.getItem(key));
  };

  return LocalStorage;

})();

ServerStorage = (function() {
  function ServerStorage() {}

  ServerStorage.prototype.save = function(key, value) {};

  ServerStorage.prototype.load = function(key) {};

  return ServerStorage;

})();

var InstructionEvent,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

InstructionEvent = (function(_super) {
  __extends(InstructionEvent, _super);

  function InstructionEvent(type, params) {
    this.params = params;
    InstructionEvent.__super__.constructor.call(this, type);
  }

  return InstructionEvent;

})(enchant.Event);

var GroupedSprite, ImageSprite, SpriteGroup, _ref,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SpriteGroup = (function(_super) {
  __extends(SpriteGroup, _super);

  function SpriteGroup(image) {
    SpriteGroup.__super__.constructor.call(this);
    if (image) {
      this.sprite = new Sprite(image.width, image.height);
      this.sprite.image = image;
    }
  }

  SpriteGroup.prototype.topGroup = function() {
    var top;
    top = this;
    while (top.parentNode && !(top.parentNode instanceof Scene)) {
      top = top.parentNode;
    }
    return top;
  };

  SpriteGroup.prototype.getAbsolutePosition = function() {
    var parent, pos;
    pos = {
      x: this.x,
      y: this.y
    };
    parent = this.parentNode;
    while ((parent != null) && !(parent instanceof Scene)) {
      pos.x += parent.x;
      pos.y += parent.y;
      parent = parent.parentNode;
    }
    return pos;
  };

  SpriteGroup.prototype.setOpacity = function(opacity) {
    var child, _i, _len, _ref, _results;
    _ref = this.childNodes;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      if (child instanceof Sprite) {
        _results.push(child.opacity = opacity);
      } else if (child instanceof SpriteGroup) {
        _results.push(child.setOpacity(opacity));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  SpriteGroup.prototype.setVisible = function(visible) {
    var child, _i, _len, _ref, _results;
    _ref = this.childNodes;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      if (child instanceof Sprite) {
        _results.push(child.visible = visible);
      } else if (child instanceof SpriteGroup) {
        _results.push(child.setVisible(opacity));
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };

  SpriteGroup.prototype.getWidth = function() {
    return this.sprite.width;
  };

  SpriteGroup.prototype.getHeight = function() {
    return this.sprite.height;
  };

  return SpriteGroup;

})(Group);

GroupedSprite = (function(_super) {
  __extends(GroupedSprite, _super);

  function GroupedSprite() {
    _ref = GroupedSprite.__super__.constructor.apply(this, arguments);
    return _ref;
  }

  GroupedSprite.prototype.getAbsolutePosition = function() {
    var parent, pos;
    pos = {
      x: this.x,
      y: this.y
    };
    parent = this.parentNode;
    while ((parent != null) && !(parent instanceof Scene)) {
      pos.x += parent.x;
      pos.y += parent.y;
      parent = parent.parentNode;
    }
    return pos;
  };

  return GroupedSprite;

})(Sprite);

ImageSprite = (function(_super) {
  __extends(ImageSprite, _super);

  function ImageSprite(image) {
    ImageSprite.__super__.constructor.call(this, image.width, image.height);
    this.image = image;
  }

  return ImageSprite;

})(Sprite);

var ActionTip, BranchTip, EmptyTip, NopTip, Point, ReturnTip, SingleTransitionTip, StartTip, StopTip, ThinkTip, Tip, WallTip,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Point = (function() {
  function Point(x, y) {
    this.x = x;
    this.y = y;
  }

  return Point;

})();

Tip = (function() {
  function Tip() {
    this.transitions = {};
    this.index = {
      x: 0,
      y: 0
    };
  }

  Tip.prototype.addTransition = function(name, dst) {
    return this.transitions[name] = dst;
  };

  Tip.prototype.getTransition = function(name) {
    return this.transitions[name];
  };

  Tip.prototype.clone = function() {
    return new Tip();
  };

  Tip.prototype.copy = function(obj) {
    var t;
    obj.index.x = this.index.x;
    obj.index.y = this.index.y;
    for (t in this.transitions) {
      obj.transitions[t] = this.transitions[t];
    }
    return obj;
  };

  Tip.prototype.execute = function() {
    return null;
  };

  Tip.prototype.mkDescription = function() {
    return TipUtil.tipToMessage(this);
  };

  Tip.prototype.serialize = function() {
    return {
      name: this.constructor.name,
      index: this.index,
      transitions: this.transitions
    };
  };

  Tip.prototype.deserialize = function(serializedVal) {
    this.transitions = serializedVal.transitions;
    return this.index = serializedVal.index;
  };

  return Tip;

})();

EmptyTip = (function(_super) {
  __extends(EmptyTip, _super);

  function EmptyTip() {
    EmptyTip.__super__.constructor.call(this);
  }

  EmptyTip.prototype.clone = function() {
    return new EmptyTip();
  };

  return EmptyTip;

})(Tip);

StopTip = (function(_super) {
  __extends(StopTip, _super);

  function StopTip() {
    StopTip.__super__.constructor.call(this);
  }

  StopTip.prototype.clone = function() {
    return new StopTip();
  };

  return StopTip;

})(Tip);

SingleTransitionTip = (function(_super) {
  __extends(SingleTransitionTip, _super);

  function SingleTransitionTip(next) {
    SingleTransitionTip.__super__.constructor.call(this);
    this.setNext(next);
  }

  SingleTransitionTip.prototype.setNext = function(next) {
    this.next = next;
    return this.addTransition("next", this.next);
  };

  SingleTransitionTip.prototype.getNext = function() {
    return this.getTransition("next");
  };

  SingleTransitionTip.prototype.execute = function() {
    return this.getTransition("next");
  };

  SingleTransitionTip.prototype.clone = function() {
    return this.copy(new SingleTransitionTip(this.getNext()));
  };

  return SingleTransitionTip;

})(Tip);

ThinkTip = (function(_super) {
  __extends(ThinkTip, _super);

  function ThinkTip(next) {
    ThinkTip.__super__.constructor.call(this, next);
  }

  ThinkTip.prototype.clone = function() {
    return this.copy(new ThinkTip(this.getNext()));
  };

  return ThinkTip;

})(SingleTransitionTip);

NopTip = (function(_super) {
  __extends(NopTip, _super);

  function NopTip(next) {
    NopTip.__super__.constructor.call(this, next);
  }

  NopTip.prototype.clone = function() {
    return this.copy(new NopTip(this.getNext()));
  };

  return NopTip;

})(ThinkTip);

StartTip = (function(_super) {
  __extends(StartTip, _super);

  function StartTip(next) {
    StartTip.__super__.constructor.call(this, next);
  }

  StartTip.prototype.clone = function() {
    return this.copy(new StartTip(this.getNext()));
  };

  return StartTip;

})(SingleTransitionTip);

ReturnTip = (function(_super) {
  __extends(ReturnTip, _super);

  function ReturnTip(next) {
    ReturnTip.__super__.constructor.call(this, next);
  }

  ReturnTip.prototype.clone = function() {
    return this.copy(new ReturnTip(this.getNext()));
  };

  return ReturnTip;

})(SingleTransitionTip);

WallTip = (function(_super) {
  __extends(WallTip, _super);

  function WallTip(next) {
    WallTip.__super__.constructor.call(this, next);
  }

  WallTip.prototype.clone = function() {
    return this.copy(new WallTip(this.getNext()));
  };

  return WallTip;

})(SingleTransitionTip);

BranchTip = (function(_super) {
  __extends(BranchTip, _super);

  function BranchTip(conseq, alter) {
    BranchTip.__super__.constructor.call(this);
    this.addTransition("conseq", conseq);
    this.addTransition("alter", alter);
  }

  BranchTip.prototype.condition = function() {
    return true;
  };

  BranchTip.prototype.execute = function() {
    BranchTip.__super__.execute.apply(this, arguments);
    if (this.condition()) {
      return this.getTransition("conseq");
    } else {
      return this.getTransition("alter");
    }
  };

  BranchTip.prototype.setConseq = function(conseq) {
    return this.addTransition("conseq", conseq);
  };

  BranchTip.prototype.setAlter = function(alter) {
    return this.addTransition("alter", alter);
  };

  BranchTip.prototype.getConseq = function() {
    return this.getTransition("conseq");
  };

  BranchTip.prototype.getAlter = function() {
    return this.getTransition("alter");
  };

  BranchTip.prototype.clone = function() {
    return this.copy(new BranchTip(this.getConseq(), this.getAlter()));
  };

  return BranchTip;

})(Tip);

ActionTip = (function(_super) {
  __extends(ActionTip, _super);

  function ActionTip(next) {
    ActionTip.__super__.constructor.call(this, next);
  }

  ActionTip.prototype.action = function() {};

  ActionTip.prototype.execute = function() {
    this.action();
    return this.getTransition("next");
  };

  ActionTip.prototype.clone = function() {
    var tip;
    return tip = this.copy(new ActionTip(this.getNext()));
  };

  return ActionTip;

})(SingleTransitionTip);

var ActionInstruction, BranchInstruction, CustomInstructionActionTip, CustomInstructionBranchTip, Instruction,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __slice = [].slice;

Instruction = (function(_super) {
  __extends(Instruction, _super);

  function Instruction() {
    Instruction.__super__.constructor.call(this);
    this.isAsynchronous = false;
    this.parameters = [];
  }

  Instruction.prototype.onComplete = function(result) {
    if (result == null) {
      result = null;
    }
    /*
    evt = document.createEvent('UIEvent', false)
    evt.initUIEvent('completeExecution', true, true)
    */

    return this.dispatchEvent(new InstructionEvent('completeExecution', {
      tip: this,
      result: result
    }));
    /*
    evt.tip = this
    evt.result = result
    */

  };

  Instruction.prototype.action = function() {};

  Instruction.prototype.execute = function() {
    return this.action();
  };

  Instruction.prototype.setAsynchronous = function(async) {
    if (async == null) {
      async = true;
    }
    return this.isAsynchronous = async;
  };

  Instruction.prototype.addParameter = function(param) {
    var _this = this;
    param.onParameterComplete = function() {
      return _this.onParameterComplete(param);
    };
    param.onValueChanged = function() {
      return _this.onParameterChanged(param);
    };
    param.mkLabel = function() {
      return _this.mkLabel(param);
    };
    return this.parameters.push(param);
  };

  Instruction.prototype.mkDescription = function() {};

  Instruction.prototype.mkLabel = function(value) {
    return value;
  };

  Instruction.prototype.getIcon = function() {};

  Instruction.prototype.setConstructorArgs = function() {
    var args;
    args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return this.constructorArgs = args;
  };

  Instruction.prototype.onParameterChanged = function(parameter) {};

  Instruction.prototype.onParameterComplete = function(parameter) {};

  Instruction.prototype.copy = function(obj) {
    var param, _i, _len, _ref;
    obj.isAsynchronous = this.isAsynchronous;
    obj.parameters = [];
    _ref = this.parameters;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      param = _ref[_i];
      obj.addParameter(param.clone());
    }
    return obj;
  };

  Instruction.prototype.clone = function() {
    return this.copy(new Instruction());
  };

  Instruction.prototype.serialize = function() {
    var param;
    return {
      name: this.constructor.name,
      parameters: (function() {
        var _i, _len, _ref, _results;
        _ref = this.parameters;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          param = _ref[_i];
          _results.push(param.serialize());
        }
        return _results;
      }).call(this)
    };
  };

  Instruction.prototype.deserialize = function(serializedVal) {
    var param, target, _i, _len, _ref, _results;
    _ref = serializedVal.parameters;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      param = _ref[_i];
      _results.push(((function() {
        var _j, _len1, _ref1, _results1;
        _ref1 = this.parameters;
        _results1 = [];
        for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
          target = _ref1[_j];
          if (target.valueName === param.valueName) {
            _results1.push(target);
          }
        }
        return _results1;
      }).call(this))[0].deserialize(param));
    }
    return _results;
  };

  return Instruction;

})(EventTarget);

ActionInstruction = (function(_super) {
  __extends(ActionInstruction, _super);

  function ActionInstruction() {
    ActionInstruction.__super__.constructor.call(this);
  }

  ActionInstruction.prototype.clone = function() {
    return this.copy(new ActionInstruction());
  };

  return ActionInstruction;

})(Instruction);

BranchInstruction = (function(_super) {
  __extends(BranchInstruction, _super);

  function BranchInstruction() {
    BranchInstruction.__super__.constructor.call(this);
  }

  BranchInstruction.prototype.action = function() {
    return false;
  };

  BranchInstruction.prototype.clone = function() {
    return this.copy(new BranchInstruction());
  };

  return BranchInstruction;

})(Instruction);

CustomInstructionActionTip = (function(_super) {
  __extends(CustomInstructionActionTip, _super);

  function CustomInstructionActionTip(instruction, next) {
    this.instruction = instruction;
    CustomInstructionActionTip.__super__.constructor.call(this, next);
  }

  CustomInstructionActionTip.prototype.action = function() {
    return this.instruction.execute();
  };

  CustomInstructionActionTip.prototype.isAsynchronous = function() {
    return this.instruction.isAsynchronous;
  };

  CustomInstructionActionTip.prototype.mkDescription = function() {
    return this.instruction.mkDescription();
  };

  CustomInstructionActionTip.prototype.getIcon = function() {
    return this.instruction.getIcon();
  };

  CustomInstructionActionTip.prototype.clone = function() {
    return this.copy(new CustomInstructionActionTip(this.instruction.clone(), this.getNext()));
  };

  CustomInstructionActionTip.prototype.serialize = function() {
    var serialized;
    serialized = CustomInstructionActionTip.__super__.serialize.apply(this, arguments);
    serialized["instruction"] = this.instruction.serialize();
    return serialized;
  };

  CustomInstructionActionTip.prototype.deserialize = function(serializedVal) {
    CustomInstructionActionTip.__super__.deserialize.call(this, serializedVal);
    return this.instruction.deserialize(serializedVal.instruction);
  };

  return CustomInstructionActionTip;

})(ActionTip);

CustomInstructionBranchTip = (function(_super) {
  __extends(CustomInstructionBranchTip, _super);

  function CustomInstructionBranchTip(instruction, conseq, alter) {
    this.instruction = instruction;
    CustomInstructionBranchTip.__super__.constructor.call(this, conseq, alter);
  }

  CustomInstructionBranchTip.prototype.condition = function() {
    return this.instruction.execute();
  };

  CustomInstructionBranchTip.prototype.mkDescription = function() {
    return this.instruction.mkDescription();
  };

  CustomInstructionBranchTip.prototype.isAsynchronous = function() {
    return this.instruction.isAsynchronous;
  };

  CustomInstructionBranchTip.prototype.getIcon = function() {
    return this.instruction.getIcon();
  };

  CustomInstructionBranchTip.prototype.clone = function() {
    return this.copy(new CustomInstructionBranchTip(this.instruction.clone(), this.getConseq, this.getAlter()));
  };

  CustomInstructionBranchTip.prototype.serialize = function() {
    var serialized;
    serialized = CustomInstructionBranchTip.__super__.serialize.apply(this, arguments);
    serialized["instruction"] = this.instruction.serialize();
    return serialized;
  };

  CustomInstructionBranchTip.prototype.deserialize = function(serializedVal) {
    CustomInstructionBranchTip.__super__.deserialize.call(this, serializedVal);
    return this.instruction.deserialize(serializedVal.instruction);
  };

  return CustomInstructionBranchTip;

})(BranchTip);

var executeEnemyProgram, executePlayerProgram, getEnemyProgram, getPlayerProgram, loadEnemyProgram, loadPlayerProgram, saveEnemyProgram, savePlayerProgram, showEnemyProgram, showPlayerProgram, test;

getPlayerProgram = function() {
  return Game.instance.octagrams.getInstance(Game.instance.currentScene.world.playerProgramId);
};

getEnemyProgram = function() {
  return Game.instance.octagrams.getInstance(Game.instance.currentScene.world.enemyProgramId);
};

executePlayerProgram = function() {
  return getPlayerProgram().execute();
};

executeEnemyProgram = function() {
  return getEnemyProgram().execute();
};

savePlayerProgram = function() {
  return getPlayerProgram().save("player");
};

saveEnemyProgram = function() {
  return getEnemyProgram().save("enemy");
};

loadPlayerProgram = function() {
  return getPlayerProgram().load("player");
};

loadEnemyProgram = function() {
  return getEnemyProgram().load("enemy");
};

showPlayerProgram = function() {
  return Game.instance.octagrams.show(Game.instance.currentScene.world.playerProgramId);
};

showEnemyProgram = function() {
  return Game.instance.octagrams.show(Game.instance.currentScene.world.enemyProgramId);
};

test = function() {
  var enemyProgram, playerProgram;
  playerProgram = Game.instance.currentScene.world.playerProgram;
  enemyProgram = Game.instance.currentScene.world.enemyProgram;
  playerProgram.load("test");
  enemyProgram.load("test");
  playerProgram.execute();
  return enemyProgram.execute();
};

var EventUtil, TipUtil, uniqueID;

TipUtil = (function() {
  function TipUtil() {}

  TipUtil.tipToImage = function(code) {
    var assetName;
    assetName = code instanceof EmptyTip ? "emptyTip" : code instanceof ReturnTip ? "returnTip" : code instanceof StartTip ? "startTip" : code instanceof StopTip ? "stopTip" : code instanceof ActionTip ? "actionTip" : code instanceof BranchTip ? "branchTip" : code instanceof ThinkTip ? "thinkTip" : code instanceof WallTip ? "wallTip" : void 0;
    return Resources.get(assetName);
  };

  TipUtil.tipToIcon = function(code) {
    if (code instanceof NopTip) {
      return Resources.get("iconNop");
    }
  };

  TipUtil.tipToMessage = function(code) {
    if (code instanceof EmptyTip) {
      return TextResource.msg["empty"];
    } else if (code instanceof ReturnTip) {
      return TextResource.msg["return"];
    } else if (code instanceof StartTip) {
      return TextResource.msg["start"];
    } else if (code instanceof StopTip) {
      return TextResource.msg["stop"];
    } else if (code instanceof ActionTip) {
      return TextResource.msg["action"];
    } else if (code instanceof BranchTip) {
      return TextResource.msg["branch"];
    } else if (code instanceof WallTip) {
      return TextResource.msg["wall"];
    } else if (code instanceof NopTip) {
      return TextResource.msg["nop"];
    }
  };

  return TipUtil;

})();

EventUtil = (function() {
  function EventUtil() {}

  EventUtil.createEvent = function(eventName) {
    var evt;
    evt = document.createEvent('UIEvent', false);
    evt.initUIEvent(eventName, true, true);
    return evt;
  };

  return EventUtil;

})();

uniqueID = function() {
  var date, randam, time;
  randam = Math.floor(Math.random() * 1000);
  date = new Date();
  time = date.getTime();
  return randam + time.toString();
};

var Resources, TextResource;

Resources = (function() {
  function Resources() {}

  Resources.base = "./";

  Resources.resources = {
    "emptyTip": "empty_tip_48x48.png",
    "returnTip": "return_tip_48x48.png",
    "startTip": "start_tip_48x48.png",
    "actionTip": "action_tip_48x48.png",
    "stopTip": "stop_tip_48x48.png",
    "branchTip": "branch_tip_48x48.png",
    "thinkTip": "think_tip_48x48.png",
    "wallTip": "wall_tip_48x48.png",
    "selectedEffect": "select_effect_48x48.png",
    "execEffect": "exec_effect_48x48.png",
    "mapTip": "map_tip_58x58.png",
    "mapBorder": "map_border_12x58.png",
    "mapBorder2": "map_border_58x12.png",
    "mapEdge": "map_edge_12x12.png",
    "transition": "transition_24x24.png",
    "alterTransition": "alter_transition_24x24.png",
    "panel": "panel_640x496.png",
    "miniPanel": "panel_548x320.png",
    "frame": "frame_640x640.png",
    "frameLeft": "frame_left.png",
    "frameRight": "frame_right.png",
    "frameTop": "frame_top.png",
    "frameBottom": "frame_bottom.png",
    "helpPanel": "help_panel_144x640.png",
    "closeButton": "close_btn_32x32.png",
    "arrow": "arrow_64x64.png",
    "filter": "filter_960x960.png",
    "okButton": "ok_button_154x56.png",
    "testObject": "test_obj_48x48.png",
    "iconUp": "icon_up_32x32.png",
    "iconDown": "icon_down_32x32.png",
    "iconRandom": "icon_random_32x32.png",
    "iconNop": "icon_nop_32x32.png",
    "sidebar": "sidebar_160x496.png",
    "slider": "slider_256x32.png",
    "sliderKnob": "slider_knob_16x16.png",
    "dummy": "dummy_1x1.png"
  };

  Resources.load = function(game) {
    var k, v, _ref, _results;
    _ref = Resources.resources;
    _results = [];
    for (k in _ref) {
      v = _ref[k];
      _results.push(game.preload(Resources.base + v));
    }
    return _results;
  };

  Resources.get = function(assetName) {
    return Game.instance.assets[Resources.base + Resources.resources[assetName]];
  };

  return Resources;

})();

TextResource = (function() {
  function TextResource() {}

  TextResource.msg = {
    "empty": "チップがセットされていません。",
    "stop": "プログラムを停止します。",
    "branch": "条件に応じて進行方向を分岐します。",
    "return": "プログラムの開始地点に戻ります。",
    "wall": "プログラムの開始地点に戻ります。",
    "start": "プログラムの開始地点です。",
    "action": "アクションを実行します。",
    "nop": "何も実行しないで次へ進みます。",
    title: {
      "selector": "挿入するチップを選択して下さい。",
      "configurator": "パラメータ編集"
    }
  };

  return TextResource;

})();

var ExecutionEffect, SelectedEffect,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

SelectedEffect = (function(_super) {
  __extends(SelectedEffect, _super);

  function SelectedEffect() {
    SelectedEffect.__super__.constructor.call(this, Resources.get("selectedEffect"));
    this.visible = false;
    this.touchEnabled = false;
  }

  SelectedEffect.prototype.show = function(parent) {
    this.visible = true;
    return parent.addChild(this);
  };

  SelectedEffect.prototype.hide = function() {
    this.visible = false;
    return this.parentNode.removeChild(this);
  };

  return SelectedEffect;

})(ImageSprite);

ExecutionEffect = (function(_super) {
  __extends(ExecutionEffect, _super);

  ExecutionEffect.fadeTime = 400;

  function ExecutionEffect() {
    this._hide = __bind(this._hide, this);
    ExecutionEffect.__super__.constructor.call(this, Resources.get("execEffect"));
    this.visible = false;
    this.busy = false;
    this.tl.setTimeBased();
  }

  ExecutionEffect.prototype.show = function(parent) {
    this.tl.clear();
    this.opacity = 1;
    if (!this.busy && !this.visible) {
      parent.addChild(this);
    }
    return this.visible = true;
  };

  ExecutionEffect.prototype.hide = function() {
    if (this.visible) {
      this.tl.clear();
      this.busy = true;
      return this.tl.fadeOut(ExecutionEffect.fadeTime).then(this._hide);
    }
  };

  ExecutionEffect.prototype._hide = function() {
    this.busy = false;
    this.visible = false;
    return this.parentNode.removeChild(this);
  };

  return ExecutionEffect;

})(ImageSprite);

var AlterTransition, NormalTransition, TipTransition,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

TipTransition = (function(_super) {
  __extends(TipTransition, _super);

  function TipTransition(image, src, dst) {
    this.src = src;
    this.dst = dst;
    TipTransition.__super__.constructor.call(this, image.width, image.height);
    this.image = image;
    this.link(this.src, this.dst);
  }

  TipTransition.prototype.link = function(src, dst) {
    var pos, theta;
    pos = this.calcPosition(src, dst);
    theta = this.calcRotation(src, dst);
    this.moveTo(pos.x, pos.y);
    return this.rotate(theta);
  };

  TipTransition.prototype.calcPosition = function(src, dst) {
    var dx, dy, x, y;
    dx = dst.x - src.x;
    dy = dst.y - src.y;
    x = dx / 2 + this.image.width / 2;
    y = dy / 2 + this.image.height / 2;
    return {
      x: x,
      y: y
    };
  };

  TipTransition.prototype.calcRotation = function(src, dst) {
    var cos, dx, dy, theta;
    dx = dst.x - src.x;
    dy = dst.y - src.y;
    cos = dx / Math.sqrt(dx * dx + dy * dy);
    theta = Math.acos(cos) * 180 / Math.PI;
    if (dy < 0) {
      theta *= -1;
    }
    return theta;
  };

  TipTransition.prototype.rotateToDirection = function(theta) {
    if ((-22.5 < theta && theta <= 22.5)) {
      return Direction.right;
    } else if ((22.5 < theta && theta <= 67.5)) {
      return Direction.rightDown;
    } else if ((67.5 < theta && theta <= 112.5)) {
      return Direction.down;
    } else if ((112.5 < theta && theta <= 157.5)) {
      return Direction.leftDown;
    } else if ((-157.5 < theta && theta <= -112.5)) {
      return Direction.leftUp;
    } else if ((-112.5 < theta && theta <= -67.5)) {
      return Direction.up;
    } else if ((-67.5 < theta && theta <= -22.5)) {
      return Direction.rightUp;
    } else if (theta > 157.5 || (theta <= -157.5 && -157.5 <= 22.5)) {
      return Direction.left;
    }
  };

  TipTransition.prototype.ontouchmove = function(e) {
    var dir, dst, nx, ny, src, srcIdx, theta, tip;
    tip = TipFactory.createEmptyTip();
    src = {
      x: this.src.x + tip.getWidth() / 2,
      y: this.src.y + tip.getHeight() / 2
    };
    theta = this.calcRotation(src, e);
    dir = this.rotateToDirection(theta);
    srcIdx = this.src.getIndex();
    nx = srcIdx.x + dir.x;
    ny = srcIdx.y + dir.y;
    dst = Game.instance.vpl.currentVM.cpu.getTip(nx, ny);
    if (dst !== this.dst) {
      this.dst = dst;
      if (this.src.setConseq != null) {
        if (this instanceof AlterTransition) {
          return this.src.setAlter(nx, ny, dst);
        } else {
          return this.src.setConseq(nx, ny, dst);
        }
      } else {
        return this.src.setNext(nx, ny, dst);
      }
    }
  };

  TipTransition.prototype.hide = function(parent) {
    return this.parentNode.removeChild(this);
  };

  TipTransition.prototype.show = function(parent) {
    return parent.addChild(this);
  };

  return TipTransition;

})(Sprite);

NormalTransition = (function(_super) {
  __extends(NormalTransition, _super);

  function NormalTransition(src, dst) {
    NormalTransition.__super__.constructor.call(this, Resources.get("transition"), src, dst);
  }

  return NormalTransition;

})(TipTransition);

AlterTransition = (function(_super) {
  __extends(AlterTransition, _super);

  function AlterTransition(src, dst) {
    AlterTransition.__super__.constructor.call(this, Resources.get("alterTransition"), src, dst);
  }

  return AlterTransition;

})(TipTransition);

var BranchTransitionCodeTip, CodeTip, Direction, JumpTransitionCodeTip, SingleTransitionCodeTip,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Direction = (function() {
  function Direction() {}

  Direction.left = new Point(-1, 0);

  Direction.right = new Point(1, 0);

  Direction.up = new Point(0, -1);

  Direction.down = new Point(0, 1);

  Direction.leftUp = new Point(-1, -1);

  Direction.leftDown = new Point(-1, 1);

  Direction.rightUp = new Point(1, -1);

  Direction.rightDown = new Point(1, 1);

  Direction.toDirection = function(x, y) {
    return new Point(x, y);
  };

  return Direction;

})();

CodeTip = (function(_super) {
  __extends(CodeTip, _super);

  CodeTip.selectedEffect = null;

  CodeTip.clonedTip = null;

  function CodeTip(code) {
    this.code = code;
    this.ontouchend = __bind(this.ontouchend, this);
    this.ontouchmove = __bind(this.ontouchmove, this);
    this.ontouchstart = __bind(this.ontouchstart, this);
    this.select = __bind(this.select, this);
    CodeTip.__super__.constructor.call(this, TipUtil.tipToImage(this.code));
    this.immutable = this.code instanceof WallTip || this.code instanceof StartTip;
    this.description = this.code.mkDescription();
    this.isTransitionSelect = false;
    this.icon = this.getIcon();
    this.dragMode = false;
    this.isFirstClick = false;
    this.dragStartX = 0;
    this.dragStartY = 0;
    this.parameters = this.code.instruction != null ? this.code.instruction.parameters : void 0;
    this.addChild(this.sprite);
    if (this.icon != null) {
      this.addChild(this.icon);
      this.icon.fitPosition();
    }
    this.executionEffect = new ExecutionEffect(this);
    if (CodeTip.selectedEffect == null) {
      CodeTip.selectedEffect = new SelectedEffect();
    }
  }

  CodeTip.prototype.isInnerTip = function(x, y) {
    var pos, range, xe, xs, ye, ys;
    pos = this.getAbsolutePosition();
    range = this.getWidth();
    xs = pos.x;
    xe = pos.x + range;
    ys = pos.y;
    ye = pos.y + range;
    return x > xs && x < xe && y > ys && y < ye;
  };

  CodeTip.prototype.select = function() {
    this.topGroup().ui.help.setText(this.description);
    this.isFirstClick = !this.isSelected();
    return this.showSelectedEffect();
  };

  CodeTip.prototype.unselect = function() {
    this.topGroup().help.setText("");
    return this.hideSelectedEffect();
  };

  CodeTip.prototype.execute = function() {
    if (this.code != null) {
      return this.code.execute();
    } else {
      return null;
    }
  };

  CodeTip.prototype.createGhost = function() {
    var tip;
    if (CodeTip.clonedTip != null) {
      CodeTip.clonedTip.hide();
    }
    tip = this.clone();
    tip.setOpacity(0.5);
    tip.moveTo(this.x, this.y);
    tip.sprite.touchEnabled = false;
    return tip;
  };

  CodeTip.prototype.ontouchstart = function(e) {
    this.isTransitionSelect = !this.isInnerTip(e.x, e.y);
    if (!this.isTransitionSelect) {
      if (this.dragMode && (CodeTip.clonedTip != null)) {
        CodeTip.clonedTip.hide();
      }
      this.dragMode = false;
      return this.select();
    }
  };

  CodeTip.prototype.ontouchmove = function(e) {
    if (!this.isTransitionSelect) {
      if (!this.dragMode && !this.immutable) {
        this.dragMode = true;
        this.dragStart(e);
      }
      return this.dragged(e);
    }
  };

  CodeTip.prototype.ontouchend = function(e) {
    if (!this.immutable) {
      if (!this.dragMode && this.isSelected() && !this.isFirstClick) {
        this.doubleClicked();
      } else if (this.dragMode) {
        this.dragEnd(e);
      }
    }
    return CodeTip.selectedInstance = this;
  };

  CodeTip.prototype.dragStart = function(e) {
    CodeTip.clonedTip = this.createGhost();
    CodeTip.clonedTip.show(this.parentNode);
    this.dragStartX = e.x;
    return this.dragStartY = e.y;
  };

  CodeTip.prototype.dragged = function(e) {
    var dx, dy;
    if (CodeTip.clonedTip != null) {
      dx = e.x - this.dragStartX;
      dy = e.y - this.dragStartY;
      return CodeTip.clonedTip.moveTo(this.x + dx, this.y + dy);
    }
  };

  CodeTip.prototype.dragEnd = function(e) {
    var pos;
    this.dragMode = false;
    if (CodeTip.clonedTip != null) {
      pos = CodeTip.clonedTip.getAbsolutePosition();
      this.topGroup().cpu.insertTipOnNearestPosition(pos.x, pos.y, CodeTip.clonedTip);
      return CodeTip.clonedTip.hide();
    }
  };

  CodeTip.prototype.doubleClicked = function() {
    return this.showConfigWindow();
  };

  CodeTip.prototype.showConfigWindow = function() {
    var panel;
    panel = new ParameterConfigPanel(this.topGroup());
    return panel.show(this);
  };

  CodeTip.prototype.isSelected = function() {
    return CodeTip.selectedEffect.parentNode === this;
  };

  CodeTip.prototype.showExecutionEffect = function() {
    return this.executionEffect.show(this);
  };

  CodeTip.prototype.hideExecutionEffect = function() {
    return this.executionEffect.hide();
  };

  CodeTip.prototype.showSelectedEffect = function() {
    if (!this.isSelected()) {
      return CodeTip.selectedEffect.show(this);
    }
  };

  CodeTip.prototype.hideSelectedEffect = function() {
    return CodeTip.selectedEffect.hide();
  };

  CodeTip.prototype.isAsynchronous = function() {
    return (this.code.isAsynchronous != null) && this.code.isAsynchronous();
  };

  CodeTip.prototype.setIcon = function(icon) {
    this.icon = icon;
    return this.icon.fitPosition();
  };

  CodeTip.prototype.getIcon = function() {
    var icon;
    this.icon = this.code.getIcon != null ? this.code.getIcon() : (icon = TipUtil.tipToIcon(this.code), icon != null ? new Icon(icon) : null);
    return this.icon;
  };

  CodeTip.prototype.setDescription = function(desc) {
    this.description = desc;
    return this.onDescriptionChanged();
  };

  CodeTip.prototype.onDescriptionChanged = function() {
    if (this.isSelected()) {
      return this.topGroup().ui.help.setText(this.description);
    }
  };

  CodeTip.prototype.setIndex = function(idxX, idxY) {
    return this.code.index = {
      x: idxX,
      y: idxY
    };
  };

  CodeTip.prototype.getIndex = function() {
    return this.code.index;
  };

  CodeTip.prototype.show = function(parent) {
    if (parent != null) {
      return parent.addChild(this);
    }
  };

  CodeTip.prototype.hide = function(parent) {
    if (this.parentNode != null) {
      return this.parentNode.removeChild(this);
    }
  };

  CodeTip.prototype.clone = function() {
    return new CodeTip(this.code.clone());
  };

  CodeTip.prototype.copy = function(obj) {
    obj.description = this.description;
    if (this.icon != null) {
      obj.icon = this.icon.clone();
    }
    return obj;
  };

  CodeTip.prototype.serialize = function() {
    return {
      name: this.constructor.name,
      code: this.code.serialize()
    };
  };

  CodeTip.prototype.deserialize = function(serializedVal) {
    this.code.deserialize(serializedVal.code);
    return this.setDescription(this.code.mkDescription());
  };

  return CodeTip;

})(SpriteGroup);

SingleTransitionCodeTip = (function(_super) {
  __extends(SingleTransitionCodeTip, _super);

  function SingleTransitionCodeTip(code) {
    SingleTransitionCodeTip.__super__.constructor.call(this, code);
    this.trans = null;
  }

  SingleTransitionCodeTip.prototype.setNext = function(x, y, dst) {
    if (this.trans != null) {
      this.trans.hide();
    }
    this.trans = new NormalTransition(this, dst);
    this.trans.show(this);
    return this.code.setNext({
      x: x,
      y: y
    });
  };

  SingleTransitionCodeTip.prototype.getNextDir = function() {
    var next;
    next = this.code.getNext();
    if (next == null) {
      return null;
    } else {
      return Direction.toDirection(next.x - this.code.index.x, next.y - this.code.index.y);
    }
  };

  SingleTransitionCodeTip.prototype.clone = function() {
    return this.copy(new SingleTransitionCodeTip(this.code.clone()));
  };

  return SingleTransitionCodeTip;

})(CodeTip);

BranchTransitionCodeTip = (function(_super) {
  __extends(BranchTransitionCodeTip, _super);

  function BranchTransitionCodeTip(code) {
    BranchTransitionCodeTip.__super__.constructor.call(this, code);
    this.conseqTrans = null;
    this.alterTrans = null;
  }

  BranchTransitionCodeTip.prototype.setConseq = function(x, y, dst) {
    if (this.conseqTrans != null) {
      this.conseqTrans.hide();
    }
    this.conseqTrans = new NormalTransition(this, dst);
    this.conseqTrans.show(this);
    return this.code.setConseq({
      x: x,
      y: y
    });
  };

  BranchTransitionCodeTip.prototype.setAlter = function(x, y, dst) {
    if (this.alterTrans != null) {
      this.alterTrans.hide();
    }
    this.alterTrans = new AlterTransition(this, dst);
    this.alterTrans.show(this);
    return this.code.setAlter({
      x: x,
      y: y
    });
  };

  BranchTransitionCodeTip.prototype.getConseqDir = function() {
    var next;
    next = this.code.getConseq();
    if (next == null) {
      return null;
    } else {
      return Direction.toDirection(next.x - this.code.index.x, next.y - this.code.index.y);
    }
  };

  BranchTransitionCodeTip.prototype.getAlterDir = function() {
    var next;
    next = this.code.getAlter();
    if (next == null) {
      return null;
    } else {
      return Direction.toDirection(next.x - this.code.index.x, next.y - this.code.index.y);
    }
  };

  BranchTransitionCodeTip.prototype.clone = function() {
    return this.copy(new BranchTransitionCodeTip(this.code.clone()));
  };

  return BranchTransitionCodeTip;

})(CodeTip);

JumpTransitionCodeTip = (function(_super) {
  __extends(JumpTransitionCodeTip, _super);

  function JumpTransitionCodeTip(code) {
    JumpTransitionCodeTip.__super__.constructor.call(this, code);
  }

  JumpTransitionCodeTip.prototype.setNext = function(x, y) {
    return this.code.setNext({
      x: x,
      y: y
    });
  };

  JumpTransitionCodeTip.prototype.clone = function() {
    return this.copy(new JumpTransitionCodeTip(this.code.clone()));
  };

  return JumpTransitionCodeTip;

})(CodeTip);

var Icon,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Icon = (function(_super) {
  __extends(Icon, _super);

  function Icon(icon, width, height) {
    var h, w;
    w = width != null ? width : icon.width;
    h = height != null ? height : icon.height;
    Icon.__super__.constructor.call(this, w, h);
    this.image = icon;
    this.parent = null;
    this.hidden = true;
    this.touchEnabled = false;
  }

  Icon.prototype.fitPosition = function() {
    if (this.parentNode != null) {
      return this.moveTo(this.parentNode.getWidth() / 2 - this.width / 2, this.parentNode.getWidth() / 2 - this.height / 2);
    }
  };

  Icon.prototype.clone = function() {
    var obj;
    obj = new Icon(this.image, this.width, this.height);
    obj.frame = this.frame;
    return obj;
  };

  return Icon;

})(Sprite);

var TipParameter;

TipParameter = (function() {
  function TipParameter(valueName, value, min, max, step, id) {
    this.valueName = valueName;
    this.value = value;
    this.min = min;
    this.max = max;
    this.step = step;
    this.id = id;
    this.text = "";
  }

  TipParameter.prototype.setValue = function(value) {
    this.value = value;
    this.text = toString();
    return this.onValueChanged();
  };

  TipParameter.prototype.getValue = function() {
    return this.value;
  };

  TipParameter.prototype.onValueChanged = function() {};

  TipParameter.prototype.onParameterComplete = function() {};

  TipParameter.prototype.mkLabel = function() {};

  TipParameter.prototype.clone = function() {
    return this.copy(new TipParameter(this.valueName, this.value, this.min, this.max, this.step));
  };

  TipParameter.prototype.copy = function(obj) {
    obj.valueName = this.valueName;
    obj.value = this.value;
    obj.min = this.min;
    obj.max = this.max;
    obj.step = this.step;
    obj.id = this.id;
    return obj;
  };

  TipParameter.prototype.toString = function() {
    return this.value.toString();
  };

  TipParameter.prototype.serialize = function() {
    return {
      valueName: this.valueName,
      value: this.value
    };
  };

  TipParameter.prototype.deserialize = function(serializedVal) {
    return this.setValue(serializedVal.value);
  };

  return TipParameter;

})();

var TipFactory;

TipFactory = (function() {
  function TipFactory() {}

  TipFactory.createReturnTip = function(sx, sy) {
    var tip;
    tip = new JumpTransitionCodeTip(new ReturnTip());
    tip.setNext(sx, sy);
    return tip;
  };

  TipFactory.createWallTip = function(sx, sy) {
    var tip;
    tip = new JumpTransitionCodeTip(new WallTip());
    tip.setNext(sx, sy);
    return tip;
  };

  TipFactory.createStartTip = function() {
    return new SingleTransitionCodeTip(new StartTip());
  };

  TipFactory.createStopTip = function(sx, sy) {
    return new CodeTip(new StopTip());
  };

  TipFactory.createEmptyTip = function(sx, sy) {
    return new CodeTip(new EmptyTip());
  };

  TipFactory.createActionTip = function(code) {
    return new SingleTransitionCodeTip(code);
  };

  TipFactory.createBranchTip = function(code) {
    return new BranchTransitionCodeTip(code);
  };

  TipFactory.createThinkTip = function(code) {
    return new SingleTransitionCodeTip(code);
  };

  TipFactory.createNopTip = function() {
    return TipFactory.createThinkTip(new NopTip());
  };

  TipFactory.createInstructionTip = function(inst) {
    if (inst instanceof ActionInstruction) {
      return TipFactory.createActionTip(new CustomInstructionActionTip(inst));
    } else if (inst instanceof BranchInstruction) {
      return TipFactory.createBranchTip(new CustomInstructionBranchTip(inst));
    } else {
      return console.log("error : invalid instruction type.");
    }
  };

  return TipFactory;

})();

var RandomBranchInstruction,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

RandomBranchInstruction = (function(_super) {
  __extends(RandomBranchInstruction, _super);

  function RandomBranchInstruction() {
    var parameter;
    RandomBranchInstruction.__super__.constructor.call(this);
    this.threthold = 50;
    parameter = new TipParameter("確率", 50, 0, 100, 1);
    this.addParameter(parameter);
  }

  RandomBranchInstruction.prototype.action = function() {
    var r;
    r = Math.random();
    return r * 100 < this.threthold;
  };

  RandomBranchInstruction.prototype.clone = function() {
    var obj;
    obj = this.copy(new RandomBranchInstruction());
    obj.threthold = this.threthold;
    return obj;
  };

  RandomBranchInstruction.prototype.onParameterChanged = function(parameter) {
    return this.threthold = parameter.value;
  };

  RandomBranchInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  RandomBranchInstruction.prototype.mkDescription = function() {
    return this.threthold + "%の確率で青矢印に進みます。<br>" + (100 - this.threthold) + "%の確率で赤矢印に進みます。";
  };

  return RandomBranchInstruction;

})(BranchInstruction);

var StackAddInstruction, StackBnzInstruction, StackDivInstruction, StackDupInstruction, StackGrtInstruction, StackMachine, StackModInstruction, StackMulInstruction, StackNotInstruction, StackRotInstruction, StackSubInstruction, StackSwpInstruction, StackXorInstruction,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

StackMachine = (function() {
  function StackMachine() {
    this.stack = [];
  }

  StackMachine.prototype.pop = function() {
    return this.stack.pop();
  };

  StackMachine.prototype.push = function(val) {
    return this.stack.push(val);
  };

  StackMachine.prototype.binaryOp = function(op) {
    if (this.stack.length > 1) {
      return this.push(op(this.pop(), this.pop()));
    }
  };

  StackMachine.prototype.unaryOp = function(op) {
    if (this.stack.length > 0) {
      return this.push(op(this.pop()));
    }
  };

  StackMachine.prototype.add = function() {
    return this.binaryOp(function(y, x) {
      return x + y;
    });
  };

  StackMachine.prototype.sub = function() {
    return this.binaryOp(function(y, x) {
      return x - y;
    });
  };

  StackMachine.prototype.mul = function() {
    return this.binaryOp(function(y, x) {
      return x * y;
    });
  };

  StackMachine.prototype.div = function() {
    return this.binaryOp(function(y, x) {
      return x / y;
    });
  };

  StackMachine.prototype.mod = function() {
    return this.binaryOp(function(y, x) {
      return x % y;
    });
  };

  StackMachine.prototype.xor = function() {
    return this.binaryOp(function(y, x) {
      return x ^ y;
    });
  };

  StackMachine.prototype.grt = function() {
    return this.binaryOp(function(y, x) {
      if (x > y) {
        return 1;
      } else {
        return 0;
      }
    });
  };

  StackMachine.prototype.swap = function() {
    var x, y;
    if (this.stack.length > 1) {
      x = this.pop();
      y = this.pop();
      this.push(y);
      return this.push(x);
    }
  };

  StackMachine.prototype.not = function() {
    return this.unaryOp(this.stack.pop() === 0 ? 1 : 0);
  };

  StackMachine.prototype.dup = function() {
    var val;
    if (this.stack.length > 0) {
      val = this.pop();
      this.push(val);
      return this.push(val);
    }
  };

  StackMachine.prototype.rot = function() {
    var x, y, z;
    if (this.stack.length > 3) {
      x = this.pop();
      y = this.pop();
      z = this.pop();
      this.push(y);
      this.push(z);
      return this.push(x);
    }
  };

  StackMachine.prototype.bnz = function() {
    if (this.stack != null) {
      return this.pop() !== 0;
    } else {
      return false;
    }
  };

  StackMachine.prototype.input = function() {
    return this.push(window.prompt());
  };

  StackMachine.prototype.toString = function() {
    var str;
    str = "";
    while (this.stack != null) {
      str += String.fromCharCode(this.pop());
    }
    return str;
  };

  return StackMachine;

})();

StackAddInstruction = (function(_super) {
  __extends(StackAddInstruction, _super);

  function StackAddInstruction(stack) {
    this.stack = stack;
    StackAddInstruction.__super__.constructor.apply(this, arguments);
  }

  StackAddInstruction.prototype.action = function() {
    return this.stack.add();
  };

  StackAddInstruction.prototype.clone = function() {
    return this.copy(new StackAddInstruction(this.stack));
  };

  StackAddInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackAddInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x+yの値をプッシュする。";
  };

  return StackAddInstruction;

})(ActionInstruction);

StackSubInstruction = (function(_super) {
  __extends(StackSubInstruction, _super);

  function StackSubInstruction(stack) {
    this.stack = stack;
    StackSubInstruction.__super__.constructor.apply(this, arguments);
  }

  StackSubInstruction.prototype.action = function() {
    return this.stack.sub();
  };

  StackSubInstruction.prototype.clone = function() {
    return this.copy(new StackSubInstruction(this.stack));
  };

  StackSubInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackSubInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x-yの値をプッシュする。";
  };

  return StackSubInstruction;

})(ActionInstruction);

StackMulInstruction = (function(_super) {
  __extends(StackMulInstruction, _super);

  function StackMulInstruction(stack) {
    this.stack = stack;
    StackMulInstruction.__super__.constructor.apply(this, arguments);
  }

  StackMulInstruction.prototype.action = function() {
    return this.stack.mul();
  };

  StackMulInstruction.prototype.clone = function() {
    return this.copy(new StackMulInstruction(this.stack));
  };

  StackMulInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackMulInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x+yの値をプッシュする。";
  };

  return StackMulInstruction;

})(ActionInstruction);

StackDivInstruction = (function(_super) {
  __extends(StackDivInstruction, _super);

  function StackDivInstruction(stack) {
    this.stack = stack;
    StackDivInstruction.__super__.constructor.apply(this, arguments);
  }

  StackDivInstruction.prototype.action = function() {
    return this.stack.div();
  };

  StackDivInstruction.prototype.clone = function() {
    return this.copy(new StackDivInstruction(this.stack));
  };

  StackDivInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackDivInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x/yの値をプッシュする。";
  };

  return StackDivInstruction;

})(ActionInstruction);

StackModInstruction = (function(_super) {
  __extends(StackModInstruction, _super);

  function StackModInstruction(stack) {
    this.stack = stack;
    StackModInstruction.__super__.constructor.apply(this, arguments);
  }

  StackModInstruction.prototype.action = function() {
    return this.stack.mod();
  };

  StackModInstruction.prototype.clone = function() {
    return this.copy(new StackModInstruction(this.stack));
  };

  StackModInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackModInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, xをyで割った時の余りをプッシュする。";
  };

  return StackModInstruction;

})(ActionInstruction);

StackXorInstruction = (function(_super) {
  __extends(StackXorInstruction, _super);

  function StackXorInstruction(stack) {
    this.stack = stack;
    StackXorInstruction.__super__.constructor.apply(this, arguments);
  }

  StackXorInstruction.prototype.action = function() {
    return this.stack.xor();
  };

  StackXorInstruction.prototype.clone = function() {
    return this.copy(new StackXorInstruction(this.stack));
  };

  StackXorInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackXorInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, xとyの排他的論理和の値をプッシュする。";
  };

  return StackXorInstruction;

})(ActionInstruction);

StackGrtInstruction = (function(_super) {
  __extends(StackGrtInstruction, _super);

  function StackGrtInstruction(stack) {
    this.stack = stack;
    StackGrtInstruction.__super__.constructor.apply(this, arguments);
  }

  StackGrtInstruction.prototype.action = function() {
    return this.stack.grt();
  };

  StackGrtInstruction.prototype.clone = function() {
    return this.copy(new StackGrtInstruction(this.stack));
  };

  StackGrtInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackGrtInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, x>yならば1をプッシュする。<br>そうでなければ0をプッシュする。";
  };

  return StackGrtInstruction;

})(ActionInstruction);

StackSwpInstruction = (function(_super) {
  __extends(StackSwpInstruction, _super);

  function StackSwpInstruction(stack) {
    this.stack = stack;
    StackSwpInstruction.__super__.constructor.apply(this, arguments);
  }

  StackSwpInstruction.prototype.action = function() {
    return this.stack.swap();
  };

  StackSwpInstruction.prototype.clone = function() {
    return new StackSwpInstruction(this.stack);
  };

  StackSwpInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackSwpInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, yをポップして, y, xの順でプッシュする。";
  };

  return StackSwpInstruction;

})(ActionInstruction);

StackNotInstruction = (function(_super) {
  __extends(StackNotInstruction, _super);

  function StackNotInstruction(stack) {
    this.stack = stack;
    StackNotInstruction.__super__.constructor.apply(this, arguments);
  }

  StackNotInstruction.prototype.action = function() {
    return this.stack.not();
  };

  StackNotInstruction.prototype.clone = function() {
    return this.copy(new StackNotInstruction(this.stack));
  };

  StackNotInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackNotInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからxをポップして, xが0ならば1をプッシュする。<br>そうでなければ0をプッシュする。";
  };

  return StackNotInstruction;

})(ActionInstruction);

StackDupInstruction = (function(_super) {
  __extends(StackDupInstruction, _super);

  function StackDupInstruction(stack) {
    this.stack = stack;
    StackDupInstruction.__super__.constructor.apply(this, arguments);
  }

  StackDupInstruction.prototype.action = function() {
    return this.stack.dup();
  };

  StackDupInstruction.prototype.clone = function() {
    return this.copy(new StackDupInstruction(this.stack));
  };

  StackDupInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackDupInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからxをポップして, xを2回プッシュする。";
  };

  return StackDupInstruction;

})(ActionInstruction);

StackRotInstruction = (function(_super) {
  __extends(StackRotInstruction, _super);

  function StackRotInstruction(stack) {
    this.stack = stack;
    StackRotInstruction.__super__.constructor.apply(this, arguments);
  }

  StackRotInstruction.prototype.action = function() {
    return this.stack.rot();
  };

  StackRotInstruction.prototype.clone = function() {
    return this.copy(new StackRotInstruction(this.stack));
  };

  StackRotInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackRotInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからx, y, zをポップして, y, z, xの順でプッシュする。";
  };

  return StackRotInstruction;

})(ActionInstruction);

StackBnzInstruction = (function(_super) {
  __extends(StackBnzInstruction, _super);

  function StackBnzInstruction(stack) {
    this.stack = stack;
    StackBnzInstruction.__super__.constructor.apply(this, arguments);
  }

  StackBnzInstruction.prototype.action = function() {
    return this.stack.bnz();
  };

  StackBnzInstruction.prototype.clone = function() {
    return this.copy(new StackBnzInstruction(this.stack));
  };

  StackBnzInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  StackBnzInstruction.prototype.mkDescription = function() {
    return "スタック操作命令(上級者向け)<br>" + "スタックからxをポップして, xが1ならば青矢印に進む。<br>そうでなければ赤矢印に進む。";
  };

  return StackBnzInstruction;

})(BranchInstruction);

var Counter, CounterBranchInstruction, CounterDecrementInstruction, CounterIncrementInstruction, CounterPopInstruction, CounterPushInstruction,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Counter = (function() {
  function Counter() {
    this.value = 0;
  }

  Counter.prototype.inc = function(amount) {
    if (amount == null) {
      amount = 1;
    }
    return this.value += amount;
  };

  Counter.prototype.dec = function(amount) {
    if (amount == null) {
      amount = -1;
    }
    return this.value -= amount;
  };

  Counter.prototype.clone = function() {
    var obj;
    obj = new Counter();
    obj.value = this.value;
    return obj;
  };

  return Counter;

})();

CounterIncrementInstruction = (function(_super) {
  __extends(CounterIncrementInstruction, _super);

  function CounterIncrementInstruction(counters) {
    var idParam, stepParam;
    this.counters = counters;
    CounterIncrementInstruction.__super__.constructor.call(this);
    this.id = 0;
    this.step = 1;
    idParam = new TipParameter("カウンターID", 0, 0, this.counters.length, 1);
    stepParam = new TipParameter("増加量", 1, 1, 100, 1);
    idParam.id = "id";
    stepParam.id = "step";
    this.addParameter(idParam);
    this.addParameter(stepParam);
  }

  CounterIncrementInstruction.prototype.action = function() {
    return this.counters[this.id].inc(this.step);
  };

  CounterIncrementInstruction.prototype.onParameterChanged = function(parameter) {
    if (parameter.id === "id") {
      return this.id = parameter.value;
    } else if (parameter.id === "step") {
      return this.step = parameter.value;
    }
  };

  CounterIncrementInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  CounterIncrementInstruction.prototype.mkDescription = function() {
    return "カウンター" + this.id + "を" + this.step + "増加させます。";
  };

  CounterIncrementInstruction.prototype.clone = function() {
    return this.copy(new CounterIncrementInstruction(this.counters));
  };

  return CounterIncrementInstruction;

})(ActionInstruction);

CounterDecrementInstruction = (function(_super) {
  __extends(CounterDecrementInstruction, _super);

  function CounterDecrementInstruction(counters) {
    var idParam, stepParam;
    this.counters = counters;
    CounterDecrementInstruction.__super__.constructor.call(this);
    this.id = 0;
    this.step = 1;
    idParam = new TipParameter("カウンターID", 0, 0, this.counters.length, 1);
    stepParam = new TipParameter("減少量", 1, 1, 100, 1);
    idParam.id = "id";
    stepParam.id = "step";
    this.addParameter(idParam);
    this.addParameter(stepParam);
  }

  CounterDecrementInstruction.prototype.action = function() {
    return this.counters[this.id].dec(this.step);
  };

  CounterDecrementInstruction.prototype.onParameterChanged = function(parameter) {
    if (parameter.id === "id") {
      return this.id = parameter.value;
    } else if (parameter.id === "step") {
      return this.step = parameter.value;
    }
  };

  CounterDecrementInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  CounterDecrementInstruction.prototype.mkDescription = function() {
    return "カウンター" + this.id + "を" + this.step + "減少させます。";
  };

  CounterDecrementInstruction.prototype.clone = function() {
    return this.copy(new CounterDecrementInstruction(this.counters));
  };

  return CounterDecrementInstruction;

})(ActionInstruction);

CounterBranchInstruction = (function(_super) {
  __extends(CounterBranchInstruction, _super);

  function CounterBranchInstruction(counters) {
    var idParam, thretholdParam;
    this.counters = counters;
    CounterBranchInstruction.__super__.constructor.call(this);
    this.id = 0;
    this.threthold = 0;
    idParam = new TipParameter("カウンターID", 0, 0, this.counters.length, 1);
    thretholdParam = new TipParameter("閾値", 0, -100, 100, 1);
    idParam.id = "id";
    thretholdParam.id = "threthold";
    this.addParameter(idParam);
    this.addParameter(thretholdParam);
  }

  CounterBranchInstruction.prototype.action = function() {
    return this.counters[this.id].value >= this.threthold;
  };

  CounterBranchInstruction.prototype.onParameterChanged = function(parameter) {
    if (parameter.id === "id") {
      return this.id = parameter.value;
    } else if (parameter.id === "threthold") {
      return this.threthold = parameter.value;
    }
  };

  CounterBranchInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  CounterBranchInstruction.prototype.mkDescription = function() {
    return "カウンター" + this.id + "が" + this.threthold + "以上ならば青矢印に進みます。<br>" + "カウンター" + this.id + "が" + this.threthold + "未満ならば赤矢印に進みます。";
  };

  CounterBranchInstruction.prototype.clone = function() {
    return this.copy(new CounterBranchInstruction(this.counters));
  };

  return CounterBranchInstruction;

})(BranchInstruction);

CounterPushInstruction = (function(_super) {
  __extends(CounterPushInstruction, _super);

  function CounterPushInstruction(counters, stack) {
    var idParam;
    this.counters = counters;
    this.stack = stack;
    CounterPushInstruction.__super__.constructor.call(this);
    this.id = 0;
    idParam = new TipParameter("カウンターID", 0, 0, this.counters.length, 1);
    this.addParameter(idParam);
  }

  CounterPushInstruction.prototype.action = function() {
    return this.stack.push(this.counters[this.id]);
  };

  CounterPushInstruction.prototype.onParameterChanged = function(parameter) {
    return this.id = parameter.value;
  };

  CounterPushInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  CounterPushInstruction.prototype.mkDescription = function() {
    return "カウンター" + this.id + "の値を" + "スタックにプッシュします。";
  };

  CounterPushInstruction.prototype.clone = function() {
    return this.copy(new CounterPushInstruction(this.counters));
  };

  return CounterPushInstruction;

})(ActionInstruction);

CounterPopInstruction = (function(_super) {
  __extends(CounterPopInstruction, _super);

  function CounterPopInstruction(counters, stack) {
    var idParam;
    this.counters = counters;
    this.stack = stack;
    CounterPopInstruction.__super__.constructor.call(this);
    this.id = 0;
    idParam = new TipParameter("カウンターID", 0, 0, this.counters.length, 1);
    this.addParameter(idParam);
  }

  CounterPopInstruction.prototype.action = function() {
    return this.counters[this.id] = this.stack.pop();
  };

  CounterPopInstruction.prototype.onParameterChanged = function(parameter) {
    return this.id = parameter.value;
  };

  CounterPopInstruction.prototype.getIcon = function() {
    return new Icon(Resources.get("iconRandom"));
  };

  CounterPopInstruction.prototype.mkDescription = function() {
    return "スタックからxをポップして, カウンター" + this.id + "に代入します。";
  };

  CounterPopInstruction.prototype.clone = function() {
    return this.copy(new CounterPushInstruction(this.counters));
  };

  return CounterPopInstruction;

})(ActionInstruction);

var Frame, HelpPanel, TextLabel, UICloseButton, UIOkButton, UIPanel, UIPanelBody,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

TextLabel = (function(_super) {
  __extends(TextLabel, _super);

  function TextLabel(text) {
    TextLabel.__super__.constructor.call(this, text);
    this.font = "18px 'Meirio', 'ヒラギノ角ゴ Pro W3', sans-serif";
    this.color = "white";
  }

  return TextLabel;

})(Label);

UIPanel = (function(_super) {
  __extends(UIPanel, _super);

  function UIPanel(content) {
    UIPanel.__super__.constructor.call(this, Resources.get("panel"));
    this.body = new UIPanelBody(this, content);
    this.addChild(this.sprite);
    this.addChild(this.body);
    this.setContent(content);
  }

  UIPanel.prototype.setTitle = function(title) {
    return this.body.label.text = title;
  };

  UIPanel.prototype.setContent = function(content) {
    return this.body.setContent(content);
  };

  UIPanel.prototype.onClosed = function(closedWithOK) {};

  UIPanel.prototype.show = function(parent) {
    return Game.instance.currentScene.addChild(this);
  };

  UIPanel.prototype.hide = function(closedWithOK) {
    this.onClosed(closedWithOK);
    return Game.instance.currentScene.removeChild(this);
  };

  return UIPanel;

})(SpriteGroup);

UIPanelBody = (function(_super) {
  __extends(UIPanelBody, _super);

  function UIPanelBody(parent, content) {
    this.parent = parent;
    this.content = content;
    UIPanelBody.__super__.constructor.call(this, Resources.get("miniPanel"));
    this.label = new TextLabel("");
    this.moveTo(Environment.EditorX + Environment.ScreenWidth / 2 - this.getWidth() / 2, Environment.EditorY + Environment.EditorHeight / 2 - this.getHeight() / 2);
    this.closeButton = new UICloseButton(this.parent);
    this.okButton = new UIOkButton(this.parent);
    this.closedWithOK = false;
    this.okButton.moveTo(this.getWidth() / 2 - this.okButton.width / 2, this.getHeight() - this.okButton.height - 24);
    this.closeButton.moveTo(32, 24);
    this.label.moveTo(80, 28);
    this.content.moveTo(90, 24);
    this.addChild(this.sprite);
    this.addChild(this.closeButton);
    this.addChild(this.okButton);
    this.addChild(this.label);
  }

  UIPanelBody.prototype.setContent = function(content) {
    if (this.content) {
      this.removeChild(this.content);
    }
    this.content = content;
    this.content.moveTo(32, 64);
    return this.addChild(content);
  };

  return UIPanelBody;

})(SpriteGroup);

UICloseButton = (function(_super) {
  __extends(UICloseButton, _super);

  function UICloseButton(parent) {
    var _this = this;
    this.parent = parent;
    UICloseButton.__super__.constructor.call(this, Resources.get("closeButton"));
    this.addEventListener('touchstart', function() {
      return _this.parent.hide(false);
    });
  }

  return UICloseButton;

})(ImageSprite);

UIOkButton = (function(_super) {
  __extends(UIOkButton, _super);

  function UIOkButton(parent) {
    var _this = this;
    this.parent = parent;
    UIOkButton.__super__.constructor.call(this, Resources.get("okButton"));
    this.addEventListener('touchstart', function() {
      return _this.parent.hide(true);
    });
  }

  return UIOkButton;

})(ImageSprite);

HelpPanel = (function(_super) {
  __extends(HelpPanel, _super);

  function HelpPanel(x, y, w, h, text) {
    this.text = text;
    HelpPanel.__super__.constructor.call(this, Resources.get("helpPanel"));
    this.label = new TextLabel(this.text);
    this.moveTo(x, y);
    this.label.width = w;
    this.label.height = h;
    this.label.x = 16;
    this.label.y = 16;
    this.addChild(this.sprite);
    this.addChild(this.label);
  }

  HelpPanel.prototype.setText = function(text) {
    return this.label.text = text;
  };

  HelpPanel.prototype.getText = function() {
    return this.label.text;
  };

  return HelpPanel;

})(SpriteGroup);

Frame = (function(_super) {
  __extends(Frame, _super);

  function Frame() {
    Frame.__super__.constructor.call(this, Resources.get("frame"));
    this.touchEnabled = false;
  }

  return Frame;

})(ImageSprite);

var TipBackground,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

TipBackground = (function(_super) {
  __extends(TipBackground, _super);

  function TipBackground(x, y, xnum, ynum) {
    var background, border, height, i, j, map, margin, space, tip, width, _i, _j, _ref, _ref1;
    TipBackground.__super__.constructor.call(this);
    border = Resources.get("mapBorder");
    background = Resources.get("mapTip");
    tip = Resources.get("emptyTip");
    margin = (background.width - 1 - tip.width) / 2;
    space = margin * 2 + tip.width;
    width = background.width;
    height = background.height;
    x += border.height;
    y += border.height;
    for (i = _i = -1, _ref = xnum + 1; -1 <= _ref ? _i < _ref : _i > _ref; i = -1 <= _ref ? ++_i : --_i) {
      for (j = _j = -1, _ref1 = ynum + 1; -1 <= _ref1 ? _j < _ref1 : _j > _ref1; j = -1 <= _ref1 ? ++_j : --_j) {
        map = new Sprite(width, height);
        map.image = background;
        map.moveTo(x + j * space, y + i * space);
        this.addChild(map);
      }
    }
  }

  return TipBackground;

})(Group);

var Cpu,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Cpu = (function(_super) {
  __extends(Cpu, _super);

  function Cpu(x, y, xnum, ynum, startIdx, vm) {
    this.xnum = xnum;
    this.ynum = ynum;
    this.vm = vm;
    Cpu.__super__.constructor.call(this, Resources.get("dummy"));
    this.tipTable = [];
    this.sx = startIdx;
    this.sy = -1;
    this.storage = new LocalStorage();
    this.createTips(x, y);
  }

  Cpu.prototype.putTip = function(sx, sy, dir, newTip) {
    var dx, dy;
    dx = sx + dir.x;
    dy = sy + dir.y;
    if (this.replaceTip(newTip, sx, sy)) {
      return newTip.setNext(dx, dy, this.getTip(dx, dy));
    }
  };

  Cpu.prototype.putBranchTip = function(sx, sy, conseqDir, alterDir, newTip) {
    var adx, ady, cdx, cdy;
    cdx = sx + conseqDir.x;
    cdy = sy + conseqDir.y;
    adx = sx + alterDir.x;
    ady = sy + alterDir.y;
    if (this.replaceTip(newTip, sx, sy)) {
      newTip.setConseq(cdx, cdy, this.getTip(cdx, cdy));
      return newTip.setAlter(adx, ady, this.getTip(adx, ady));
    }
  };

  Cpu.prototype.putSingleTip = function(sx, sy, newTip) {
    return this.replaceTip(newTip, sx, sy);
  };

  Cpu.prototype.replaceTip = function(newTip, xidx, yidx) {
    var oldTip, selected;
    if (!this.getTip(xidx, yidx).immutable) {
      oldTip = this.getTip(xidx, yidx);
      selected = oldTip.isSelected();
      oldTip.hide(this);
      newTip.moveTo(oldTip.x, oldTip.y);
      newTip.setIndex(xidx, yidx);
      newTip.show(this);
      if (selected) {
        newTip.select();
      }
      this.setTip(xidx, yidx, newTip);
      return true;
    } else {
      return false;
    }
  };

  Cpu.prototype.addTip = function(sx, sy, dir, newTip) {
    return this.replaceTip(newTip, sx + dir.x, sy + dir.y);
  };

  Cpu.prototype.putStartTip = function(x, y) {
    var dir, returnTip, start;
    start = new SingleTransitionCodeTip(new StartTip);
    returnTip = TipFactory.createReturnTip(this.sx, this.sy);
    dir = Direction.down;
    this.putTip(x, y, dir, start);
    return this.replaceTip(returnTip, this.sx + dir.x, this.sy + dir.y);
  };

  Cpu.prototype.createTips = function(x, y) {
    var height, i, j, maptip, margin, space, tip, width, _i, _j, _ref, _ref1;
    tip = Resources.get("emptyTip");
    maptip = Resources.get("mapTip");
    width = tip.width;
    height = tip.height;
    margin = (maptip.width - 1 - tip.width) / 2;
    space = margin * 2 + width;
    for (i = _i = -1, _ref = this.ynum + 1; -1 <= _ref ? _i < _ref : _i > _ref; i = -1 <= _ref ? ++_i : --_i) {
      this.tipTable[i] = [];
      for (j = _j = -1, _ref1 = this.xnum + 1; -1 <= _ref1 ? _j < _ref1 : _j > _ref1; j = -1 <= _ref1 ? ++_j : --_j) {
        tip = this.isWall(j, i) ? TipFactory.createWallTip(this.sx, this.sy) : TipFactory.createEmptyTip();
        tip.moveTo(x + margin + j * space, y + margin + i * space);
        tip.setIndex(j, i);
        tip.show(this);
        this.tipTable[i][j] = tip;
      }
    }
    return this.putStartTip(this.sx, this.sy);
  };

  Cpu.prototype.insertNewTip = function(x, y, tip) {
    var alterDir, conseqDir, dir, newTip;
    newTip = tip.clone();
    if (newTip instanceof JumpTransitionCodeTip) {
      return this.putSingleTip(x, y, newTip);
    } else if (newTip.setNext != null) {
      dir = tip.getNextDir();
      dir = dir != null ? dir : Direction.down;
      return this.putTip(x, y, dir, newTip);
    } else if (newTip.setConseq != null) {
      conseqDir = tip.getConseqDir();
      alterDir = tip.getAlterDir();
      conseqDir = conseqDir != null ? conseqDir : Direction.down;
      alterDir = alterDir != null ? alterDir : Direction.right;
      return this.putBranchTip(x, y, conseqDir, alterDir, newTip);
    } else {
      return this.putSingleTip(x, y, newTip);
    }
  };

  Cpu.prototype.getNearestIndex = function(x, y) {
    var dist, dx, dy, i, j, minDist, minX, minY, tmp, _i, _j, _ref, _ref1;
    minDist = 0xffffffff;
    minX = -1;
    minY = -1;
    for (i = _i = -1, _ref = this.ynum + 1; -1 <= _ref ? _i < _ref : _i > _ref; i = -1 <= _ref ? ++_i : --_i) {
      for (j = _j = -1, _ref1 = this.xnum + 1; -1 <= _ref1 ? _j < _ref1 : _j > _ref1; j = -1 <= _ref1 ? ++_j : --_j) {
        tmp = this.getTip(j, i);
        dx = tmp.x - x;
        dy = tmp.y - y;
        dist = dx * dx + dy * dy;
        if (dist < minDist) {
          minDist = dist;
          minX = j;
          minY = i;
        }
      }
    }
    return {
      x: minX,
      y: minY
    };
  };

  Cpu.prototype.insertTipOnNearestPosition = function(x, y, tip) {
    var nearest;
    nearest = this.getNearestIndex(x, y);
    return this.insertNewTip(nearest.x, nearest.y, tip);
  };

  Cpu.prototype.serialize = function() {
    var i, j, serialized, _i, _j, _ref, _ref1;
    serialized = [];
    for (i = _i = -1, _ref = this.ynum + 1; -1 <= _ref ? _i < _ref : _i > _ref; i = -1 <= _ref ? ++_i : --_i) {
      for (j = _j = -1, _ref1 = this.xnum + 1; -1 <= _ref1 ? _j < _ref1 : _j > _ref1; j = -1 <= _ref1 ? ++_j : --_j) {
        serialized.push({
          x: j,
          y: i,
          tip: this.getTip(j, i).serialize()
        });
      }
    }
    return serialized;
  };

  Cpu.prototype.deserialize = function(serializedVal) {
    var serializedTip, tip, _i, _len, _results;
    _results = [];
    for (_i = 0, _len = serializedVal.length; _i < _len; _i++) {
      serializedTip = serializedVal[_i];
      tip = serializedTip.tip.code.name === "WallTip" ? TipFactory.createWallTip(this.sx, this.sy) : serializedTip.tip.code.name === "StartTip" ? TipFactory.createStartTip() : serializedTip.tip.code.name === "EmptyTip" ? TipFactory.createEmptyTip() : serializedTip.tip.code.instruction == null ? this.vm.tipSet.findByCode(serializedTip.tip.code.name).clone() : this.vm.tipSet.findByInst(serializedTip.tip.code.instruction.name).clone();
      tip.deserialize(serializedTip.tip);
      _results.push(this.insertNewTip(serializedTip.x, serializedTip.y, tip));
    }
    return _results;
  };

  Cpu.prototype.save = function(fileName) {
    return this.storage.save(fileName, this.serialize());
  };

  Cpu.prototype.load = function(fileName) {
    return this.deserialize(this.storage.load(fileName));
  };

  Cpu.prototype.getTip = function(x, y) {
    return this.tipTable[y][x];
  };

  Cpu.prototype.setTip = function(x, y, tip) {
    return this.tipTable[y][x] = tip;
  };

  Cpu.prototype.getStartTip = function() {
    return this.getTip(this.sx, this.sy);
  };

  Cpu.prototype.getStartPosition = function() {
    return {
      x: this.sx,
      y: this.sy
    };
  };

  Cpu.prototype.getYnum = function() {
    return this.ynum;
  };

  Cpu.prototype.getXnum = function() {
    return this.xnum;
  };

  Cpu.prototype.isOuter = function(x, y) {
    return y === -1 || x === -1 || y === this.ynum || x === this.xnum;
  };

  Cpu.prototype.isStart = function(x, y) {
    return x === this.sx && y === this.sy;
  };

  Cpu.prototype.isWall = function(x, y) {
    return this.isOuter(x, y) && !this.isStart(x, y);
  };

  Cpu.prototype.isEmpty = function(x, y) {
    return this.getTip(x, y).code instanceof EmptyTip;
  };

  return Cpu;

})(Group);

var Executer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Executer = (function(_super) {
  __extends(Executer, _super);

  Executer.latency = 30;

  function Executer(cpu) {
    this.cpu = cpu;
    this.execNext = __bind(this.execNext, this);
    this.next = null;
    this.current = null;
    this.end = false;
  }

  Executer.prototype.getNext = function() {
    if (this.next != null) {
      return this.cpu.getTip(this.next.x, this.next.y);
    } else {
      return null;
    }
  };

  Executer.prototype._execute = function(tip) {
    if (this.current != null) {
      this.current.hideExecutionEffect();
    }
    this.current = tip;
    this.current.showExecutionEffect();
    if (this.current.isAsynchronous()) {
      this.current.code.instruction.removeEventListener('completeExecution', this.execNext);
      this.current.code.instruction.addEventListener('completeExecution', this.execNext);
    }
    this.next = this.current.execute();
    if (this.next == null) {
      this.current.hideExecutionEffect();
      this.current = null;
    }
    if (!tip.isAsynchronous()) {
      return setTimeout(this.execNext, Executer.latency);
    }
  };

  Executer.prototype.execute = function() {
    var tip;
    this.end = false;
    tip = this.cpu.getStartTip();
    return this._execute(tip);
  };

  Executer.prototype.execNext = function(e) {
    var nextTip;
    if (this.end) {
      if (this.current) {
        return this.current.hideExecutionEffect();
      }
    } else {
      nextTip = this.getNext();
      if ((this.current != null) && this.current.isAsynchronous() && e && (e.params.result != null) && this.current instanceof BranchTransitionCodeTip) {
        this.next = e.params.result ? this.current.code.getConseq() : this.current.code.getAlter();
        nextTip = this.getNext();
      }
      if (nextTip != null) {
        if (nextTip === this.current) {
          console.log("error : invalid execution timing.");
          this.next = this.current.code.getNext();
          nextTip = this.getNext();
        }
        return this._execute(nextTip);
      }
    }
  };

  Executer.prototype.stop = function() {
    return this.end = true;
  };

  return Executer;

})(EventTarget);

var ErrorChecker, ErrorData,
  __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

ErrorChecker = (function() {
  function ErrorChecker() {
    this.init();
  }

  ErrorChecker.prototype.init = function() {
    this.stack = [];
    this.visited = [];
    return this.error = new ErrorData();
  };

  ErrorChecker.prototype.detectError = function(cpu) {
    var start;
    start = cpu.getStartPosition();
    this.init();
    this._dfs(cpu, start);
    return this.error;
  };

  ErrorChecker.prototype._dfs = function(cpu, tipPos) {
    var tip;
    tip = cpu.getTip(tipPos.x, tipPos.y);
    if (tip != null) {
      if (__indexOf.call(this.stack, tip) >= 0) {
        return this._registerCycle(cpu, tip);
      } else {
        this.stack.push(tip);
        this.visited.push(tip);
        if (tip instanceof SingleTransitionCodeTip) {
          this._dfs(cpu.getTip());
        } else if (tip instanceof BranchTransitionCodeTip) {
          this._dfs(tip.getConseq());
          this._dfs(tip.getAlter());
        }
        return this.stack.pop();
      }
    }
  };

  ErrorChecker.prototype._registerCycle = function(cpu, cycleStartTip) {
    var cycle, start;
    start = this.stack.indexOf(cycleStartTip);
    cycle = this.stack.slice(start, this.stack.length - 1);
    return this.error.cycle.push(cycle);
  };

  ErrorChecker.prototype._registerUnreachable = function() {
    var i, j, _i, _ref, _results;
    _results = [];
    for (j = _i = 0, _ref = cpu.getYnum(); 0 <= _ref ? _i < _ref : _i > _ref; j = 0 <= _ref ? ++_i : --_i) {
      _results.push((function() {
        var _j, _ref1, _results1;
        _results1 = [];
        for (i = _j = 0, _ref1 = cpu.getXnum(); 0 <= _ref1 ? _j < _ref1 : _j > _ref1; i = 0 <= _ref1 ? ++_j : --_j) {
          _results1.push(console.log(""));
        }
        return _results1;
      })());
    }
    return _results;
  };

  return ErrorChecker;

})();

ErrorData = (function() {
  function ErrorData() {
    this.cycle = [];
    this.unreachable = [];
  }

  return ErrorData;

})();

var Slider,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Slider = (function(_super) {
  __extends(Slider, _super);

  function Slider(min, max, step, value) {
    var labelPaddingX, labelPaddingY;
    this.min = min;
    this.max = max;
    this.step = step;
    this.value = value;
    Slider.__super__.constructor.call(this, Resources.get("slider"));
    this.titleWidth = 128;
    labelPaddingY = 4;
    labelPaddingX = 12;
    this.knob = new ImageSprite(Resources.get("sliderKnob"));
    this.knob.touchEnabled = false;
    this.label = new TextLabel("");
    this.title = new TextLabel("");
    this.knob.moveTo(0, this.knob.width / 2);
    this.title.moveTo(-this.titleWidth, labelPaddingY);
    this.label.moveTo(this.getWidth() + labelPaddingX, labelPaddingY);
    this.title.width = this.titleWidth;
    this.scroll(this.value);
    this.addChild(this.sprite);
    this.addChild(this.knob);
    this.addChild(this.label);
    this.addChild(this.title);
  }

  Slider.prototype.ontouchstart = function(e) {
    var value, x;
    x = e.x - this.getAbsolutePosition().x;
    value = this.positionToValue(x);
    return this.scroll(value);
  };

  Slider.prototype.ontouchmove = function(e) {
    var value, x;
    x = e.x - this.getAbsolutePosition().x;
    if (x < 0) {
      x = 0;
    }
    if (x > this.getWidth()) {
      x = this.getWidth();
    }
    value = this.positionToValue(x);
    return this.scroll(value);
  };

  Slider.prototype.onValueChanged = function() {
    return this.setText(this.value);
  };

  Slider.prototype.setTitle = function(title) {
    return this.title.text = title;
  };

  Slider.prototype.setValue = function(value) {
    this.value = value;
    return this.onValueChanged();
  };

  Slider.prototype.setText = function(text) {
    return this.label.text = text;
  };

  Slider.prototype.scroll = function(value) {
    var x;
    this.value = this.adjustValue(value);
    x = this.valueToPosition(this.value);
    this.knob.moveTo(x - this.knob.width / 2, this.knob.height / 2);
    return this.onValueChanged();
  };

  Slider.prototype.adjustValue = function(value) {
    var dist, i, nearestDist, nearestValue, _i, _ref, _ref1, _ref2;
    nearestValue = this.min;
    nearestDist = 0xffffffff;
    for (i = _i = _ref = this.min, _ref1 = this.max, _ref2 = this.step; _ref2 > 0 ? _i <= _ref1 : _i >= _ref1; i = _i += _ref2) {
      dist = Math.abs(value - i);
      if (dist < nearestDist) {
        nearestDist = dist;
        nearestValue = i;
      }
    }
    return nearestValue;
  };

  Slider.prototype.valueToPosition = function(value) {
    var range, val, x;
    range = this.max - this.min;
    val = value - this.min;
    return x = this.getWidth() * (val / range);
  };

  Slider.prototype.positionToValue = function(x) {
    var normValue;
    normValue = x / this.getWidth();
    return this.min + normValue * (this.max - this.min);
  };

  return Slider;

})(SpriteGroup);

var SideTipSelector,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SideTipSelector = (function(_super) {
  var VISIBLE_TIP_COUNT;

  __extends(SideTipSelector, _super);

  VISIBLE_TIP_COUNT = 8;

  function SideTipSelector(x, y) {
    var background, tipHeight,
      _this = this;
    SideTipSelector.__super__.constructor.call(this, 160, 500);
    this.moveTo(x, y);
    this.scrollPosition = 0;
    background = new ImageSprite(Resources.get('sidebar'));
    this.addChild(background);
    tipHeight = Resources.get("emptyTip").height;
    this.topArrow = new ImageSprite(Resources.get('arrow'));
    this.topArrow.rotate(-90);
    this.topArrow.moveTo((this.width - this.topArrow.width) / 2, 0);
    this.topArrow.on(Event.TOUCH_START, function() {
      if (_this.scrollPosition <= 0) {
        return;
      }
      _this.scrollPosition -= 1;
      _this.tipGroup.moveBy(0, tipHeight);
      return _this._updateVisibility();
    });
    this.addChild(this.topArrow);
    this.bottomArrow = new ImageSprite(Resources.get('arrow'));
    this.bottomArrow.rotate(90);
    this.bottomArrow.moveTo((this.width - this.bottomArrow.width) / 2, this.height - this.bottomArrow.height);
    this.bottomArrow.on(Event.TOUCH_START, function() {
      if (_this.scrollPosition > _this._getTipCount() - VISIBLE_TIP_COUNT - 1) {
        return;
      }
      _this.scrollPosition += 1;
      _this.tipGroup.moveBy(0, -tipHeight);
      return _this._updateVisibility();
    });
    this.addChild(this.bottomArrow);
    this.createTipGroup();
    this.addChild(this.tipGroup);
  }

  SideTipSelector.prototype.createTipGroup = function() {
    this.tipGroup = new EntityGroup(64, 0);
    this.tipGroup.backgroundColor = '#ff0000';
    return this.tipGroup.moveTo(this.topArrow.x, this.topArrow.y + this.topArrow.height);
  };

  SideTipSelector.prototype.addTip = function(tip) {
    var tipCount, uiTip;
    tipCount = this._getTipCount();
    uiTip = tip.clone();
    if (tipCount >= VISIBLE_TIP_COUNT) {
      uiTip.setVisible(false);
    }
    uiTip.moveTo(8, -6 + tipCount * tip.getHeight());
    return this.tipGroup.addChild(uiTip);
  };

  SideTipSelector.prototype._getTipCount = function() {
    return this.tipGroup.childNodes.length;
  };

  SideTipSelector.prototype._updateVisibility = function() {
    var update,
      _this = this;
    update = function(index, flag) {
      if ((0 <= index && index < _this._getTipCount())) {
        return _this.tipGroup.childNodes[index].setVisible(flag);
      }
    };
    update(this.scrollPosition - 1, false);
    update(this.scrollPosition + VISIBLE_TIP_COUNT, false);
    update(this.scrollPosition, true);
    return update(this.scrollPosition + VISIBLE_TIP_COUNT - 1, true);
  };

  SideTipSelector.prototype.clearTip = function() {
    this.removeChild(this.tipGroup);
    this.createTipGroup();
    this.addChild(this.tipGroup);
    return this.scrollPosition = 0;
  };

  return SideTipSelector;

})(EntityGroup);

var ParameterConfigPanel, ParameterSlider,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ParameterSlider = (function(_super) {
  __extends(ParameterSlider, _super);

  function ParameterSlider(parameter) {
    this.parameter = parameter;
    ParameterSlider.__super__.constructor.call(this, this.parameter.min, this.parameter.max, this.parameter.step, this.parameter.value);
  }

  ParameterSlider.prototype.show = function() {
    this.scroll(this.parameter.getValue());
    return ParameterSlider.__super__.show.call(this);
  };

  ParameterSlider.prototype.setText = function() {
    return ParameterSlider.__super__.setText.call(this, this.parameter.mkLabel());
  };

  ParameterSlider.prototype.onValueChanged = function() {
    this.parameter.setValue(this.value);
    return this.setText(this.parameter.mkLabel());
  };

  return ParameterSlider;

})(Slider);

ParameterConfigPanel = (function(_super) {
  __extends(ParameterConfigPanel, _super);

  function ParameterConfigPanel(target) {
    this.target = target;
    ParameterConfigPanel.__super__.constructor.call(this);
  }

  ParameterConfigPanel.prototype.addParameter = function(parameter) {
    var slider;
    slider = new ParameterSlider(parameter);
    slider.moveTo(slider.titleWidth, this.childNodes.length * slider.getHeight());
    slider.setTitle(parameter.valueName);
    return this.addChild(slider);
  };

  ParameterConfigPanel.prototype.show = function(tip) {
    var backup, i, param, _i, _len, _ref,
      _this = this;
    if ((tip.parameters != null) && tip.parameters.length > 0) {
      backup = {};
      _ref = tip.parameters;
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        param = _ref[i];
        backup[i] = param.getValue();
        if (param._onValueChanged == null) {
          param._onValueChanged = param.onValueChanged;
          param.onValueChanged = function() {
            this._onValueChanged();
            return tip.setDescription(tip.code.mkDescription());
          };
        }
        this.addParameter(param);
      }
      this.target.ui.configPanel.setContent(this);
      this.target.ui.configPanel.show(tip);
      return this.target.ui.configPanel.onClosed = function(closedWithOK) {
        var _j, _len1, _ref1, _results;
        if (closedWithOK) {
          tip.icon = tip.getIcon();
          return tip.setDescription(tip.code.mkDescription());
        } else {
          _ref1 = tip.parameters;
          _results = [];
          for (i = _j = 0, _len1 = _ref1.length; _j < _len1; i = ++_j) {
            param = _ref1[i];
            param.setValue(backup[i]);
            _results.push(param.onParameterComplete());
          }
          return _results;
        }
      };
    }
  };

  return ParameterConfigPanel;

})(SpriteGroup);

var Environment, Octagram, OctagramSet, TipBasedVPL, TipSet,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Environment = (function() {
  function Environment() {}

  Environment.ScreenWidth = 640;

  Environment.ScreenHeight = 640;

  Environment.EditorWidth = 480;

  Environment.EditorHeight = 480;

  Environment.EditorX = 16;

  Environment.EditorY = 16;

  Environment.startX = 4;

  Environment.startY = -1;

  return Environment;

})();

TipSet = (function() {
  function TipSet() {
    this.tips = [];
  }

  TipSet.prototype.clear = function() {
    return this.tips = [];
  };

  TipSet.prototype.addTip = function(tip) {
    return this.tips.push(tip);
  };

  TipSet.prototype.addInstruction = function(inst) {
    var tip;
    tip = TipFactory.createInstructionTip(inst);
    return this.addTip(tip);
  };

  TipSet.prototype.findByInst = function(instName) {
    var tip;
    return ((function() {
      var _i, _len, _ref, _results;
      _ref = this.tips;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tip = _ref[_i];
        if ((tip.code.instruction != null) && tip.code.instruction.constructor.name === instName) {
          _results.push(tip);
        }
      }
      return _results;
    }).call(this))[0];
  };

  TipSet.prototype.findByCode = function(codeName) {
    var tip;
    return ((function() {
      var _i, _len, _ref, _results;
      _ref = this.tips;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        tip = _ref[_i];
        if (tip.code.constructor.name === codeName) {
          _results.push(tip);
        }
      }
      return _results;
    }).call(this))[0];
  };

  return TipSet;

})();

OctagramSet = (function() {
  function OctagramSet(x, y, xnum, ynum) {
    this.x = x;
    this.y = y;
    this.xnum = xnum;
    this.ynum = ynum;
    this.octagrams = {};
    this.currentInstance = null;
  }

  OctagramSet.prototype.createInstance = function() {
    var instance;
    instance = new Octagram(this.x, this.y, this.xnum, this.ynum);
    this.octagrams[instance.id] = instance;
    return instance;
  };

  OctagramSet.prototype.removeInstance = function(id) {};

  OctagramSet.prototype.getInstance = function(id) {
    return this.octagrams[id];
  };

  OctagramSet.prototype.show = function(id) {
    if (this.currentInstance) {
      this.currentInstance.hide();
    }
    this.currentInstance = this.octagrams[id];
    return this.currentInstance.show();
  };

  return OctagramSet;

})();

Octagram = (function(_super) {
  __extends(Octagram, _super);

  function Octagram(x, y, xnum, ynum) {
    var back, selector;
    Octagram.__super__.constructor.call(this);
    this.id = uniqueID();
    this.tipSet = new TipSet();
    this.userInstructions = [];
    this.cpu = new Cpu(x + 12, y + 12, xnum, ynum, Environment.startX, this);
    this.executer = new Executer(this.cpu);
    back = new TipBackground(x, y, xnum, ynum);
    this.ui = {};
    this.ui.frame = new Frame(0, 0);
    this.ui.help = new HelpPanel(0, Environment.EditorHeight + y, Environment.ScreenWidth, Environment.ScreenWidth - Environment.EditorWidth - x, "");
    selector = new ParameterConfigPanel(Environment.EditorWidth + x / 2, 0);
    this.ui.side = new SideTipSelector(Environment.EditorWidth + x / 2, 0);
    this.ui.configPanel = new UIPanel(selector);
    this.ui.configPanel.setTitle(TextResource.msg.title["configurator"]);
    selector.parent = this.ui.configPanel;
    this.addChild(back);
    this.addChild(this.cpu);
    this.addChild(this.ui.frame);
    this.addChild(this.ui.side);
    this.addChild(this.ui.help);
    this.addPresetInstructions();
  }

  Octagram.prototype.addInstruction = function(instruction) {
    this.tipSet.addInstruction(instruction);
    return this.userInstructions.push(instruction);
  };

  Octagram.prototype.addUserInstructions = function() {
    var instruction, _i, _len, _ref, _results;
    _ref = this.userInstructions;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      instruction = _ref[_i];
      _results.push(this.tipSet.addInstruction(instruction));
    }
    return _results;
  };

  Octagram.prototype.addPresetInstructions = function() {
    var counters, i, inst, nopTip, returnTip, stack, stopTip, _i;
    stack = new StackMachine();
    counters = [];
    for (i = _i = 0; _i < 100; i = ++_i) {
      counters[i] = new Counter();
    }
    returnTip = TipFactory.createReturnTip(Environment.startX, Environment.startY);
    stopTip = TipFactory.createStopTip();
    nopTip = TipFactory.createNopTip();
    inst = new RandomBranchInstruction();
    this.tipSet.addInstruction(inst, Resources.get("iconRandom"));
    this.tipSet.addTip(returnTip);
    this.tipSet.addTip(stopTip);
    this.tipSet.addTip(nopTip, Resources.get("iconNop"));
    this.tipSet.addInstruction(new CounterIncrementInstruction(counters), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new CounterDecrementInstruction(counters), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new CounterBranchInstruction(counters), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new CounterPushInstruction(counters, stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new CounterPopInstruction(counters, stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackAddInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackSubInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackMulInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackDivInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackModInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackXorInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackGrtInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackSwpInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackNotInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackDupInstruction(stack), Resources.get("iconRandom"));
    this.tipSet.addInstruction(new StackRotInstruction(stack), Resources.get("iconRandom"));
    return this.tipSet.addInstruction(new StackBnzInstruction(stack), Resources.get("iconRandom"));
  };

  Octagram.prototype.clearInstructions = function() {
    return this.tipSet.clear();
  };

  Octagram.prototype.load = function(filename) {
    return this.cpu.load(filename);
  };

  Octagram.prototype.save = function(filename) {
    return this.cpu.save(filename);
  };

  Octagram.prototype.execute = function() {
    return this.executer.execute();
  };

  Octagram.prototype.stop = function() {
    return this.executer.stop();
  };

  Octagram.prototype.setTipToBar = function() {
    var tip, _i, _len, _ref, _results;
    this.clearInstructions();
    this.ui.side.clearTip();
    this.addUserInstructions();
    this.addPresetInstructions();
    _ref = this.tipSet.tips;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      tip = _ref[_i];
      _results.push(this.ui.side.addTip(tip));
    }
    return _results;
  };

  Octagram.prototype.show = function() {
    this.setTipToBar();
    return Game.instance.currentScene.addChild(this);
  };

  Octagram.prototype.hide = function() {
    return Game.instance.currentScene.removeChild(this);
  };

  return Octagram;

})(Group);

TipBasedVPL = (function(_super) {
  __extends(TipBasedVPL, _super);

  function TipBasedVPL(w, h, resourceBase) {
    TipBasedVPL.__super__.constructor.call(this, w, h);
    this.fps = 24;
    this.octagrams = new OctagramSet(16, 16, 8, 8);
    Resources.base = resourceBase;
    Resources.load(this);
  }

  TipBasedVPL.prototype.onload = function() {
    var x, xnum, y, ynum;
    x = 16;
    y = 16;
    xnum = 8;
    ynum = 8;
    Game.instance.vpl = {};
    return Game.instance.vpl.currentVM = new Octagram(x, y, xnum, ynum);
  };

  return TipBasedVPL;

})(Game);
