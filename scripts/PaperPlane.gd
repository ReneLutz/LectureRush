extends KinematicBody2D

const SPEED = 150

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	move(Vector2(0, int(SPEED * delta)))
	if is_colliding():
		var possible_prof = get_collider()
		if possible_prof.get_name() == "profBody":
			possible_prof.setMood(0)
		queue_free()
