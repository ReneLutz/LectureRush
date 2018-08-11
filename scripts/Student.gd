extends AnimatedSprite

export var walkSpeed = 1
export var sex = "female"

var _room

var material

func picRandomColor():
	rand_seed(randi())
	var r = randf()
	var g = randf()
	var b = randf()
	return Color(r,g,b,1.0)

func _ready():
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

func _fixed_process(delta):
	var currentTile = _room.getTileName(_room.coordToCellIdx(get_pos()))
	
	if(Input.is_action_pressed("turn_left")):
		pass
	elif(Input.is_action_pressed("turn_right")):
		pass

# cell index of feet
func _getCurrentTilePos():
	return get_pos() / _room.get_cell_size()