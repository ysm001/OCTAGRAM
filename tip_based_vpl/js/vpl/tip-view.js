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
