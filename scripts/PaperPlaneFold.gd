extends AnimatedSprite

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("SamplePlayer").play("paperplane_folding")
	
func spawnPlane():
	var scenePlane = load("res://scenes/objects/paper_plane.tscn")
	var scenePlaneInstance = scenePlane.instance()
	scenePlaneInstance.set_name("paper_plane")
	# set position
	scenePlaneInstance.set_pos(get_pos())
	get_parent().add_child(scenePlaneInstance)


func _on_Timer_timeout():
	spawnPlane()
	queue_free()
