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
