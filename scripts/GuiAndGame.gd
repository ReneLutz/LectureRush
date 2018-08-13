extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const Game = preload("res://scenes/levels/Game.tscn")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Control/Button").connect("button_up",self,"playPressed")

func playPressed():
	print("pressed")
	var game = Game.instance()
	get_node("Control").hide()
	add_child(game)