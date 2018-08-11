extends Area2D

export var mood_bonus = 15
var is_used = false

func _ready():
	pass

func _input_event(viewport, event, shape_idx):
	if event.type == InputEvent.MOUSE_BUTTON and \
			event.button_index == BUTTON_LEFT and \
			event.pressed:
		on_click()

func on_click():
	if not is_used:
		print(get_node("../../../Professor").get_name())
		get_tree().get_root().get_node("Professor/profBody").changeMood(mood_bonus)
		is_used = true
	print("Gadse!")