extends TileMap

const CHAIR_TILE_NAME = "Chair"
const INITIAL_STUDENTS_COUNT = 20

export var initialSpawnProbability = 0.9

var timerStudent = 20.0
var spawnTimeStudent = 3.0
var spawnStudentLeft = true

var sceneCatInstance
var timerCat = 0.0
var spawnTimeCat = 10.0
var isCatSpawned = false
var timerCatExists = 0.0
var catExistenceTime = 5.0

var nodeStudents
var initialSpawn = false

var timerLabel
var startMs

func _ready():
	timerLabel = get_node("../UI/Time")
	startMs = OS.get_ticks_msec()
	_resetSeatList()
	randomize()
	nodeStudents = get_node("../Students")
	self.set_process(true)	

func _process(delta):
	if !initialSpawn:
		spawnStudentsOnSeats(INITIAL_STUDENTS_COUNT)
		initialSpawn = true
		
	spawnStudents(delta)
	spawntimeCat(delta)
	nodeStudents.spawnDisturbActions(delta)
	nodeStudents.spawnPaperplanes(delta)

# coord: Vector2
func coordToCellIdx(coord):
	return (coord / get_cell_size()).floor()
	
# idx: cell index
func getTileName(idx):
	var ur = get_used_rect()
	if idx.x >= ur.pos.x && idx.x < ur.end.x && idx.y >= ur.pos.y && idx.y < ur.end.y:
		return get_tileset().tile_get_name(self.get_cell(idx.x, idx.y))
	else:
		return "None"

########## SPAWNING STUDENTS ##########

func spawnStudents(delta):
	timerStudent += delta
	if timerStudent >= spawnTimeStudent:
		# spawn student scene
		spawnStudent(true)
		# reset spawn timer
		timerStudent = 0.0
		
func spawnStudent(atRandomSpawnPoint):
	var sceneStudent = load("res://scenes/objects/student.tscn")
	var sceneStudentInstance = sceneStudent.instance()
	var sex = randi()%2
	if sex == 1:
		sceneStudentInstance.sex = "male"
	else:
		sceneStudentInstance.sex = "female"
	sceneStudentInstance.set_name("student")
	# set position
	if atRandomSpawnPoint == true:
		# spawn left or right
		if randi()%2 == 1:
			spawnStudentLeft = !spawnStudentLeft
			
		if spawnStudentLeft == true:
			sceneStudentInstance.set_pos(get_node("SpawnAreas/SpawnAreaLeft").get_pos())
		else:
			sceneStudentInstance.set_pos(get_node("SpawnAreas/SpawnAreaRight").get_pos())
		
	get_node("../Students").add_child(sceneStudentInstance)
	return sceneStudentInstance

func spawnStudentsOnSeats(count):
	var ts = get_tileset()
	for cellIdx in get_used_cells():
		if(ts.tile_get_name(get_cell(cellIdx.x, cellIdx.y)) == CHAIR_TILE_NAME):
			if randf() < initialSpawnProbability:
				var student = spawnStudent(true)
				student.moveToCell(cellIdx)
				student.setState(0) #SITTING
				_seatList[cellIdx] = false
	
	
########## SPAWNING CAT ##########

func spawntimeCat(delta):
	if !isCatSpawned:
		timerCat += delta
		if timerCat >= spawnTimeCat:
			spawnCat()
			isCatSpawned = true
			timerCat = 0.0
	else:
		timerCatExists += delta
		if timerCatExists >= catExistenceTime:
			hideCat()
			timerCatExists = 0.0
			isCatSpawned = false
	
func spawnCat():
	var sceneCat = load("res://scenes/objects/cat.tscn")
	sceneCatInstance = sceneCat.instance()
	sceneCatInstance.set_name("cat")
	# set position
	#sceneCatInstance.set_pos(get_node("Decoration/Plant2").get_pos())
	#add_child(sceneCatInstance)
	
	sceneCatInstance.set_pos(Vector2(7, 20))
	get_node("Decoration/Plant2").add_child(sceneCatInstance)
	#print("SpawnKitty2")
	
func hideCat():
	get_node("Decoration/Plant2").remove_child(sceneCatInstance)
	
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
