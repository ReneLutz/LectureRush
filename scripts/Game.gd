extends Node

var uiTimeLabel
var lectureTimer

var professor
var students

var score = 0
var uiScorelabel

var colorAnimationTimer = 0.0
var colorAnimationMaxTime = 0.6
var colorAnimationActive = false
var colorGreen = false

signal gameRestarted
signal gameEnded
var gameover = false
var timeout = false

func isGameover():
	return gameover
	
func setGameover(gameover):
	if gameover:
		if timeout:
			get_node("GuiLayer/Gui/Label").set_text("Time's up")
		get_node("GuiLayer/Gui/Score").set_text(str(ceil(score)))
		get_node("GuiLayer/Gui").show()
	self.gameover = gameover
	
func endGame():
	emit_signal("gameEnded")
	
func restartGame():
	emit_signal("gameRestarted")
	
func _ready():
	set_process(true)
	get_node("Professor").get_node("profBody").setPanicUI(get_node("UI/PanicBar"))
	uiTimeLabel = get_node("UI/Time")
	lectureTimer = get_node("LectureTimer")
	professor = get_node("Professor/profBody")
	students = get_node("Students")
	uiScorelabel = get_node("UI/Score")
	
func _process(delta):
	if !gameover:
		# count score
		var seatedStudents = 0
		for s in students.get_children():
			if s.isSeated():
				seatedStudents += 1
		
		score += professor.mood * seatedStudents / 100 * delta
		uiScorelabel.set_text(str(round(score)))
		
		# calculate remaining time
		var remainingTime = lectureTimer.get_time_left()
		var minutes = int(remainingTime) / 60
		var seconds = int(remainingTime) % 60
		
		if remainingTime <= 0:
			gameover = true
			
		uiTimeLabel.set_text("%d:%02d" % [minutes, seconds])
		
	#change color
	if colorAnimationActive:
		colorAnimationTimer += delta
		if colorAnimationTimer >= colorAnimationMaxTime:
			colorAnimationTimer = 0.0
			setColorFeedback(false)
			
func _on_LectureTimer_timeout():
	if !gameover:
		timeout = true
		setGameover(true)
	pass # replace with function body
	
func setColorFeedbackGreen():
	print("SET COLOR")
	uiScorelabel.add_color_override("font_color", Color(0,1,0,1))
	setColorFeedback(true)
		
func setColorFeedbackRed():
	uiScorelabel.add_color_override("font_color", Color(1,0,0,1))
	setColorFeedback(true)
	
func setColorFeedback(active):
	colorAnimationActive = active
	if !active:
		#set color to white
		uiScorelabel.add_color_override("font_color", Color(1,1,1,1))
		
	