extends TileMap

var timer = 0.0
var spawnTime = 2.0
var spawnLeft = true

func _ready():
	# Initialization here
	randomize()
	self.set_process(true)

func _process(delta):
	spawnStudents(delta)
	
func spawnStudents(delta):
	timer += delta
	if timer >= spawnTime:
		print("Spawning student..")
		# spawn left or right
		if randi()%2 == 1:
			spawnLeft = !spawnLeft
		# spawn student scene
		spawnStudent()
		# reset spawn timer
		timer = 0.0
		
func spawnStudent():
	var sceneStudent = load("res://scenes/objects/student.tscn")
	var sceneStudentInstance = sceneStudent.instance()
	sceneStudentInstance.set_name("student")
	# set position
	if spawnLeft == true:
		sceneStudentInstance.set_pos(get_node("SpawnAreas/SpawnAreaLeft").get_pos())
	else:
		sceneStudentInstance.set_pos(get_node("SpawnAreas/SpawnAreaRight").get_pos())
		
	add_child(sceneStudentInstance)
