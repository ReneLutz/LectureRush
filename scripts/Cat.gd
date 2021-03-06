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
		get_tree().get_current_scene().get_node("Game/Professor/profBody").changeMood(mood_bonus)
		is_used = true
		get_node("SamplePlayer").play("cat_meow")
		get_tree().get_current_scene().get_node("Game").setColorFeedbackGreen()
