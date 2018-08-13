extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const Game = preload("res://scenes/levels/Game.tscn")
var currentGameInstance = null

func closeTutorial():
	get_node("TutorialControl1").hide()
	get_node("TutorialControl2").hide()
	get_node("TutorialControl3").hide()
	get_node("TutorialControl4").hide()
	get_node("TutorialControl5").hide()
	get_node("TutorialControl6").hide()
	get_node("TutorialControl7").hide()

func showTutorial1():
	get_node("TutorialControl1").show()
	get_node("TutorialControl2").hide()
	get_node("TutorialControl3").hide()
	get_node("TutorialControl4").hide()
	get_node("TutorialControl5").hide()
	get_node("TutorialControl6").hide()
	get_node("TutorialControl7").hide()
	
func showTutorial2():
	get_node("TutorialControl1").hide()
	get_node("TutorialControl2").show()
	get_node("TutorialControl3").hide()
	get_node("TutorialControl4").hide()
	get_node("TutorialControl5").hide()
	get_node("TutorialControl6").hide()
	get_node("TutorialControl7").hide()
	
func showTutorial3():
	get_node("TutorialControl1").hide()
	get_node("TutorialControl2").hide()
	get_node("TutorialControl3").show()
	get_node("TutorialControl4").hide()
	
func showTutorial4():
	get_node("TutorialControl1").hide()
	get_node("TutorialControl2").hide()
	get_node("TutorialControl3").hide()
	get_node("TutorialControl4").show()
	get_node("TutorialControl5").hide()
	get_node("TutorialControl6").hide()
	get_node("TutorialControl7").hide()
	
func showTutorial5():
	get_node("TutorialControl1").hide()
	get_node("TutorialControl2").hide()
	get_node("TutorialControl3").hide()
	get_node("TutorialControl4").hide()
	get_node("TutorialControl5").show()
	get_node("TutorialControl6").hide()
	get_node("TutorialControl7").hide()
	
func showTutorial6():
	get_node("TutorialControl1").hide()
	get_node("TutorialControl2").hide()
	get_node("TutorialControl3").hide()
	get_node("TutorialControl4").hide()
	get_node("TutorialControl5").hide()
	get_node("TutorialControl6").show()
	get_node("TutorialControl7").hide()
	
func showTutorial7():
	get_node("TutorialControl1").hide()
	get_node("TutorialControl2").hide()
	get_node("TutorialControl3").hide()
	get_node("TutorialControl4").hide()
	get_node("TutorialControl5").hide()
	get_node("TutorialControl6").hide()
	get_node("TutorialControl7").show()
	

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	get_node("Control/Button").connect("button_up",self,"playPressed")
	get_node("Control/ButtonTutorial").connect("button_up",self,"showTutorial1")
	get_node("TutorialControl1/Button1").connect("button_up",self,"showTutorial2")
	get_node("TutorialControl2/Button1").connect("button_up",self,"showTutorial3")
	get_node("TutorialControl3/Button1").connect("button_up",self,"showTutorial4")
	get_node("TutorialControl4/Button1").connect("button_up",self,"showTutorial5")
	get_node("TutorialControl5/Button1").connect("button_up",self,"showTutorial6")
	get_node("TutorialControl6/Button1").connect("button_up",self,"showTutorial7")
	
	get_node("TutorialControl1/Button").connect("button_up",self,"closeTutorial")
	get_node("TutorialControl2/Button").connect("button_up",self,"closeTutorial")
	get_node("TutorialControl3/Button").connect("button_up",self,"closeTutorial")
	get_node("TutorialControl4/Button").connect("button_up",self,"closeTutorial")
	get_node("TutorialControl5/Button").connect("button_up",self,"closeTutorial")
	get_node("TutorialControl6/Button").connect("button_up",self,"closeTutorial")
	get_node("TutorialControl7/Button").connect("button_up",self,"closeTutorial")

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