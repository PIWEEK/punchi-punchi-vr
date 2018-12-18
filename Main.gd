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
		

func _process(delta):
    pass
    # var bodies = get_node("Player/ARVRCamera/Head").get_overlapping_bodies()
    # print(bodies);
