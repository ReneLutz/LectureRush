extends KinematicBody2D

enum { STANDING, WALKING }
const WALK_SPEED = 80

onready var sprite = get_node("AnimatedSprite")

var velocity = Vector2()
var animation = STANDING

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	if (Input.is_key_pressed(KEY_A)):
		velocity.x = -WALK_SPEED
		animation = WALKING
	elif (Input.is_key_pressed(KEY_D)):
		velocity.x =  WALK_SPEED
		animation = WALKING
	else:
		velocity.x = 0
		animation = STANDING
	
	var motion = velocity * delta
	
	if(animation == STANDING):
		sprite.play("Idle")
	else:
		sprite.play("Walking")
	move(motion)
	
#func :
#	pass	