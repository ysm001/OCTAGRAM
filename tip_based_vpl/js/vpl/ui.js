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
