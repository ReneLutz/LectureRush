extends Node

enum actionTypes { DRINK_WATER = 0, DRINK_COFFEE, HEADPHONES, TOILET, SMOKE }

const ACTION_SPAWN_COOLDOWN = 3

# Values which decrease the mood of the professor
const MOOD_VALUE_ACTION_DRINK_WATER = 5
const MOOD_VALUE_ACTION_DRINK_COFFEE = 5
const MOOD_VALUE_ACTION_HEADPHONES = 5
const MOOD_VALUE_ACTION_TOILET = 5
const MOOD_VALUE_ACTION_SMOKE = 5

# If DURATION initialized with <= 0: Disturb action of student will remain until he leaves the room
const DURATION_ACTION_DRINK_WATER = 30
const DURATION_ACTION_DRINK_COFFEE = 30
const DURATION_ACTION_HEADPHONES = 30
const DURATION_ACTION_TOILET = 30
const DURATION_ACTION_SMOKE = 30

var timerDisturbAction = 0.0

class DisturbAction:
	var actionType
	var disturbValue = 0
	var disturbTime = 0
	
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
	if timerDisturbAction >= ACTION_SPAWN_COOLDOWN:
		timerDisturbAction = 0.0
		#choose random student who is sitting and has no current disturb action
		var randStudent = randi() % get_child_count()
		var index = 0
		for student in get_children():
			if index == randStudent  && !student.isDisturbActionActive() && student.isSeated():
				_spawnRandomDisturbAction(student)
				break
			index += 1

# spawns a random disturb action on a student
func _spawnRandomDisturbAction(student):
	# spawn random disturb action
	var randAction = randi() % 5
	_generateDisturbAction(randAction, student)
		
	
func _generateDisturbAction(actionType, student):
	var action
	if actionType == actionTypes.DRINK_WATER:
		print(" --> Student DRINK_WATER")
		_spawnActionDrinkWater(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_DRINK_WATER, DURATION_ACTION_DRINK_WATER)
		
	elif actionType == actionTypes.DRINK_COFFEE:
		print(" --> Student DRINK_COFFEE")
		_spawnActionDrinkCoffee(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_DRINK_COFFEE, DURATION_ACTION_DRINK_COFFEE)
		
	elif actionType == actionTypes.HEADPHONES:
		print(" --> Student HEADPHONES")
		_spawnActionHeadphones(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_HEADPHONES, DURATION_ACTION_HEADPHONES)
		pass
	elif actionType == actionTypes.TOILET:
		print(" --> Student TOILET")
		
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_TOILET, DURATION_ACTION_TOILET)
		
	elif actionType == actionTypes.SMOKE:
		print(" --> Student SMOKE")
		_spawnActionSmoke(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_SMOKE, DURATION_ACTION_SMOKE)
	
	# give action to student
	student.setActiveDisturbAction(action)
	# change mood of professor
	var professor = get_node("../Professor/profBody")
	professor.changeMood(-action.disturbValue)
	
func _spawnActionDrinkWater(student):
	# Add Image / Animations to Student
	var sceneWaterbottle = load("res://scenes/objects/waterbottle.tscn")
	var sceneWaterbottleInstance = sceneWaterbottle.instance()
	sceneWaterbottleInstance.set_name("waterbottle")
	sceneWaterbottleInstance.set_pos(Vector2(10, -2))
		
	student.get_node("DisturbSprites").add_child(sceneWaterbottleInstance)
	
func _spawnActionDrinkCoffee(student):
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/coffee.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("coffee")
	sceneInstance.set_pos(Vector2(14, -1))
		
	student.get_node("DisturbSprites").add_child(sceneInstance)
	
func _spawnActionHeadphones(student):
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/headphones.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("headphones")
	sceneInstance.set_pos(Vector2(1, -11))
		
	student.get_node("DisturbSprites").add_child(sceneInstance)
	
func _spawnActionSmoke(student):
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/Cigarette.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("cigarette")
	sceneInstance.set_pos(Vector2(-8, 5))
		
	student.get_node("DisturbSprites").add_child(sceneInstance)