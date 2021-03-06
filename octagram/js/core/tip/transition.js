// Generated by CoffeeScript 1.6.3
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
    if (this.src && this.dst) {
      this.link(this.src, this.dst);
    }
    this.parent = null;
    this.touchEnabled = false;
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

  TipTransition.prototype.onTouchMove = function(e) {
    var dir, dst, nx, ny, src, srcIdx, theta, tip;
    this.parent = this.parent || this.topGroup();
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
    dst = this.parent.cpu.getTip(nx, ny);
    if (dst !== this.dst) {
      this.dst = dst;
      if (this.src.setConseq != null) {
        if (this instanceof AlterTransition) {
          this.src.setAlter(nx, ny, dst);
        } else {
          this.src.setConseq(nx, ny, dst);
        }
      } else {
        this.src.setNext(nx, ny, dst);
      }
      return this.dispatchEvent(new Event('changeTransition'));
    }
  };

  TipTransition.prototype.hide = function(parent) {
    return this.parentNode.removeChild(this);
  };

  TipTransition.prototype.show = function(parent) {
    return parent.addChild(this);
  };

  return TipTransition;

})(GroupedSprite);

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

octagram.TipTransition = TipTransition;

octagram.NormalTransition = NormalTransition;

octagram.AlterTransition = AlterTransition;
