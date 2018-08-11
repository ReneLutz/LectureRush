extends TileMap

var timer = 0.0
var spawnTime = 2.0
var spawnLeft = true

func spawnStudents(delta):
	timer += delta
	if timer >= spawnTime:
		print("Spawning student..")
		# spawn student scene
		spawnStudent()
		
		spawnLeft = !spawnLeft
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
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	self.set_process(true)

func _process(delta):
	spawnStudents(delta)