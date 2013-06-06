       
( ->
    s = document.getElementsByTagName("script")
    d = s[s.length-1].src.substring(0, s[s.length-1].src.lastIndexOf("/")+1)
    for arg in arguments
        document.write('<script type="text/javascript" src="'+d+arg+'"></script>')
)(
    "third_party/underscore-min.js",
    "config.js",
    "utility/debug.js",
    "utility/util.js",
    "enchantAI/instruction.js",
    "effect.js",
    "bullet.js",
    "item.js",
    "robot.js",
    "view.js",
    "main.js"
)

