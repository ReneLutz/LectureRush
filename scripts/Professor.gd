extends KinematicBody2D

const WALK_SPEED = 80

var velocity = Vector2()

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	if (Input.is_key_pressed(KEY_A)):
		velocity.x = -WALK_SPEED
	elif (Input.is_key_pressed(KEY_D)):
		velocity.x =  WALK_SPEED
	else:
		velocity.x = 0
	
	var motion = velocity * delta
	move(motion)
	
#func :
#	pass	