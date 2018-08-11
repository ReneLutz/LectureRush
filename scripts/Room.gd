extends TileMap

const CHAIR_TILE_NAME = "Chair"

var timerStudent = 0.0
var spawnTimeStudent = 2.0
var spawnStudentLeft = true

var timerCat = 0.0
var spawnTimeCat = 1.0

func _ready():
	_resetSeatList()
	randomize()
	self.set_process(true)

func _process(delta):
	spawnStudents(delta)
	spawntimeCat(delta)
	
# coord: Vector2
func coordToCellIdx(coord):
	return coord / get_cell_size()
	
# idx: cell index
func getTileName(idx):
	get_tileset().tile_get_name(get_cell(idx))
	
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
		
	add_child(sceneStudentInstance)

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
	
func spawntimeCat(delta):
	timerCat += delta
	if timerCat >= spawnTimeCat:
		print("Spawning cat")
		spawnCat()
		timerCat = 0.0
	
func spawnCat():
	var sceneCat = load("res://scenes/objects/cat.tscn")
	var sceneCatInstance = sceneCat.instance()
	sceneCatInstance.set_name("cat")
	# set position
	sceneCatInstance.set_pos(get_node("SpawnAreas/SpawnAreaLeft").get_pos())
	add_child(sceneCatInstance)