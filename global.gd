extends Node

var currentScene = null
var idleLeftHandPosition = Vector3(0, 1, 0)
var idleRightHandPosition  = Vector3(0, 1, 0)
var fightRightHandPosition  = Vector3(0, 1.6, 0)

var JAB = 0
var CROSS = 1
var LEFT_HOOK = 2
var RIGHT_HOOK = 3
var LEFT_UPPER = 4
var RIGHT_UPPER = 5
var PAUSE = 6

var HIT_NAMES = ["JAB", "CROSS", "L HOOK", "R HOOK", "L UPPER", "R UPPER", "WAIT"]
var COREOS = [
	[JAB, PAUSE, CROSS, PAUSE, JAB, PAUSE, CROSS, PAUSE],
	[LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE],
	[JAB, PAUSE, CROSS, PAUSE, JAB, PAUSE, CROSS, PAUSE, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE],
	[JAB, JAB, CROSS, PAUSE, JAB, JAB, CROSS, PAUSE],
	[LEFT_UPPER, LEFT_HOOK, RIGHT_UPPER, RIGHT_HOOK, LEFT_UPPER, LEFT_HOOK, RIGHT_UPPER, RIGHT_HOOK],
	[JAB, JAB, CROSS, PAUSE, JAB, JAB, CROSS, PAUSE, LEFT_UPPER, LEFT_HOOK, RIGHT_UPPER, RIGHT_HOOK, LEFT_UPPER, LEFT_HOOK, RIGHT_UPPER, RIGHT_HOOK],
	[JAB, CROSS, LEFT_UPPER, PAUSE, CROSS, JAB, RIGHT_UPPER, PAUSE],
	[LEFT_HOOK, RIGHT_HOOK, LEFT_UPPER, RIGHT_UPPER, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE],
	[JAB, CROSS, LEFT_UPPER, PAUSE, CROSS, JAB, RIGHT_UPPER, PAUSE, LEFT_HOOK, RIGHT_HOOK, LEFT_UPPER, RIGHT_UPPER, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE]
]

var SONGS = ["ironbacon.ogg", "electrodoodle.ogg", "beachfront.ogg"]

var current_coreo = COREOS[0]
var current_song = SONGS[0]

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

func initGloves(node):
    node.get_node("Player/LeftController/GloveL").show()
    node.get_node("Player/RightController/GloveR").show()	
#    var material = SpatialMaterial.new()
#    material.albedo_color = Color(0, 0, 255, 1)
#    node.get_node("Player/LeftController/GloveL").set_surface_material(0, material)
#    node.get_node("Player/LeftController/GloveL").show()
#
#    material = SpatialMaterial.new()
#    material.albedo_color = Color(255, 0, 0, 1)
#    node.get_node("Player/RightController/GloveR").set_surface_material(0, material)
#    node.get_node("Player/RightController/GloveR").show()