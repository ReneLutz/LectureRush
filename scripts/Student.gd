extends AnimatedSprite

export var walkSpeed = 1

var walkHorizontal = true

var room

func _ready():
	room = get_tree().get_nodes_in_group("lectureRoom")

func _fixed_process(delta):
	if(Input.is_action_pressed("turn_left")):
		pass
	if(Input.is_action_pressed("turn_right")):
		pass
	