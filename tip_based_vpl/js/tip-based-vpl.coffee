( ->
    s = document.getElementsByTagName("script")
    d = s[s.length-1].src.substring(0, s[s.length-1].src.lastIndexOf("/")+1)
    for arg in arguments
        document.write('<script type="text/javascript" src="'+d+arg+'"></script>')
)(
	"vpl/util/storage.js",
	"vpl/event/event.js",
	"vpl/ui/sprite-group.js",
	"vpl/tip/tip-model.js",
	"vpl/tip/instruction/tip-instruction.js",
	"vpl/test.js",
	"vpl/util/util.js",
	"vpl/resource.js",
	"vpl/tip/tip-effect.js",
	"vpl/tip/transition.js",
	"vpl/tip/tip-view.js",
	"vpl/tip/tip-icon.js",
	"vpl/tip/tip-parameter.js",
	"vpl/tip/tip-factory.js",
	"vpl/tip/instruction/instruction-preset.js",
	"vpl/tip/instruction/tip-instruction-stack.js",
	"vpl/tip/instruction/tip-instruction-counter.js",
	"vpl/ui/background.js",
	"vpl/cpu/cpu.js",
	"vpl/cpu/cpu-executer.js",
	"vpl/ui/slider.js",
	"vpl/ui/sidebar.js",
	"vpl/ui/config-panel.js",
	"vpl/ui/ui.js",
	"vpl/main.js"
)
