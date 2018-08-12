extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var panic = 0.0 setget setPanic, getPanic

var panicPointer

func setPanic(var p):
	panic = p
	if panic < 0.0:
		panic = 0.0
	if panic > 1.0:
		panic = 1.0

func getPanic():
	return panic

func _process(delta):
	panicPointer.set_rotd(180 - panic * 180 + pow(panic, 5) * 2 * sin(panic * OS.get_ticks_msec()))

func _ready():
	set_process(true)
	panicPointer = get_node("PanicPointer")
