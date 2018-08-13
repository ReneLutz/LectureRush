extends Node

var uiTimeLabel
var lectureTimer

var professor
var students

var score = 0
var uiScorelabel

var colorAnimationTimer
var colorAnimationMaxTime = 0.6
var colorAnimationActive = false
var colorGreen = false

func _ready():
	set_process(true)
	get_node("Professor").get_node("profBody").setPanicUI(get_node("Panic"))
	uiTimeLabel = get_node("UI/Time")
	lectureTimer = get_node("LectureTimer")
	professor = get_node("Professor/profBody")
	students = get_node("Students")
	uiScorelabel = get_node("UI/Score")
	
func _process(delta):
	var seatedStudents = 0
	for s in students.get_children():
		if s.isSeated():
			seatedStudents += 1
	
	score += professor.mood * seatedStudents / 100 * delta
	uiScorelabel.set_text(str(round(score)))
	
	var remainingTime = lectureTimer.get_time_left()
	var minutes = int(remainingTime) / 60
	var seconds = int(remainingTime) % 60
	
	uiTimeLabel.set_text(str(minutes) + ":" + str(seconds))
	
	#change color
	if colorAnimationActive:
		colorAnimationTimer += delta
		if colorAnimationTimer >= colorAnimationMaxTime:
			colorAnimationTimer = 0.0
			setColorFeedback(false)
			
func _on_LectureTimer_timeout():
	get_tree().set_pause(true)
	pass # replace with function body
	
func setColorFeedbackGreen():
	uiScorelabel.add_color_override("font_color", Color(0,1,0,1))
	setColorFeedback(true)
		
func setColorFeedbackRed():
	uiScorelabel.add_color_override("font_color", Color(1,0,0,1))
	setColorFeedback(true)
	
func setColorFeedback(active):
	colorAnimationActive = active
	if !active:
		#set color to white
		uiScorelabel.add_color_override("font_color", Color(0,0,0,1))
		
	