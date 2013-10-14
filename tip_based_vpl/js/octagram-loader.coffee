( ->
    s = document.getElementsByTagName("script")
    d = s[s.length-1].src.substring(0, s[s.length-1].src.lastIndexOf("/")+1)
    for arg in arguments
        document.write('<script type="text/javascript" src="'+d+arg+'"></script>')
)(
	"octagram/util/storage.js",
	"octagram/event/event.js",
	"octagram/ui/sprite-group.js",
	"octagram/effect.js",
	"octagram/tip/tip-model.js",
	"octagram/tip/instruction/tip-instruction.js",
	"octagram/test.js",
	"octagram/util/util.js",
	"octagram/resource.js",
	"octagram/tip/tip-effect.js",
	"octagram/tip/transition.js",
	"octagram/tip/tip-view.js",
	"octagram/tip/tip-icon.js",
	"octagram/tip/tip-parameter.js",
	"octagram/tip/tip-factory.js",
	"octagram/tip/instruction/instruction-preset.js",
	"octagram/tip/instruction/tip-instruction-stack.js",
	"octagram/tip/instruction/tip-instruction-counter.js",
	"octagram/ui/background.js",
	"octagram/cpu/cpu.js",
	"octagram/cpu/cpu-executer.js",
	"octagram/ui/slider.js",
	"octagram/ui/sidebar.js",
	"octagram/ui/config-panel.js",
	"octagram/ui/ui.js",
	"octagram/ui/direction-selector.js",
	"octagram/environment.js"
	"octagram/octagram.js"
	"octagram/main.js"
)
