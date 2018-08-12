extends Node

func _ready():
	set_fixed_process(true)
	get_node("Professor").get_node("profBody").setPanicUI(get_node("Panic"))
	
func _fixed_process(delta):
	var uiTimeLabel = get_node("UI/Time")
	var lectureTimer = get_node("LectureTimer")
	
	var remainingTime = lectureTimer.get_time_left()
	var minutes = int(remainingTime) / 60
	var seconds = int(remainingTime) % 60
	
	uiTimeLabel.set_text(str(minutes) + ":" + str(seconds))
	
func _on_LectureTimer_timeout():
	# End game, because lecture is over
	pass # replace with function body