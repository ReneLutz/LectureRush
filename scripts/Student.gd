extends AnimatedSprite

export var walkSpeed = 50
export var walkSpeedLeaving = 200

export var sex = "female"

enum State { SITTING = 0, WALK_L, WALK_U, WALK_R, WALK_D }

enum Walkable { NONE = 0, HRZ, VRT, BOTH }

const WALKABLE_TILES = { "Floor1": Walkable.NONE, "Floor2": Walkable.NONE, "Floor3": Walkable.NONE, "Chair": Walkable.HRZ, "Stair": Walkable.BOTH }

const ENTER_R_X = 740
const ENTER_L_X = 40

var gameScript
	
var state = State.SITTING setget setState, getState

var _room
var material

var entering = true

var leaveRoom
var leavingState = 0
var leaveDelay = 0.0
var leaveDelayMax = 0.7

var disturbing
var activeDisturbAction
var pathToStudentsNode
var disturbTimer = 0.0
var walkTimer = 0
export var walkAnimSpeed = 0.2
var disturbChildNodes

var phoneAnimActive = false
var phoneAnimTimer = 0.0
var phoneAnimSpeed = 0.2
var phoneFrame = 0

var sleepAnimActive = false
var sleepAnimTimer = 0.0
var sleepAnimSpeed = 0.2
var sleepFrame = 0

var wasUpstairs = false

# when walking through a row this stores the student
# that's on the seat this student walked past
var lastTrampledStudent = null
const TRAMPLE_Y_OFFSET = 3

func picRandomColor():
	rand_seed(randi())
	var r = randf()
	var g = randf()
	var b = randf()
	return Color(r,g,b,1.0)
	
func isOccupied(idx):
	if not get_parent().occupiedSeats.has(idx):
		return false
	return get_parent().occupiedSeats[idx] != null
	
func occupySeat(idx, val):
	get_parent().occupiedSeats[idx] = val
	
func getStudentOnSeat(idx):
	if get_parent().occupiedSeats.has(idx):
		return get_parent().occupiedSeats[idx]
	else:
		return null
	
func pickHairColor():
	var colors = [Color("#090806"),
			Color("#2C222B"),
			Color("#71635A"),
			Color("#B7A69E"),
			Color("#6a1f16"), #changed
			Color("#d7b144"), #changed
			Color("#e099c6"), #changed light pink
			Color("#6e1769"), #changed
			Color("#b01313"), #changed
			Color("#2d2db9"), #changed
			Color("#E6CEA8"), 
			Color("#DEBC99"),
			Color("#B89778"),
			Color("#A56B46"),
			Color("#B55239"),
			Color("#91553D"),
			Color("#8D4A43"),
			Color("#533D32"),
			Color("#3B3024"),
			Color("#554838"),
			Color("#504444"),
			Color("#6A4E42"),
			Color("#A7856A"), 
			Color("#977961")]
	randomize()
	return colors[randi() % colors.size()]
	
func pickShoeColor(): 
	var colors = [Color("#313a91"),
			Color("#151515"),
			Color("#4f2b24"),
			Color("#795f1b"),
			Color("#524f40"),
			Color("#1b1e29"),
			Color("#dddddd")]
	randomize()
	return colors[randi() % colors.size()]
	
func pickSkinColor():
	var colors = [#Color("#FFDFC4"),
			Color("#F0D5BE"),
			Color("#EECEB3"),
			Color("#E1B899"),
			Color("#E5C298"),
			Color("#FFDCB2"),
			Color("#E5B887"),
			Color("#E5A073"),
			Color("#E79E6D"),
			Color("#DB9065"),
			Color("#CE967C"),
			Color("#C67856"),
			Color("#BA6C49"),
			Color("#A57257"),
			Color("#F0C8C9"),
#			Color("#DDA8A0"),
#			Color("#B97C6D"),
			Color("#DB9065"),]
			
#			Color("#AD6452"),
#			Color("#CB8442"),]
#			Color("#BD723C"),
#			Color("#870400"),
#			Color("#710101"),
#			Color("#430000"),]
	randomize()
	return colors[randi() % colors.size()]

	
func pickPantsColor():
	var colors = [Color("#313a91"),
			Color("#cbe8f7"),
			Color("#a46422"),
			Color("#343434"),
			Color("#9e5b47"),
			Color("#151515"),
			Color("#214e3f"),
			Color("#44aacc"),
			Color("#342a97"),
			Color("#262144"),
			Color("#362747"),
			Color("#091d48"),
			Color("#4c3435"),
			Color("#5f4351"),
			Color("#0d2030"),
			Color("#0d2030"),
			Color("#bfb588"),]
	randomize()
	return colors[randi() % colors.size()]

func _input_event(viewport, event, shape):
	if event.type == InputEvent.MOUSE_BUTTON && event.is_pressed():
		_onClick(event.button_index)
		get_tree().set_input_as_handled()

func _ready():
	set_fixed_process(true)
	set_process_unhandled_input(true)
	
	get_node("Area2D").connect("input_event", self, "_input_event")

	gameScript = get_node("../../../Game")

	pathToStudentsNode = get_node("../../Students")
	# init node holding all sprites generated by a disturb action
	disturbChildNodes = Node2D.new()
	disturbChildNodes.set_name("DisturbSprites")
	add_child(disturbChildNodes)
	
	if sex == "female":
		set_frame(1)
	else:
		set_frame(0)
	var hairC = pickHairColor();
	var shirt = picRandomColor();
	var shoes = pickShoeColor();
	var panties = pickPantsColor();
	
	var fragmentShader = """
	uniform texture shadeTex;
	uniform color shirtColor;
	uniform color trouwsersColor;
	uniform color shoeColor;
	uniform color hairColor;
	uniform color skinColor;
	
	float SHADE_FACTOR = 2;
	
	bool allmost(float v1, float v2, float e)
	{
		return abs(v1-v2)<e;
	}
	
	color col = tex(TEXTURE,UV);
	if(col.r==1.0&&col.g==1.0&&col.b==0.0)
	{
		col=hairColor;
	}
	else {
		if(col.r==1.0&&col.g==0.0&&col.b==0.0)
		{
			col=shirtColor;
		}
		else 
		{
			if(col.r==0.0&&col.g==0.0&&col.b==1.0)
			{
				col=trouwsersColor;
			}
			else {
				if(col.r==0.0&&col.g==1.0&&col.b==0.0)
				{
					col=shoeColor;
				}
				else {
					if(allmost(col.r,238.0/255.0,0.1) &&
						allmost(col.g,195.0/255.0, 0.1) &&
						allmost(col.b,154/255.0, 0.1) )
					{
						col=skinColor;
					}
				}
			}
		}
	}
	
	vec3 shade = tex(shadeTex,UV).xyz;
	if(shade.x != shade.y || shade.x != shade.z || shade.y != shade.z || shade.x == 0 || shade.x == 1) {
		shade = vec3(0.5);
	}
	col += vec4(SHADE_FACTOR * (shade - vec3(0.5)), 0);
	COLOR = col;
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
	get_material().set_shader_param("skinColor",pickSkinColor())
	
	
	_room = get_tree().get_nodes_in_group("lectureRoom")[0]
	
	var currentCellIdx = _room.coordToCellIdx(get_pos())
	var currentTile = _room.getTileName(currentCellIdx)
	var screenSize = get_viewport().get_rect().size
	
	if get_pos().x <= screenSize.x/2:
		setState(State.WALK_R)
	else:
		setState(State.WALK_L)

func isSeated():
	return state == State.SITTING

func set_frame(i):
	.set_frame(i)
	var animName = get_animation() + "Shade"
	var frame = get_sprite_frames().get_frame(animName, i)
	get_material().set_shader_param("shadeTex", frame)

func setState(s):
	if s!=state:
		if s == State.SITTING:
			set_pos(get_pos()+Vector2(0,5))
			occupySeat(_room.coordToCellIdx(get_pos()),self)
			lastTrampledStudent = null
		else:
			occupySeat(_room.coordToCellIdx(get_pos()),null)
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
	set_pos(_room.map_to_world(cellIdx) + _room.get_cell_size()/2 -Vector2(0,10))

func leaveRoom():
	leavingState = 1
	walkSpeed = walkSpeedLeaving
	if activeDisturbAction:
		# show speechbubble of prof
		var professor = get_node("../../Professor/profBody")
		professor.yankOutStudent()
		gameScript.setColorFeedbackGreen()
	else:
		gameScript.setColorFeedbackRed()
		
	leaveRoom = true
	
func _leavingRoom(delta, currentTile):
	var ss = _room.get_used_rect().size * _room.get_cell_size()
	
	if leavingState == 1:
		set_pos(Vector2(get_pos().x, get_pos().y - 5))
		leavingState = 2
		
	elif leavingState == 2:
		leaveDelay += delta
		if leaveDelay >= leaveDelayMax:
			leavingState = 3
		
	elif leavingState == 3:
		if get_pos().x < ss.x / 2.0:
			setState(State.WALK_L)
		else:
			setState(State.WALK_R)
		if currentTile == "Stair":
			if get_pos().x < 50 || get_pos().x > ss.x - 50:
				setState(State.WALK_U)
				leavingState = 4
			
	elif leavingState == 4:
		if currentTile.begins_with("Floor"):
			# _deleteSelf()
			leavingState = 5
			if get_pos().x < ss.x / 2.0:
				setState(State.WALK_L)
			else:
				setState(State.WALK_R)
			# leaveRoom = false
			
	elif leavingState == 5:
		if get_pos().x < -30 or get_pos().x > ss.x:
			_deleteSelf()
			leaveRoom = false
			leavingState = 6
		
	
func _deleteSelf():
	_resetDisturbAction(true)
	self.queue_free()

func _fixed_process(delta):
	if get_parent().studentClicked:
		get_parent().studentClicked = false
	
	set_z(int(min(46,(_getCurrentTilePos().y-2)*5 + 2)))
	
	if state != State.SITTING:
		if state == State.WALK_D:
			set_z(get_z() + 2)
		else:
			set_z(get_z() + 1)
			
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
	
	if leaveRoom == true:
		_leavingRoom(delta, currentTile)
		
	var p = get_pos()
	var ss = _room.get_used_rect().size * _room.get_cell_size()
	var usedCellsRect = _room.get_used_rect()
	
	if entering:
		if state == State.WALK_R && p.x >= ENTER_L_X || state == State.WALK_L && p.x <= ENTER_R_X:
			entering = false
			if p.y < get_viewport().get_rect().size.y / 2:
				setState(State.WALK_U)
			else:
				setState(State.WALK_D)
		return
		
	elif p.x <= 0 and !leaveRoom:
		setState(State.WALK_R)
		moveToCell(Vector2(1, currentCellIdx.y))
		
	elif p.x >= ss.x and !leaveRoom:
		setState(State.WALK_L)
		moveToCell(Vector2(usedCellsRect.end.x-1, currentCellIdx.y))
		
	elif p.y <= 64:
		setState(State.WALK_U)
		moveToCell(Vector2(currentCellIdx.x, currentCellIdx.y))
		wasUpstairs = true
		
	elif p.y >= 300 and !leaveRoom:
		if wasUpstairs:
			leaveRoom = true
			leavingState = 3
		else:
			setState(State.WALK_D)
			moveToCell(Vector2(currentCellIdx.x, usedCellsRect.end.y-1))
		
	elif not leaveRoom:
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
				
		if(state == State.WALK_L || state == State.WALK_R):
			var trampled = null
			if newTile == "Chair":
				trampled = getStudentOnSeat(newCellIdx)
				if trampled != null && trampled != lastTrampledStudent:
					trampled.set_pos(trampled.get_pos() - Vector2(0, TRAMPLE_Y_OFFSET))
				
			if lastTrampledStudent != null && trampled != lastTrampledStudent:
				lastTrampledStudent.set_pos(lastTrampledStudent.get_pos() + Vector2(0, TRAMPLE_Y_OFFSET))
				
			lastTrampledStudent = trampled
			
	_updateActiveDisturbAction(delta)
	
	if phoneAnimActive:
		phoneAnimTimer += delta
		if phoneAnimTimer >= phoneAnimSpeed:
			phoneAnimTimer = 0.0
			phoneFrame += 1
			if phoneFrame > 8:
				phoneFrame = 0
			set_frame(phoneFrame)
			
	elif sleepAnimActive:
		sleepAnimTimer += delta
		if sleepAnimTimer >= sleepAnimSpeed:
			sleepAnimTimer = 0.0
			sleepFrame += 1
			if sleepFrame > 8:
				sleepFrame = 0
			set_frame(sleepFrame)
			

# cell index of feet
func _getCurrentTilePos():
	return get_pos() / _room.get_cell_size()
	
func _onClick(btn):
	if !leaveRoom:
		var currentCellIdx = _room.coordToCellIdx(get_pos())
		var currentTile = _room.getTileName(currentCellIdx)
		var ss = _room.get_used_rect().size * _room.get_cell_size()

		if !get_parent().studentClicked:
			get_parent().studentClicked = true
			var currentCellIdx = _room.coordToCellIdx(get_pos())
			var currentTile = _room.getTileName(currentCellIdx)
			var ss = _room.get_used_rect().size * _room.get_cell_size()
			
			if currentTile == "Chair":
				if btn == BUTTON_RIGHT:
					if isSeated():
						leaveRoom()
				else:
					if !isSeated() && !isOccupied(currentCellIdx):
						moveToCell(currentCellIdx)
						_takeSeat()
						
			else:
				if currentTile == "Stair":
					moveToCell(currentCellIdx)
					# move to row 
					if get_pos().x < ss.x / 2.0:
						setState(State.WALK_R)
					else:
						setState(State.WALK_L)

func _takeSeat():
	setState(State.SITTING)
	gameScript.setColorFeedbackGreen()
	
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
	if activeDisturbAction != null:
		# delete sprites belonging to disturb action
		for c in disturbChildNodes.get_children():
			c.queue_free()
		# reset mood of professor
		if resetMood == true:
			var professor = get_node("../../Professor/profBody")
			professor.changeMood(activeDisturbAction.disturbValue)
		# delete disturb action instance
		activeDisturbAction = null
		# special for disturb actions with animations:
		phoneAnimActive = false
		sleepAnimActive = false
		# reset frame
		set_animation("front")
		if sex == "male":
			set_frame(0)
		else:
			set_frame(1)

# checks if student is currently disturbing
func isDisturbActionActive():
	return activeDisturbAction != null

func setPhoneAnimation(animate):
	phoneAnimActive = animate
	

func setSleepAnimation(animate):
	sleepAnimActive = animate