extends AnimatedSprite

export var walkSpeed = 600
export var sex = "female"

enum State { SITTING = 0, WALK_L, WALK_R, WALK_U, WALK_D }

var state

var _room
var material

func picRandomColor():
	rand_seed(randi())
	var r = randf()
	var g = randf()
	var b = randf()
	return Color(r,g,b,1.0)

func _ready():
	set_fixed_process(true)
	set_process_unhandled_input(true)
	
	var hairnode = get_node("Hair")
	if sex == "female":
		hairnode.set_frame(0)
	else:
		hairnode.set_frame(1)
	var hairC = picRandomColor();
	var shirt = picRandomColor();
	var shoes = picRandomColor();
	var panties = picRandomColor();
	
	var fragmentShader = """
	uniform color shirtColor;
	uniform color trouwsersColor;
	uniform color shoeColor;
	color col = tex(TEXTURE,UV);
	COLOR=col;
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
	hairnode.set_modulate(hairC)
	_room = get_tree().get_nodes_in_group("lectureRoom")[0]
	
	var currentCellIdx = _room.coordToCellIdx(get_pos())
	var currentTile = _room.getTileName(currentCellIdx)
	var screenSize = get_viewport().get_rect().size
	
	if currentTile == "Floor":
		if get_pos().x <= screenSize.x/2:
			state = State.WALK_R
		else:
			state = State.WALK_L
	elif currentTile == "Stair":
		if get_pos().y <= screenSize.y/2:
			state = State.WALK_U
		else:
			state = State.WALK_D
			
	_onStateChange()
	
func _onStateChange():
	# TODO
	pass

func isSeated():
	return state == State.SITTING
	
func _fixed_process(delta):
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
	var cs = _room.get_cell_size()
	var ss = _room.get_used_rect().size * cs
	
	if p.x <= 0:
		state = State.WALK_R
		set_pos(Vector2(cs.x/2, p.y))
		_onStateChange()
	elif p.x >= ss.x:
		state = State.WALK_L
		set_pos(Vector2(ss.x - cs.x/2, p.y))
		_onStateChange()
	elif p.y <= 0:
		state = State.WALK_U
		set_pos(Vector2(p.x, cs.y/2))
		_onStateChange()
	elif p.y >= ss.y:
		state = State.WALK_D
		set_pos(Vector2(p.x, ss.y - cs.y/2))
		_onStateChange()

# cell index of feet
func _getCurrentTilePos():
	return get_pos() / _room.get_cell_size()
	
	
####### PUBLIC #######

func spawnDisturbAction():
	print("SPAWNING DISTURB ACTION!!!!!!!")
	#TODO spawn random disturb action
	
	pass

func isDisturbActionActive():
	# TODO check if student is currently disturbing
	return false
	
func isSitting_test(): # Remove when isSitting() is implemented
	return true