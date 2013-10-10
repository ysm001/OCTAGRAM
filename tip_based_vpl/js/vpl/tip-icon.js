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
