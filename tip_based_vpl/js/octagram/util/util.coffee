class TipUtil 
  @tipToImage : (code) ->
    assetName = 
      if      code instanceof EmptyTip  then "emptyTip" 
      else if code instanceof ReturnTip then "returnTip" 
      else if code instanceof StartTip  then "startTip" 
      else if code instanceof StopTip   then "stopTip" 
      else if code instanceof ActionTip then "actionTip" 
      else if code instanceof BranchTip then "branchTip" 
      else if code instanceof ThinkTip  then "thinkTip" 
      else if code instanceof WallTip   then "wallTip" 

    Resources.get(assetName)

  @tipToIcon : (code) ->
    if code instanceof NopTip then Resources.get("iconNop")

  @tipToMessage : (code) ->
     if      code instanceof EmptyTip  then TextResource.msg["empty"]
     else if code instanceof ReturnTip then TextResource.msg["return"] 
     else if code instanceof StartTip  then TextResource.msg["start"]
     else if code instanceof StopTip   then TextResource.msg["stop"]
     else if code instanceof ActionTip then TextResource.msg["action"] 
     else if code instanceof BranchTip then TextResource.msg["branch"]
     else if code instanceof WallTip   then TextResource.msg["wall"]
     else if code instanceof NopTip    then TextResource.msg["nop"]

class Vector
  @angle : (src, dst) ->
    dx = dst.x - src.x
    dy = dst.y - src.y
    cos = dx / Math.sqrt(dx*dx + dy*dy)
      
    theta = Math.acos(cos) * 180 / Math.PI
    if dy < 0 then theta *= -1
    theta

uniqueID = () ->
  randam = Math.floor(Math.random()*1000)
  date = new Date()
  time = date.getTime()
  randam + time.toString()
