extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var gravity = 40
export var degrees = 0.0
export var mass = 1.0
var dir = Vector2(0,0)
var velocity = Vector2()

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	dir.x = sin(deg2rad(degrees))
	dir.y = cos(deg2rad(degrees))
	velocity.x = get_parent().power*dir.x/mass
	velocity.y = get_parent().power*dir.y/mass

func _fixed_process(delta):
	velocity.y += gravity*delta
	var motion = velocity*delta
	move(motion)