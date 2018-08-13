extends AnimatedSprite

func picRandomColor():
	var r = randf()
	var g = randf()
	var b = randf()
	return Color(r,g,b,1.0)
	
func pickHairColor():
	var colors = [
		Color("#090806"),
		Color("#2C222B"),
		Color("#dcdcdc"),
		Color("#B7A69E"),
		Color("#1a1f16"),
	]
	return colors[randi() % colors.size()]
	
func pickShoeColor(): 
	var colors = [
		Color("#313a91"),
		Color("#151515"),
		Color("#4f2b24"),
		Color("#795f1b"),
		Color("#524f40"),
		Color("#1b1e29"),
		Color("#dddddd")
	]
	return colors[randi() % colors.size()]
	
func pickPantsColor():
	var colors = [
		Color("#313a91"),
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
		Color("#bfb588"),
	]
	return colors[randi() % colors.size()]

var animStart
var frameCount
var animSpeed
func play(animName):
	if animName != get_animation():
		set_animation(animName)
		set_frame(0)
		animStart = OS.get_ticks_msec()
		frameCount = get_sprite_frames().get_frame_count(animName)
		animSpeed = get_sprite_frames().get_animation_speed(animName)

func set_frame(i):
	.set_frame(i)
	var animName = get_animation() + "Shade"
	var frame = get_sprite_frames().get_frame(animName, i)
	get_material().set_shader_param("shadeTex", frame)
	
func _ready():
	set_process(true)
	randomize()
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
	
	float SHADE_FACTOR = 2;
	
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
	
	get_node("../HeadOnly/Sprite").setColors(shirt, panties, shoes, hairC)
	get_node("../BodyOnly").setColors(shirt, panties, shoes, hairC)

func _process(delta):
	var frame = int((OS.get_ticks_msec() - animStart) / 1000 / animSpeed) % frameCount