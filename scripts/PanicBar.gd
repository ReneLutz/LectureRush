extends AnimatedSprite

var panic = 0.0 setget setPanic, getPanic

var fill

var blinkTimer = 0.0
export var blinkDuration = 0.4
var showFill = true

func setPanic(var p):
	if panic < 1:
		panic = clamp(p, 0.0, 1.0)

func getPanic():
	return panic
	
func _process(delta):
	fill.set_scale(Vector2(1 + panic * 146, fill.get_scale().y))
	_blinkBar(delta)

func _ready():
	set_process(true)
	play("Init")
	connect("finished", self, "loopAnim")
	fill = get_node("Fill")
	
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
		
