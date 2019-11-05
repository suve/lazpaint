from lazpaint import tools, image, layer

image.new(800, 600)

tools.choose(tools.PEN)
tools.mouse( (50,50) )
tools.mouse( [(50,100, 0.5), (100,100, 0.5)], [tools.STATE_RIGHT] )

tools.choose(tools.ELLIPSE)
tools.mouse( [(150,50), (250,150)], [tools.STATE_RIGHT] )
tools.keys(tools.KEY_RETURN)

tools.choose(tools.TEXT)
tools.mouse( [(50,150), (450,350)] )
tools.write("Hello\nworld")

layer.new()

tools.choose(tools.TEXTURE_MAPPING)
tools.mouse( [(300,50), (450,200)], [tools.STATE_LEFT, tools.STATE_SHIFT] )
tools.mouse( [(300,50), (350,80)] )
tools.keys(tools.KEY_RETURN)
