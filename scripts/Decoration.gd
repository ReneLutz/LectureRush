extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var decoration_themes = [["Starry Night", "Easle 1", "Easle 2", "Colour Palette"], ["Periodic Table", "Chemistry Rack"]]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	theme_choice()

func theme_choice():
	randomize()
	var theme_index = randi() % decoration_themes.size()
	var theme = decoration_themes[theme_index]
	for item in theme:
		get_node(item).show()
		print("HILFEEEEEEEEEE")
