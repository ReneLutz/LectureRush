extends RichTextLabel


func _ready():
	pass

func setText(text):
	set_bbcode(text)
	set_visible_characters(0)
	
	var timer = get_node("Timer")
	timer.start()
	
func _on_Timer_timeout():
	set_visible_characters(get_visible_characters() + 1)
