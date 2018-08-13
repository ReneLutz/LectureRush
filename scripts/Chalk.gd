extends KinematicBody2D

const FLIGHT_SPEED = 500
const OFFSET = Vector2(15, -20)

var target = Vector2(0, 0)
var start = Vector2(0, 0)
var timeLeft = 0
var flight_time = 0
var isSponge = false


func _ready():
	set_process(true)
	set_fixed_process(false)
	get_node("SamplePlayer").play("chalk")
	if get_node("../Professor/profBody").has_node("sponge"):
		get_node("../Professor/profBody/sponge").queue_free()
		get_node("AnimatedSprite").play("Sponge")
		get_node("SamplePlayer").play("sponge")
		
func init(start_pos, target_pos):
	start = start_pos + OFFSET
	target = target_pos
	flight_time = (target - start).length() / FLIGHT_SPEED
	timeLeft = flight_time
	
func _process(delta):
	timeLeft -= delta
	if timeLeft <= 0:
		queue_free()
	else:
		set_pos(target + (timeLeft / flight_time) * (start - target))


	
