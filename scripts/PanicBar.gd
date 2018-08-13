extends AnimatedSprite

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	play("Init")
	connect("finished", self, "loopAnim")
	
func loopAnim():
	play("Loop")
