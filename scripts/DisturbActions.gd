extends Node

enum actionTypes { DRINK_WATER = 0, DRINK_COFFEE, HEADPHONES, TOILET, SMOKE }
var actions = []

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

func generateDisturbAction(actionType, student):
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
		
	return action
	
func _spawnActionDrinkWater(student):
	# Add Image / Animations to Student
	var sceneWaterbottle = load("res://scenes/objects/waterbottle.tscn")
	var sceneWaterbottleInstance = sceneWaterbottle.instance()
	sceneWaterbottleInstance.set_name("waterbottle")
	sceneWaterbottleInstance.set_pos(Vector2(10, -8))
		
	student.get_node("DisturbSprites").add_child(sceneWaterbottleInstance) # TODO add to special disturb-node