extends AnimatedSprite

export var walkSpeed = 600
export var sex = "female"

enum State { SITTING = 0, WALK_L, WALK_U, WALK_R, WALK_D }

enum Walkable { NONE = 0, HRZ, VRT, BOTH }

const WALKABLE_TILES = { "Floor": Walkable.BOTH, "Chair": Walkable.HRZ, "Stair": Walkable.BOTH }

var state = State.SITTING setget setState, getState

var _room
var material

var disturbing
var activeDisturbAction
var pathToStudentsNode
var disturbTimer = 0.0
var walkTimer = 0
export var walkAnimSpeed = 0.2
var disturbChildNodes

func picRandomColor():
	rand_seed(randi())
	var r = randf()
	var g = randf()
	var b = randf()
	return Color(r,g,b,1.0)

func _input_event(viewport, event, shape):
	if event.type == InputEvent.MOUSE_BUTTON && event.is_pressed():
		_onClick(event.button_index)

func _ready():
	set_fixed_process(true)
	set_process_unhandled_input(true)
	
	get_node("Area2D").connect("input_event", self, "_input_event")

	pathToStudentsNode = get_node("../../Students")
	# init node holding all sprites generated by a disturb action
	disturbChildNodes = Node2D.new()
	disturbChildNodes.set_name("DisturbSprites")
	add_child(disturbChildNodes)
	
	if sex == "female":
		set_frame(1)
	else:
		set_frame(0)
	var hairC = picRandomColor();
	var shirt = picRandomColor();
	var shoes = picRandomColor();
	var panties = picRandomColor();
	
	var fragmentShader = """
	uniform color shirtColor;
	uniform color trouwsersColor;
	uniform color shoeColor;
	uniform color hairColor;
	color col = tex(TEXTURE,UV);
	COLOR=col;
	if(col.r==1.0&&col.g==1.0&&col.b==0.0)
	{
		COLOR=hairColor;
	}
	if(col.r==1.0&&col.g==0.0&&col.b==0.0)
	{
		COLOR=shirtColor;
	}
	if(col.r==0.0&&col.g==0.0&&col.b==1.0)
	{
		COLOR=trouwsersColor;
	}
	if(col.r==0.0&&col.g==1.0&&col.b==0.0)
	{
		COLOR=shoeColor;
	}
	"""
	var material = CanvasItemMaterial.new()
	var shader = CanvasItemShader.new()
	shader.set_code("",fragmentShader,"",0,0)
	material.set_shader(shader)
	set_material(material)
	
	get_material().set_shader_param("shirtColor",shirt)
	get_material().set_shader_param("trouwsersColor",panties)
	get_material().set_shader_param("shoeColor",shoes)
	get_material().set_shader_param("hairColor",hairC)
	_room = get_tree().get_nodes_in_group("lectureRoom")[0]
	
	var currentCellIdx = _room.coordToCellIdx(get_pos())
	var currentTile = _room.getTileName(currentCellIdx)
	var screenSize = get_viewport().get_rect().size
	
	if currentTile == "Floor":
		if get_pos().x <= screenSize.x/2:
			setState(State.WALK_R)
		else:
			setState(State.WALK_L)
	elif currentTile == "Stair":
		if get_pos().y <= screenSize.y/2:
			setState(State.WALK_U)
		else:
			setState(State.WALK_D)

func isSeated():
	return state == State.SITTING

func setState(s):
	state = s
	if state == State.WALK_D:
		if sex == "male":
			set_animation("WalkingMaleBack")
		else:
			set_animation("WalkingFemaleBack")
		set_frame(0)
	elif state != State.SITTING:
		if sex == "male":
			set_animation("WalkingMaleFront")
		else:
			set_animation("WalkingFemaleFront")
		set_frame(0)
	else:
		set_animation("front")
		if sex == "male":
			set_frame(0)
		else:
			set_frame(1)
			
	
func getState():
	return state

func moveToCell(cellIdx):
	set_pos(_room.map_to_world(cellIdx) + _room.get_cell_size()/2)
	
func _fixed_process(delta):
	if state != State.SITTING:
		walkTimer += delta
		if walkTimer > walkAnimSpeed:
			walkTimer -= walkAnimSpeed
			if get_frame() == 0:
				set_frame(1)
			else:
				set_frame(0)
	else:
		walkTimer = 0
	
	var currentCellIdx = _room.coordToCellIdx(get_pos())
	var currentTile = _room.getTileName(currentCellIdx)
	var walkDir = Vector2()
	if state == State.WALK_L:
		walkDir.x = -1
	elif state == State.WALK_R:
		walkDir.x = 1
	elif state == State.WALK_D:
		walkDir.y = -1
	elif state == State.WALK_U:
		walkDir.y = 1
		
	set_pos(get_pos() + walkDir * walkSpeed * delta)
	
	var p = get_pos()
	var ss = _room.get_used_rect().size * _room.get_cell_size()
	var usedCellsRect = _room.get_used_rect()
	
	if p.x <= 0:
		setState(State.WALK_R)
		moveToCell(Vector2(1, currentCellIdx.y))
		
	elif p.x >= ss.x:
		setState(State.WALK_L)
		moveToCell(Vector2(usedCellsRect.end.x-1, currentCellIdx.y))
		
	elif p.y <= 0:
		setState(State.WALK_U)
		moveToCell(Vector2(currentCellIdx.x, 1))
		
	elif p.y >= ss.y:
		setState(State.WALK_D)
		moveToCell(Vector2(currentCellIdx.x, usedCellsRect.end.y-1))
		
	else:
		var newCellIdx = _room.coordToCellIdx(get_pos())
		var newTile = _room.getTileName(newCellIdx)
		if (state == State.WALK_D || state == State.WALK_U) &&  !(WALKABLE_TILES[newTile] & Walkable.VRT):
			moveToCell(currentCellIdx)
			if state == State.WALK_D:
				setState(State.WALK_U)
			else:
				setState(State.WALK_D)
		elif (state == State.WALK_L || state == State.WALK_R) && !(WALKABLE_TILES[newTile] & Walkable.HRZ):
			moveToCell(currentCellIdx)
			if state == State.WALK_L:
				setState(State.WALK_R)
			else:
				setState(State.WALK_L)
				
	_updateActiveDisturbAction(delta)

# cell index of feet
func _getCurrentTilePos():
	return get_pos() / _room.get_cell_size()
	
func _onClick(btn):
	var currentCellIdx = _room.coordToCellIdx(get_pos())
	var currentTile = _room.getTileName(currentCellIdx)
	
	var offset = -1
	if btn == 2:
		offset = 1
	
	var nIdx = Vector2()
	if state == State.WALK_L || state == State.WALK_R:
		setState( State.WALK_R + offset )
		
	else:
		setState(State.WALK_U + offset)
		
	moveToCell(currentCellIdx)
	
	if currentTile == "Chair":
		moveToCell(currentCellIdx)
		setState(State.SITTING)
		

func setActiveDisturbAction(action):
	activeDisturbAction = action
	
func _updateActiveDisturbAction(delta):
	if activeDisturbAction != null:
		if activeDisturbAction.disturbTime > 0:
		# when disturbTime is initialized with 0, then the disturb is permanent
		# and should end when student leaves the room!
			disturbTimer += delta
			if disturbTimer >= activeDisturbAction.disturbTime:
				disturbTimer = 0.0
				_resetDisturbAction(true)

func _resetDisturbAction(resetMood):
	# delete sprites belonging to disturb action
	for c in disturbChildNodes.get_children():
		c.queue_free()
	# reset mood of professor
	if resetMood == true:
		var professor = get_node("../../Professor/profBody")
		professor.changeMood(activeDisturbAction.disturbValue)
	# delete disturb action instance
	activeDisturbAction = null

# checks if student is currently disturbing
func isDisturbActionActive():
	return activeDisturbAction != null
