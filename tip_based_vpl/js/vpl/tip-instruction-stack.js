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
