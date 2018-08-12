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
	updatePointer()

func getPanic():
	return panic

func updatePointer():
	panicPointer.set_rotd(90 - panic * 180)

func _ready():
	panicPointer = get_node("PanicPointer")
