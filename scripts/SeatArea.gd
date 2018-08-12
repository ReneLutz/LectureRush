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
			event.button_index == BUTTON_RIGHT and \
			event.pressed: #??
		on_click(event.pos) # Event Position wird übermittelt
		
func on_click(targetPos):
	var sceneChalk = load("res://scenes/objects/chalk.tscn")
	var sceneChalkInstance = sceneChalk.instance()
	sceneChalkInstance.set_name("chalk")
	# set position
	var profPos = get_node("../Professor/profBody").get_pos()
	profPos += get_node("../Professor").get_pos()
	sceneChalkInstance.init(profPos, targetPos)
	get_parent().add_child(sceneChalkInstance)
	
	
	