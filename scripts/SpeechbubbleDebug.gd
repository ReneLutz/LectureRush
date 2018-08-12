extends Node

var counter = 0

var dialogBoxInstance

func _ready():
	pass

func _on_SpeechbubbleDebug_timeout():
	if(counter == 0):
		var dialogBoxScene = load("res://scenes/objects/speechbubble.tscn")
		dialogBoxInstance = dialogBoxScene.instance()
		dialogBoxInstance.set_pos(Vector2(450, 350))
		
		var textLabelNode = dialogBoxInstance.get_node("Polygon2D/RichTextLabel")

		textLabelNode.setText("This is an extra long text message for testing purpose only: Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua.")
		textLabelNode.set_scroll_follow(true)
		
		add_child(dialogBoxInstance)
	elif(counter == 3):
		dialogBoxInstance.queue_free()
	
	counter += 1