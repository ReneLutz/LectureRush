extends KinematicBody2D

const WALK_SPEED = Vector2(80, 40)
const STANDING = "Standing"
const WALKING = "Walking"

# Current sentences the professor can say
const SENTENCE_TRIVIAL = "You can do the rest at home. It's completely trivial!"
const SENTENCE_EXAM = "Listen!!!\nThis will be relevant for your exam!"
const SENTENCE_GET_OUT = "You are not paying attention! GET OUT!"

var speechBubbleInstance

# Professor ability cooldowns available
var examActivated = false
var trivialActivated = false

onready var sprite = get_node("AnimatedSprite")

export var power = 150

var velocity = Vector2()

#Current mood level
var mood = 100.0;
var maxMood = 100.0;
var panicUI = null
var dead = false
var deadTimer = 0

func _ready():
	set_fixed_process(true)
	get_node("BodyOnly/Particles2D").set_process(false)
	get_node("BodyOnly/Particles2D").set_fixed_process(false)
	
	var speechBubbleScene = load("res://scenes/objects/speechbubble.tscn")
	speechBubbleInstance = speechBubbleScene.instance()
	add_child(speechBubbleInstance)
	
	_disposeSpeechBubble()

	
func _fixed_process(delta):
	if dead:
		get_node("BodyOnly/Particles2D").set_process(true)
		get_node("BodyOnly/Particles2D").set_fixed_process(true)
		if not get_node("rocketLaunch").is_playing():
			get_node("rocketLaunch").play()
		deadTimer+=delta
		if deadTimer > 1:
			if get_node("rocketLaunch").is_playing():
				get_node("rocketLaunch").stop()
			if not get_node("rocketExplode").is_playing():
				get_node("rocketExplode").play()
			get_node("HeadOnly/Sprite").hide()
			get_node("HeadOnly/HeadExplosion").show()
			get_node("HeadOnly/HeadExplosion").set_global_pos(get_node("HeadOnly/Sprite").get_global_pos())
			get_node("HeadOnly/HeadExplosion").start()
		if deadTimer > 5:
			get_node("rocketExplode").stop()
		return
	
	var acceleration = Vector2((Input.is_key_pressed(KEY_D) - Input.is_key_pressed(KEY_A)), 
								(Input.is_key_pressed(KEY_S) - Input.is_key_pressed(KEY_W)))
	
	# Check ability activation
	if(Input.is_key_pressed(KEY_1)):
		if(!trivialActivated):
			 _activateTrivial()
	
	if(Input.is_key_pressed(KEY_2)):
		if(!examActivated):
			_activateExam()
	
	# Play walking animation
	if((acceleration.x != 0) || (acceleration.y != 0)):
		sprite.play(WALKING)
	else:
		sprite.play(STANDING)
	
	# Move professor
	var motion = Vector2(WALK_SPEED.x * acceleration.x, WALK_SPEED.y * acceleration.y) * delta
	move(motion)
	
func _yell(sentence):
	var position = get_pos()
	speechBubbleInstance.set_pos(Vector2(position.x + 50, position.y - 50))

	var textLabelNode = speechBubbleInstance.get_node("Polygon2D/RichTextLabel")
	textLabelNode.setText(sentence)
	
func _disposeSpeechBubble():
	speechBubbleInstance.set_pos(Vector2(-2500, -2500))

func _activateTrivial():
	trivialActivated = true
	_yell(SENTENCE_TRIVIAL)
	
	# Start cooldown timer
	
func _activateExam():
	examActivated = true
	_yell(SENTENCE_EXAM)

func setPanicUI(p):
	panicUI = p

func setMood(level):
	mood = level
	if mood == 0:
		dead = true
		get_node("AnimatedSprite").hide()
		get_node("BodyOnly").show()
		get_node("HeadOnly").show()
		get_node("HeadOnly").set_fixed_process(true)
	if panicUI != null:
		print((maxMood-mood)/maxMood)
		panicUI.panic = (maxMood-mood)/maxMood
	print("Prof's mood set to %s." % str(level))
	
func changeMood(increase):
	var newMood = mood + increase
	setMood(newMood)
	print("Prof's mood %s by %s (%s)." % ["increased" if increase >= 0 else "decreased", str(abs(increase)), str(mood)])
