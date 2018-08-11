extends KinematicBody2D

const WALK_SPEED = 80
const STANDING = "Standing"
const WALKING = "Walking"

onready var sprite = get_node("AnimatedSprite")

var velocity = Vector2()
var animation = STANDING

#Current mood level
var mood = 100;

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	# Set walking direction
	if (Input.is_key_pressed(KEY_A)):
		velocity.x = -WALK_SPEED
		animation = WALKING
	elif (Input.is_key_pressed(KEY_D)):
		velocity.x =  WALK_SPEED
		animation = WALKING
	else:
		velocity.x = 0
		animation = STANDING
	
	# Play walking / standing animation
	if(animation == STANDING):
		sprite.play(STANDING)
	else:
		sprite.play(WALKING)
	
	var motion = velocity * delta
	move(motion)
	
func setMood(level):
	mood = level;