extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var power = 200.0

func start():
	for child in get_children():
		child.set_fixed_process(true)

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass
