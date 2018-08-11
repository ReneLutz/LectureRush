extends KinematicBody2D

const WALK_SPEED = Vector2(80, 40)
const STANDING = "Standing"
const WALKING = "Walking"

onready var sprite = get_node("AnimatedSprite")

var velocity = Vector2()

#Current mood level
var mood = 100;
var maxMood = 100;
var panicUI = null

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	
	var acceleration = Vector2((Input.is_key_pressed(KEY_D) - Input.is_key_pressed(KEY_A)), 
								(Input.is_key_pressed(KEY_S) - Input.is_key_pressed(KEY_W)))
	
	# Play walking animation
	if((acceleration.x != 0) || (acceleration.y != 0)):
		sprite.play(WALKING)
	else:
		sprite.play(STANDING)
	
	# Move professor
	var motion = Vector2(WALK_SPEED.x * acceleration.x, WALK_SPEED.y * acceleration.y) * delta
	move(motion)
	
func setPanicUI(p):
	panicUI = p

func setMood(level):
	mood = level
	if panicUI != null:
		panicUI.panic = (maxMood-mood)/maxMood
	print("Prof's mood set to %s." % str(level))
	
func changeMood(increase):
	mood += increase
	print("Prof's mood %s by %s (%s)." % ["increased" if increase >= 0 else "decreased", str(abs(increase)), str(mood)])