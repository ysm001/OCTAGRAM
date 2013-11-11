   
( ->
  s = document.getElementsByTagName("script")
  d = s[s.length-1].src.substring(0, s[s.length-1].src.lastIndexOf("/")+1)
  for arg in arguments
    document.write('<script type="text/javascript" src="'+d+arg+'"></script>')
)(
  "third_party/mt.js",
  "config.js",
  "utility/util.js",
  "utility/debug.js",
  "effect.js",
  "bullet.js",
  "item.js",
  "robot.js",
  "octagram_instruction/common.js",
  "octagram_instruction/approach-instruction.js",
  "octagram_instruction/leave-instruction.js",
  "octagram_instruction/move-instruction.js"
  "octagram_instruction/random-move-instruction.js"
  "octagram_instruction/shot-instruction.js",
  "octagram_instruction/supply-instruction.js",
  "octagram_instruction/turn-enemy-scan-instruction.js",
  "octagram_instruction/energy-branch-instruction.js",
  "octagram_instruction/enemy-energy-branch-instruction.js",
  "octagram_instruction/enemy-distance-instruction.js",
  "octagram_instruction/hp-branch-instruction.js",
  "octagram_instruction/resource-branch-instruction.js",
  "view/view.js",
  "view/header/hp-view.js",
  "view/header/energy-view.js",
  "view/header/header-view.js",
  "view/header/timer-view.js",
  "view/content/content-view.js",
  "view/footer/footer-view.js",
  "main.js"
)

