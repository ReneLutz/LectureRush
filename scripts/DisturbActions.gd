extends Node

enum actionTypes { DRINK_WATER = 0, DRINK_COFFEE, HEADPHONES, TOILET, SMOKE }
var actions = []

var timerDisturbAction = 0.0
var disturbActionCooldown = 5.0

class DisturbAction:
	var actionType
	var disturbValue = 1
	var disturbTime = 20
	
	func _init(actionType, moodValue, duration):
		self.actionType = actionType
		self.disturbValue = moodValue
		self.disturbTime = duration

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

# Picks random student node for spawning a disturb action
func spawnDisturbActions(delta):
	timerDisturbAction += delta
	if timerDisturbAction >= disturbActionCooldown:
		timerDisturbAction = 0.0
		print("Room.gd: Spawning disturb action..")
		#choose random student who is sitting and has no current disturb action
		var randStudent = randi() % get_child_count()
		var index = 0
		for student in get_children():
			if index == randStudent  && !student.isDisturbActionActive(): # && student.isSeated()
				print(" --> Choosing student with index: ", index)
				_spawnRandomDisturbAction(student)
				break
			index += 1

# spawns a random disturb action on a student
func _spawnRandomDisturbAction(student):
	# spawn random disturb action
	var randAction = randi() % 2
	if randAction == 0:
		_generateDisturbAction(actionTypes.DRINK_WATER, student)
	else:
		_generateDisturbAction(actionTypes.HEADPHONES, student)
		
	
func _generateDisturbAction(actionType, student):
	var action
	if actionType == actionTypes.DRINK_WATER:
		print(" --> Student DRINK_WATER")
		_spawnActionDrinkWater(student)
		action = DisturbAction.new(actionType, 5, 10)
		
	elif actionType == actionTypes.DRINK_COFFEE:
		print(" --> Student DRINK_COFFEE")
		
		action = DisturbAction.new(actionType, 5, 10)
		pass
	elif actionType == actionTypes.HEADPHONES:
		print(" --> Student HEADPHONES")
		_spawnActionHeadphones(student)
		action = DisturbAction.new(actionType, 5, 10)
		pass
	elif actionType == actionTypes.TOILET:
		print(" --> Student TOILET")
		
		action = DisturbAction.new(actionType, 5, 10)
		pass
	elif actionType == actionTypes.SMOKE:
		print(" --> Student SMOKE")
		
		action = DisturbAction.new(actionType, 5, 10)
		pass
		
	student.setActiveDisturbAction(action)
	
func _spawnActionDrinkWater(student):
	# Add Image / Animations to Student
	var sceneWaterbottle = load("res://scenes/objects/waterbottle.tscn")
	var sceneWaterbottleInstance = sceneWaterbottle.instance()
	sceneWaterbottleInstance.set_name("waterbottle")
	sceneWaterbottleInstance.set_pos(Vector2(10, -8))
		
	student.get_node("DisturbSprites").add_child(sceneWaterbottleInstance)
	
func _spawnActionHeadphones(student):
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/headphones.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("headphones")
	sceneInstance.set_pos(Vector2(0, -10))
		
	student.get_node("DisturbSprites").add_child(sceneInstance)