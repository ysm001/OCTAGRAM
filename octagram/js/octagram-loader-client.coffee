( ->
    window.octagram = {}
    s = document.getElementsByTagName("script")
    d = s[s.length-1].src.substring(0, s[s.length-1].src.lastIndexOf("/")+1)
    for arg in arguments
        document.write('<script type="text/javascript" src="'+d+arg+'"></script>')
)(
	"core/tip/instruction/tip-instruction.js",
  "core/test.js",
  "core/tip/tip-icon.js",
	"core/tip/tip-parameter.js",
  'core/octagram.js'
)

