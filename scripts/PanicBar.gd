extends AnimatedSprite

const PANIC_ANIM_TIME = 0.3 # seconds

var panic = 0.0 setget setPanic, getPanic

var fill

var blinkTimer = 0.0
export var blinkDuration = 0.4
var showFill = true

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
	fill.set_scale(Vector2(1 + panic * 146, fill.get_scale().y))
	_blinkBar(delta)
	
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
	
func _blinkBar(delta):
	if fill.get_scale().x >= 110:
		blinkTimer += delta
		if blinkTimer >= blinkDuration:
			blinkTimer = 0.0
			showFill = !showFill
			if showFill:
				fill.hide()
			else:
				fill.show()
		
