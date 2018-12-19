extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	
    var VR = ARVRServer.find_interface("OpenVR")
    if VR and VR.initialize():
        get_viewport().arvr = true
        get_viewport().hdr = false
    
        OS.vsync_enabled = false
        Engine.target_fps = 90
        
        var material = SpatialMaterial.new()
        material.albedo_color = Color(0, 0, 255, 1)
        get_node("Player/LeftController/GloveL").set_surface_material(0, material)
        get_node("Player/LeftController/GloveL").show()

        material = SpatialMaterial.new()
        material.albedo_color = Color(255, 0, 0, 1)
        get_node("Player/RightController/GloveR").set_surface_material(0, material)
        get_node("Player/RightController/GloveR").show()


func _process(delta):
    pass
    # var bodies = get_node("Player/ARVRCamera/Head").get_overlapping_bodies()
    # print(bodies);
