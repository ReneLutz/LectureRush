extends KinematicBody2D

const SPEED = 150

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	move(Vector2(0, int(SPEED * delta)))
