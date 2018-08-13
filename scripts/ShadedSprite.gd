extends Sprite

func setColors(shirtCol, pantsCol, shoeCol, hairCol):
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
	
	get_material().set_shader_param("shirtColor",shirtCol)
	get_material().set_shader_param("trouwsersColor",pantsCol)
	get_material().set_shader_param("shoeColor",shoeCol)
	get_material().set_shader_param("hairColor",hairCol)
	#get_material().set_shader_param("shadeTex", frame)
