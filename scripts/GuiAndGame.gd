extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const Game = preload("res://scenes/levels/Game.tscn")
var currentGameInstance = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Control/Button").connect("button_up",self,"playPressed")

func endGame():
	remove_child(currentGameInstance)
	currentGameInstance = null
	get_node("Control").show()
	
func restartGame():
	remove_child(currentGameInstance)
	currentGameInstance = null
	currentGameInstance = Game.instance()
	currentGameInstance.connect("gameEnded", self, "endGame")
	currentGameInstance.connect("gameRestarted", self, "restartGame")
	add_child(currentGameInstance)

func playPressed():
	currentGameInstance = Game.instance()
	currentGameInstance.connect("gameEnded", self, "endGame")
	currentGameInstance.connect("gameRestarted", self, "restartGame")
	get_node("Control").hide()
	add_child(currentGameInstance)