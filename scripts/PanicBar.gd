extends AnimatedSprite

var panic = 0.0 setget setPanic, getPanic

var fill

func setPanic(var p):
	if panic < 1:
		panic = clamp(p, 0.0, 1.0)

func getPanic():
	return panic

func _process(delta):
	fill.set_scale(Vector2(1 + panic * 146, fill.get_scale().y))

func _ready():
	set_process(true)
	play("Init")
	connect("finished", self, "loopAnim")
	fill = get_node("Fill")
	
func loopAnim():
	play("Loop")
