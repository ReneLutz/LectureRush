extends Node

var studentClicked = false;

var occupiedSeats = {}

enum actionTypes { DRINK_WATER = 0, DRINK_COFFEE, HEADPHONES, TOILET, SMOKE, PAPERPLANE, SLEEP, PHONE, DRINK_WINE }

const ACTION_SPAWN_COOLDOWN = 4.5
const ACTION_PAPERPLANE_COOLDOWN = 6.0

# Values which decrease the mood of the professor
const MOOD_VALUE_ACTION_DRINK_WATER = 4
const MOOD_VALUE_ACTION_DRINK_COFFEE = 4
const MOOD_VALUE_ACTION_HEADPHONES = 4
const MOOD_VALUE_ACTION_TOILET = 4
const MOOD_VALUE_ACTION_SMOKE = 4
const MOOD_VALUE_ACTION_PAPERPLANE = 0
const MOOD_VALUE_ACTION_SLEEP = 4
const MOOD_VALUE_ACTION_PHONE = 4
const MOOD_VALUE_ACTION_DRINK_WINE = 4

# If DURATION initialized with <= 0: Disturb action of student will remain until he leaves the room
const DURATION_ACTION_DRINK_WATER = 40
const DURATION_ACTION_DRINK_COFFEE = 40
const DURATION_ACTION_HEADPHONES = 40
const DURATION_ACTION_TOILET = 40
const DURATION_ACTION_SMOKE = 40
const DURATION_ACTION_PAPERPLANE = 6
const DURATION_ACTION_SLEEP = 40
const DURATION_ACTION_PHONE = 40
const DURATION_ACTION_DRINK_WINE = 40

var timerDisturbAction = 0.0
var timerPaperplane = 0.0

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

func spawnPaperplanes(delta):
	timerPaperplane += delta
	if timerPaperplane >= ACTION_PAPERPLANE_COOLDOWN:
		timerPaperplane = 0.0
		#choose random student who is sitting and has no current disturb action
		var freeStudentChosen = false
		var count = 0
		var maxTries = 10
		while !freeStudentChosen && count < maxTries:
			var randStudent = randi() % get_child_count()
			var student = get_children()[randStudent]
			if student.isSeated() && !student.isDisturbActionActive():
				freeStudentChosen = true
				_generateDisturbAction(actionTypes.PAPERPLANE, student)
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
		
	elif actionType == actionTypes.DRINK_WINE:
		_spawnActionDrinkWine(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_DRINK_WINE, DURATION_ACTION_DRINK_WINE)
		
	else:
		_spawnActionPaperplane(student)
		action = DisturbAction.new(actionType, MOOD_VALUE_ACTION_PAPERPLANE, DURATION_ACTION_PAPERPLANE)
		
	# give action to student
	student.setActiveDisturbAction(action)
	# change mood of professor
	#var professor = get_node("../Professor/profBody")
	#professor.changeMood(-action.disturbValue)
	
func _spawnActionDrinkWater(student):
	# Add Image / Animations to Student
	var sceneWaterbottle = load("res://scenes/objects/waterbottle.tscn")
	var sceneWaterbottleInstance = sceneWaterbottle.instance()
	sceneWaterbottleInstance.set_name("waterbottle")
	sceneWaterbottleInstance.set_pos(Vector2(12, -4))
		
	student.get_node("DisturbSprites").add_child(sceneWaterbottleInstance)
	get_node("../ActionSounds").play("glass_pouring")
	
func _spawnActionDrinkCoffee(student):
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/coffee.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("coffee")
	sceneInstance.set_pos(Vector2(14, -6))
	get_node("../ActionSounds").play("coffee_slurp")
		
	student.get_node("DisturbSprites").add_child(sceneInstance)

func _spawnActionDrinkWine(student):
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/wine.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("wine")
	sceneInstance.set_pos(Vector2(11, -2))
	get_node("../ActionSounds").play("glass_pouring")
		
	student.get_node("DisturbSprites").add_child(sceneInstance)	
	
func _spawnActionHeadphones(student):
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/headphones.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("headphones")
	get_node("../ActionSounds").play("lofi%s" % (randi() % 3 + 1))
	if student.sex == "male":
		sceneInstance.set_pos(Vector2(0, -11))
	else:
		sceneInstance.set_pos(Vector2(1, -11))
		
	student.get_node("DisturbSprites").add_child(sceneInstance)
	
func _spawnActionSmoke(student):
	# Add Image / Animations to Student
	var scene = load("res://scenes/objects/Cigarette.tscn")
	var sceneInstance = scene.instance()
	sceneInstance.set_name("cigarette")
	sceneInstance.set_pos(Vector2(-3, 3))
	get_node("../ActionSounds").play("cigarette")
		
	student.get_node("DisturbSprites").add_child(sceneInstance)
	
func _spawnActionPaperplane(student):
	# spawn paperplane at students pos
	var scenePlane = load("res://scenes/objects/paper_plane_fold.tscn")
	var scenePlaneInstance = scenePlane.instance()
	scenePlaneInstance.set_name("paper_plane_fold")
	# set position
	scenePlaneInstance.set_pos(Vector2(student.get_pos().x + 10, student.get_pos().y))
	get_parent().add_child(scenePlaneInstance)
	
func _spawnActionPhone(student):
	# Add Image / Animations to Student
	if student.sex == "male":
		student.set_animation("WalkingMalePhone")
	else:
		student.set_animation("WalkingFemalePhone")
	get_node("../ActionSounds").play("phone%s" % (randi() % 2 + 1))
	student.setPhoneAnimation(true)
	
func _spawnActionSleep(student):
	# Add Image / Animations to Student
	if student.sex == "male":
		student.set_animation("SleepingMale")
	else:
		student.set_animation("SleepingFemale")
		
	student.setSleepAnimation(true)
	
func playDoorSound():
	get_node("../ActionSounds").play("door")