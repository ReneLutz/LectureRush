extends Node

var studentClicked = false;

var occupiedSeats = {}

enum actionTypes { DRINK_WATER = 0, DRINK_COFFEE, HEADPHONES, TOILET, SMOKE, PAPERPLANE, SLEEP, PHONE }

const ACTION_SPAWN_COOLDOWN = 2.0

# Values which decrease the mood of the professor
const MOOD_VALUE_ACTION_DRINK_WATER = 7
const MOOD_VALUE_ACTION_DRINK_COFFEE = 7
const MOOD_VALUE_ACTION_HEADPHONES = 7
const MOOD_VALUE_ACTION_TOILET = 7
const MOOD_VALUE_ACTION_SMOKE = 7
const MOOD_VALUE_ACTION_PAPERPLANE = 7
const MOOD_VALUE_ACTION_SLEEP = 7
const MOOD_VALUE_ACTION_PHONE = 7

# If DURATION initialized with <= 0: Disturb action of student will remain until he leaves the room
const DURATION_ACTION_DRINK_WATER = 30
const DURATION_ACTION_DRINK_COFFEE = 30
const DURATION_ACTION_HEADPHONES = 30
const DURATION_ACTION_TOILET = 30
const DURATION_ACTION_SMOKE = 30
const DURATION_ACTION_PAPERPLANE = 6
const DURATION_ACTION_SLEEP = 30
const DURATION_ACTION_PHONE = 30

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
		
	elif actionType == actionTypes.SLEEP:
		_spawnActionSleep(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_SLEEP, DURATION_ACTION_SLEEP)
		
	elif actionType == actionTypes.PHONE:
		_spawnActionPhone(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_PHONE, DURATION_ACTION_PHONE)
		
	else:
		_spawnActionPaperplane(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_PAPERPLANE, DURATION_ACTION_PAPERPLANE)
		
	# give action to student
	student.setActiveDisturbAction(action)
	# change mood of professor
	var professor = get_node("../Professor/profBody")
	professor.changeMood(-action.disturbValue)
	
func _spawnActionDrinkWater(student):
	print("WATER")
	# Add Image / Animations to Student
	var sceneWaterbottle = load("res://scenes/objects/waterbottle.tscn")
	var sceneWaterbottleInstance = sceneWaterbottle.instance()
	sceneWaterbottleInstance.set_name("waterbottle")
	sceneWaterbottleInstance.set_pos(Vector2(10, -4))
		
	student.get_node("DisturbSprites").add_child(sceneWaterbottleInstance)
	
func _spawnActionDrinkCoffee(student):
	print("COFFEE")
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/coffee.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("coffee")
	sceneInstance.set_pos(Vector2(14, -6))
		
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
	sceneInstance.set_pos(Vector2(-3, 3))
		
	student.get_node("DisturbSprites").add_child(sceneInstance)
	
func _spawnActionPaperplane(student):
	# spawn paperplane at students pos
	var scenePlane = load("res://scenes/objects/paper_plane.tscn")
	var scenePlaneInstance = scenePlane.instance()
	scenePlaneInstance.set_name("paper_plane")
	# set position
	scenePlaneInstance.set_pos(Vector2(student.get_pos().x + 20, student.get_pos().y))
	get_parent().add_child(scenePlaneInstance)
	
func _spawnActionPhone(student):
	# Add Image / Animations to Student
	if student.sex == "male":
		student.set_animation("WalkingMalePhone")
	else:
		student.set_animation("WalkingFemalePhone")
		
	student.setPhoneAnimation(true)
	
func _spawnActionSleep(student):
	# Add Image / Animations to Student
	if student.sex == "male":
		student.set_animation("SleepingMale")
	else:
		student.set_animation("SleepingFemale")
		
	student.setSleepAnimation(true)