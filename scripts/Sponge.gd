extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON and \
			event.button_index == BUTTON_LEFT and \
			event.pressed: #??
		on_click() 
		
func on_click():
	hide()
	print("Sponge clicked")
	var sceneSponge = load("res://scenes/objects/sponge.tscn") #"Klasse"
	var sceneSpongeInstance = sceneSponge.instance() #"Objekt"
	sceneSpongeInstance.set_name("sponge")
	# set position
	get_node("../Professor/profBody").add_child(sceneSpongeInstance)
	sceneSpongeInstance.set_pos(Vector2(20, 5))
	
