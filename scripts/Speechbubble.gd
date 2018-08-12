extends RichTextLabel

var text

func _ready():
	pass

func setText(sentence):
	text = sentence
	var timer = get_node("Timer")
	timer.start()
	
func _on_Timer_timeout():
	print("hi")
	set_visible_characters(get_visible_characters() + 1)
