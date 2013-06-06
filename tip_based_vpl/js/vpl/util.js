// Generated by CoffeeScript 1.6.2
var EventUtil, LayerUtil, TipUtil, clone;

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

LayerUtil = (function() {
  function LayerUtil() {}

  LayerUtil.setOrder = function(obj, order) {
    if (obj._element == null) {
      obj._element = document.createElement("div");
    }
    return obj._element.style.zIndex = order;
  };

  return LayerUtil;

})();

EventUtil = (function() {
  function EventUtil() {}

  EventUtil.prototype.createEvent = function(eventName) {
    var evt;

    evt = document.createEvent('UIEvent', false);
    evt.initUIEvent(eventName, true, true);
    return evt;
  };

  return EventUtil;

})();

clone = function(src) {
  var key, ret;

  if (src != null) {
    if (src.constructor === String) {
      return src;
    }
    ret = src.constructor === Array ? [] : src.constructor === Object ? {} : src;
    for (key in src) {
      ret[key] = clone(src[key]);
    }
    return ret;
  }
};
