   
( ->
  s = document.getElementsByTagName("script")
  d = s[s.length-1].src.substring(0, s[s.length-1].src.lastIndexOf("/")+1)
  for arg in arguments
    document.write('<script type="text/javascript" src="'+d+arg+'"></script>')
)(
  "utility.js"
  "config.js"
  "maze/maze.js"
  "maze/map/map-element.js"
  "maze/map/map.js"
  "maze/player.js"
  "octagram_instruction/common.js"
  "octagram_instruction/straight-move-instruction.js"
  "octagram_instruction/turn-instruction.js"
  "octagram_instruction/check-map-instruction.js"
  "main.js"
)

