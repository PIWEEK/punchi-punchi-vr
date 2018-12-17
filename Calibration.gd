extends Spatial

var leftHand
var rightHand

var currentStep = 1
var root

func _ready():
    root = get_node("/root/global");
    root.initVR()
    
    leftHand = get_node("Player/LeftController")
    leftHand.connect("button_pressed", self, "buttonPressed")
    
    rightHand = get_node("Player/RightController")
    rightHand.connect("button_pressed", self, "buttonPressed")
    
    get_node("Spatial/Step1").show();
    get_node("Spatial/Step2").hide();
        
func buttonPressed(id):	
    print(id)
    
    if (id == 15 && currentStep == 1):
        step1SaveHandsPosition()
        get_node("Spatial/Step1").hide()
        get_node("Spatial/Step2").show()
        currentStep = 2
    elif (id == 15 && currentStep == 2):
        step2SaveHandsPosition()
        root.goto_scene("res://PunchiDodge.tscn")
        
func step1SaveHandsPosition():
    root.saveIdleHandsPosition(leftHand.translation, rightHand.translation)
    
func step2SaveHandsPosition():
    root.saveFightHandsPosition(rightHand.translation)