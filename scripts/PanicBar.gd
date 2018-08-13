extends AnimatedSprite

const PANIC_ANIM_TIME = 0.3 # seconds

var panic = 0.0 setget setPanic, getPanic

var fill

var lastPanicChange
var lastPanicLevel = 0
var hasReachedTargetFill = true

func setPanic(var p):
	if panic < 1:
		lastPanicChange = OS.get_ticks_msec()
		if hasReachedTargetFill:
			lastPanicLevel = panic
		panic = clamp(p, 0.0, 1.0)

func getPanic():
	return panic

func _process(delta):
	var targetScale = 1 + panic * 146
	var currentScale = fill.get_scale()
	
	var startScale = 1 + lastPanicLevel * 146
	var prog = min(1, (OS.get_ticks_msec() - lastPanicChange) / 1000.0 / PANIC_ANIM_TIME)
	#print("%f, %f, %f" % [startScale, targetScale, prog])
	if prog == 1:
		lastPanicLevel = panic
		hasReachedTargetFill = true
	else:
		fill.set_scale(Vector2(
			lerp(startScale, targetScale, prog),
			currentScale.y))

func _ready():
	set_process(true)
	play("Init")
	connect("finished", self, "loopAnim")
	fill = get_node("Fill")
	lastPanicChange = OS.get_ticks_msec() - PANIC_ANIM_TIME
	
func loopAnim():
	play("Loop")
