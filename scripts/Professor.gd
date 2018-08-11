extends Area2D

var speed = 300
var vel = Vector2()

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	var input = Vector2(0, 0)
	input.x = Input.is_key_pressed(KEY_D) - Input.is_key_pressed(KEY_A)
	vel = input.normalized() * speed
	var pos = get_pos() + vel * delta
	set_pos(pos)