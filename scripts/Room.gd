extends TileMap

const CHAIR_TILE_NAME = "Chair"

var timerStudent = 20.0
var spawnTimeStudent = 20.0
var spawnStudentLeft = true

var sceneCatInstance
var timerCat = 0.0
var spawnTimeCat = 10.0
var isCatSpawned = false
var timerCatExists = 0.0
var catExistenceTime = 5.0

var timerDisturbAction = 0.0
var disturbActionCooldown = 5.0

var nodeStudents

func _ready():
	_resetSeatList()
	randomize()
	nodeStudents = get_node("../Students")
	self.set_process(true)

func _process(delta):
	spawnStudents(delta)
	spawntimeCat(delta)
	spawnStudentsDisturbActions(delta)

# coord: Vector2
func coordToCellIdx(coord):
	return (coord / get_cell_size()).floor()
	
# idx: cell index
func getTileName(idx):
	return get_tileset().tile_get_name(self.get_cell(idx.x, idx.y))

########## SPAWNING STUDENTS ##########

func spawnStudents(delta):
	timerStudent += delta
	if timerStudent >= spawnTimeStudent:
		print("Spawning student..")
		# spawn left or right
		if randi()%2 == 1:
			spawnStudentLeft = !spawnStudentLeft
		# spawn student scene
		spawnStudent()
		# reset spawn timer
		timerStudent = 0.0
		
func spawnStudent():
	var sceneStudent = load("res://scenes/objects/student.tscn")
	var sceneStudentInstance = sceneStudent.instance()
	var sex = randi()%2
	if sex == 1:
		sceneStudentInstance.sex = "male"
	else:
		sceneStudentInstance.sex = "female"
	sceneStudentInstance.set_name("student")
	# set position
	if spawnStudentLeft == true:
		sceneStudentInstance.set_pos(get_node("SpawnAreas/SpawnAreaLeft").get_pos())
	else:
		sceneStudentInstance.set_pos(get_node("SpawnAreas/SpawnAreaRight").get_pos())
		
	get_node("../Students").add_child(sceneStudentInstance)

# Picks random student node for spawning a disturb action
func spawnStudentsDisturbActions(delta):
	var studentCount = nodeStudents.get_child_count()
	if studentCount == 0:
		return
		
	timerDisturbAction += delta
	if timerDisturbAction >= disturbActionCooldown:
		timerDisturbAction = 0.0
		print("Room.gd: Spawning disturb action..")
		#choose random student who is sitting and has no current disturb action
		var randStudent = randi() % studentCount
		var index = 0
		for student in nodeStudents.get_children():
			if index == randStudent  && !student.isDisturbActionActive(): # && student.isSeated()
				print(" --> Choosing student with index: ", index)
				student.spawnDisturbAction()
				break
			index += 1
		
########## SPAWNING CAT ##########

func spawntimeCat(delta):
	if !isCatSpawned:
		timerCat += delta
		if timerCat >= spawnTimeCat:
			print("Spawning cat")
			spawnCat()
			isCatSpawned = true
			timerCat = 0.0
	else:
		timerCatExists += delta
		if timerCatExists >= catExistenceTime:
			print("Hiding cat")
			hideCat()
			timerCatExists = 0.0
			isCatSpawned = false
	
func spawnCat():
	var sceneCat = load("res://scenes/objects/cat.tscn")
	sceneCatInstance = sceneCat.instance()
	sceneCatInstance.set_name("cat")
	# set position
	sceneCatInstance.set_pos(get_node("Decoration/Plant").get_pos())
	add_child(sceneCatInstance)
	
func hideCat():
	remove_child(sceneCatInstance)
	
# Vector2 -> bool
# only contains indices of chairs
var _seatList = Dictionary()

func _resetSeatList():
	_seatList.clear()
	var ts = get_tileset()
	for cellIdx in get_used_cells():
		if(ts.tile_get_name(get_cell(cellIdx.x, cellIdx.y)) == CHAIR_TILE_NAME):
			_seatList[cellIdx] = true

# seatIdx: Vector2
func isSeatFree(seatIdx):
	return _seatList.has(seatIdx) && _seatList[seatIdx]
	
#seatIdx: Vector2
#free: bool
func setSeatFree(seatIdx, free):
	_seatList[seatIdx] = free
