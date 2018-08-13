extends KinematicBody2D

export var speed = 150

func _ready():
	set_fixed_process(true)
	get_node("SamplePlayer").play("fly%s" % (randi() % 2 + 1))
	
func _fixed_process(delta):
	move(Vector2(0, int(speed * delta)))
	if get_pos().y > get_viewport_rect().size.height + 40:
		queue_free()
	elif is_colliding():
		var possible_prof = get_collider()
		if possible_prof.get_name() == "profBody":
			possible_prof.setMood(0)
		queue_free()
