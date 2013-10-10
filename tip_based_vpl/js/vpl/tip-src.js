var ActionInstruction, ActionTip, BranchInstruction, BranchTip, BranchTransitionCodeTip, CodeTip, Counter, CounterBranchInstruction, CounterDecrementInstruction, CounterIncrementInstruction, CounterPopInstruction, CounterPushInstruction, CustomInstructionActionTip, CustomInstructionBranchTip, Direction, EmptyTip, ExecutionEffect, Icon, Instruction, JumpTransitionCodeTip, NopTip, Point, ReturnTip, SelectedEffect, SingleTransitionCodeTip, SingleTransitionTip, StackAddInstruction, StackBnzInstruction, StackDivInstruction, StackDupInstruction, StackGrtInstruction, StackMachine, StackModInstruction, StackMulInstruction, StackNotInstruction, StackRotInstruction, StackSubInstruction, StackSwpInstruction, StackXorInstruction, StartTip, StopTip, ThinkTip, Tip, TipFactory, TipParameter, WallTip,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __slice = [].slice;

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
