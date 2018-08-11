extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func _on_PaperPlaneDebug_timeout():
	var scenePlane = load("res://scenes/objects/paper_plane.tscn")
	var scenePlaneInstance = scenePlane.instance()
	scenePlaneInstance.set_name("paper_plane")
	# set position
	var x = randi() % int(get_viewport().get_rect().size.width)
	var y = 32
	scenePlaneInstance.set_pos(Vector2(x, y))
		
	add_child(scenePlaneInstance)
