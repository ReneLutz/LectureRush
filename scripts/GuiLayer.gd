extends CanvasLayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Gui/ButtonMenu").connect("button_up",get_parent(),"endGame")
	get_node("Gui/ButtonRestart").connect("button_up",get_parent(),"restartGame")
	pass
