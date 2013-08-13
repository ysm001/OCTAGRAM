( ->
    s = document.getElementsByTagName("script")
    d = s[s.length-1].src.substring(0, s[s.length-1].src.lastIndexOf("/")+1)
    for arg in arguments
        document.write('<script type="text/javascript" src="'+d+arg+'"></script>')
)(
	"vpl/storage.js",
	"vpl/sprite.group.js",
	"vpl/tip.model.js",
	"vpl/tip.instruction.js",
	"vpl/test.js",
	"vpl/util.js",
	"vpl/resource.js",
	"vpl/tip.effect.js",
	"vpl/transition.js",
	"vpl/tip.view.js",
	"vpl/tip.icon.js",
	"vpl/tip.parameter.js",
	"vpl/tip.factory.js",
	"vpl/instruction.preset.js",
	"vpl/tip.instruction.stack.js",
	"vpl/tip.instruction.counter.js",
	"vpl/ui.js",
	"vpl/background.js",
	"vpl/cpu.js",
	"vpl/cpu.executer.js",
	"vpl/error-checker.js",
	"vpl/ui.slider.js",
	"vpl/ui.sidebar.js",
	"vpl/ui.config.js",
	"vpl/main.js"
)
