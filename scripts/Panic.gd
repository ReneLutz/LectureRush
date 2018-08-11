extends Sprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var panic = 0.0 setget setPanic, getPanic
var height = 80
var text = 145
var all = 700

func setPanic(var p):
	panic = p
	if panic < 0.0:
		panic = 0.0
	if panic > 1.0:
		panic = 1.0
	updateBar()

func getPanic():
	return panic

func updateBar():
	var add = (all-text)*panic
	set_region_rect(Rect2(0,0,text+add,height))

func _process(delta):
	setPanic( panic+0.001 )

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process(true)
	pass
