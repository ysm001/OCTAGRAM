   
( ->
  s = document.getElementsByTagName("script")
  d = s[s.length-1].src.substring(0, s[s.length-1].src.lastIndexOf("/")+1)
  for arg in arguments
    document.write('<script type="text/javascript" src="'+d+arg+'"></script>')
)(
  "third_party/underscore-min.js",
  "third_party/mt.js",
  "config.js",
  "utility/util.js",
  "utility/debug.js",
  "effect.js",
  "bullet.js",
  "item.js",
  "robot.js",
  "enchantAI/instr.js",
  "view.js",
  "main.js"
)

