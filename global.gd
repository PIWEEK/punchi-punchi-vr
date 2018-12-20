extends Node

var currentScene = null
var idleLeftHandPosition = Vector3(0, 1, 0)
var idleRightHandPosition  = Vector3(0, 1, 0)
var fightRightHandPosition  = Vector3(0, 1.6, 0)

func _ready():
    var root = get_tree().get_root()
    currentScene = root.get_child(root.get_child_count() -1)

func goto_scene(path):
    call_deferred("_deferred_goto_scene", path)

func _deferred_goto_scene(path):
    # Immediately free the current scene,
    # there is no risk here.
    currentScene.free()

    # Load new scene.
    var s = ResourceLoader.load(path)

    # Instance the new scene.
    currentScene = s.instance()

    # Add it to the active scene, as child of root.
    get_tree().get_root().add_child(currentScene)

    # Optional, to make it compatible with the SceneTree.change_scene() API.
    get_tree().set_current_scene(currentScene)

func saveIdleHandsPosition(leftHandPosition, rightHandPosition):
    idleLeftHandPosition = leftHandPosition
    idleRightHandPosition  = rightHandPosition
    
func saveFightHandsPosition(rightHandPosition):    
    fightRightHandPosition  = rightHandPosition
    
func initVR():
    var VR = ARVRServer.find_interface("OpenVR")
    if VR and VR.initialize():
        get_viewport().arvr = true
        get_viewport().hdr = false
    
        OS.vsync_enabled = false
        Engine.target_fps = 90

func init_gloves(player):
    var material = SpatialMaterial.new()
    material.albedo_color = Color(0, 0, 255, 1)
    player.get_node("LeftController/GloveL").set_surface_material(0, material)
    player.get_node("LeftController/GloveL").show()

    material = SpatialMaterial.new()
    material.albedo_color = Color(255, 0, 0, 1)
    player.get_node("RightController/GloveR").set_surface_material(0, material)
    player.get_node("RightController/GloveR").show()
        
func setTimeout(context, function, time):
    var timer = Timer.new()
    timer.autostart = true
    timer.set_wait_time(time)
    timer.one_shot = true
    timer.connect("timeout", context, function)
    context.add_child(timer)
    
    return timer
    
func setInterval(context, function, time):
    var timer = Timer.new()
    timer.autostart = true
    timer.set_wait_time(time)
    timer.connect("timeout", context, function)
    context.add_child(timer)
    return timer    