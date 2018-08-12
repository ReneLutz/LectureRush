extends Node

enum actionTypes { DRINK_WATER = 0, DRINK_COFFEE, HEADPHONES, TOILET, SMOKE, PAPERPLANE }

const ACTION_SPAWN_COOLDOWN = 2.0

# Values which decrease the mood of the professor
const MOOD_VALUE_ACTION_DRINK_WATER = 5
const MOOD_VALUE_ACTION_DRINK_COFFEE = 5
const MOOD_VALUE_ACTION_HEADPHONES = 5
const MOOD_VALUE_ACTION_TOILET = 5
const MOOD_VALUE_ACTION_SMOKE = 5
const MOOD_VALUE_ACTION_PAPERPLANE = 5

# If DURATION initialized with <= 0: Disturb action of student will remain until he leaves the room
const DURATION_ACTION_DRINK_WATER = 15
const DURATION_ACTION_DRINK_COFFEE = 15
const DURATION_ACTION_HEADPHONES = 15
const DURATION_ACTION_TOILET = 15
const DURATION_ACTION_SMOKE = 15
const DURATION_ACTION_PAPERPLANE = 7

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
		var freeStudentChosen = false
		var count = 0
		var maxTries = 10
		while !freeStudentChosen && count < maxTries:
			var randStudent = randi() % get_child_count()
			var student = get_children()[randStudent]
			if student.isSeated() && !student.isDisturbActionActive():
				freeStudentChosen = true
				_spawnRandomDisturbAction(student)
				break
			count += 1

# spawns a random disturb action on a student
func _spawnRandomDisturbAction(student):
	# spawn random disturb action
	var randAction = randi() % actionTypes.size()
	_generateDisturbAction(randAction, student)
		
	
func _generateDisturbAction(actionType, student):
	var action
	if actionType == actionTypes.DRINK_WATER:
		_spawnActionDrinkWater(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_DRINK_WATER, DURATION_ACTION_DRINK_WATER)
		
	elif actionType == actionTypes.DRINK_COFFEE:
		_spawnActionDrinkCoffee(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_DRINK_COFFEE, DURATION_ACTION_DRINK_COFFEE)
		
	elif actionType == actionTypes.HEADPHONES:
		_spawnActionHeadphones(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_HEADPHONES, DURATION_ACTION_HEADPHONES)
		pass
	elif actionType == actionTypes.TOILET:
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_TOILET, DURATION_ACTION_TOILET)
		
	elif actionType == actionTypes.SMOKE:
		_spawnActionSmoke(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_SMOKE, DURATION_ACTION_SMOKE)
		
	elif actionType == actionTypes.PAPERPLANE:
		_spawnActionPaperplane(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_PAPERPLANE, DURATION_ACTION_PAPERPLANE)
	else:
		_spawnActionPaperplane(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_PAPERPLANE, DURATION_ACTION_PAPERPLANE)
		
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
	
func _spawnActionPaperplane(student):
	# spawn paperplane at students pos
	var scenePlane = load("res://scenes/objects/paper_plane.tscn")
	var scenePlaneInstance = scenePlane.instance()
	scenePlaneInstance.set_name("paper_plane")
	# set position
	scenePlaneInstance.set_pos(Vector2(student.get_pos().x + 20, student.get_pos().y))
	add_child(scenePlaneInstance)