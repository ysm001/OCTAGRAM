class TipUtil 
  @tipToImage : (code) ->
    assetName = 
      if      code instanceof EmptyTip  then "emptyTip" 
      else if code instanceof ReturnTip then "returnTip" 
      else if code instanceof StartTip  then "startTip" 
      else if code instanceof StopTip   then "stopTip" 
      else if code instanceof ActionTip then "actionTip" 
      else if code instanceof BranchTip then "branchTip" 
      else if code instanceof WallTip   then "wallTip" 

    Resources.get(assetName)

  @tipToMessage : (code) ->
     if      code instanceof EmptyTip  then TextResource.msg["empty"]
     else if code instanceof ReturnTip then TextResource.msg["return"] 
     else if code instanceof StartTip  then TextResource.msg["start"]
     else if code instanceof StopTip   then TextResource.msg["stop"]
     else if code instanceof ActionTip then TextResource.msg["action"] 
     else if code instanceof BranchTip then TextResource.msg["branch"]
     else if code instanceof WallTip   then TextResource.msg["wall"]

class LayerUtil
  @setOrder : (obj, order) ->
    obj._element = document.createElement("div")
    obj._element.style.zIndex = order

class EventUtil
  createEvent : (eventName) ->
    evt = document.createEvent('UIEvent', false)
    evt.initUIEvent(eventName, true, true)
    evt

clone = (src) ->
  if src?
    if src.constructor is String then return src
    ret = 
      if src.constructor is Array then []
      else if src.constructor is Object then {}
      else src#src.constructor()
    #if !ret? then ret = src

    for key of src
      ret[key] = clone(src[key])

    ret
