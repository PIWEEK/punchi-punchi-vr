extends Spatial

var timer 
var dodgeScene = load("res://Dodge.tscn")
var hitboxScene = load("res://HitBox.tscn")
var head
var leftHand
var rightHand
var leftHandTouch
var rightHandTouch
var root

func _ready():
    root = get_node("/root/global");
    root.initVR()
    
    head = get_node("Player/ARVRCamera/Head")
    head.connect("body_entered", self, "body_enter")
    
    leftHand = get_node("Player/LeftController")
    rightHand = get_node("Player/RightController")
    
    leftHandTouch = get_node("Player/LeftController/TouchArea")
    leftHandTouch.connect("body_entered", self, "punch")
    
    rightHandTouch = get_node("Player/RightController/TouchArea")
    rightHandTouch.connect("body_entered", self, "punch")
    
    timer = Timer.new()
    timer.autostart = true
    timer.set_wait_time(2)
    timer.connect("timeout", self, "spawn")
    add_child(timer)

func _physics_process(delta):
    for child in get_children():
        if child.get_filename() == dodgeScene.get_path() or child.get_filename() == hitboxScene.get_path():
            child.translate(Vector3(0, 0, delta * 2))
            
            #var pos = child.get_transform()
            #pos.origin += pos.basis.z * (delta * 7)
            #child.set_transform(pos)
            #print(child.get_filename())
            #print(child.get_transform())
    
func isDodge(body):
    return body.get_filename() == dodgeScene.get_path()
    
func isHitBox(body):
    return body.get_filename() == hitboxScene.get_path()

func body_enter(body): 
    if isDodge(body) or isHitBox(body):
        # body.hit()
        print('head hit!')
        self.remove_child(body)
        
func punch(body): 
    if isDodge(body) or isHitBox(body):
        # body.hit()
        body.get_parent().rumble = 1
        
        # print('hand hit!')
        self.remove_child(body)        
    
func createDodge(type):
    var dodge = dodgeScene.instance()
    dodge.translation = Vector3(0, root.fightRightHandPosition.y + 0.5, -8)
    
    if type == "crouch":
        dodge.crouch()
    elif type == 'left':
        dodge.left()
    else:
        dodge.right()
        
    add_child(dodge)
    
func createHitBox(position):
    var htibox = hitboxScene.instance()
    
    var y
    var x = 0
    
    if position == 0: # top
       y = root.fightRightHandPosition.y + 0.5
       x = 0
    elif position == 1: # top left
       y = root.fightRightHandPosition.y + 0.25
       x = -0.5
    elif position == 2: # top right
       y = root.fightRightHandPosition.y + 0.25
       x = 0.5
    elif position == 3: # bottom left
       y = root.fightRightHandPosition.y
       x = -0.5
    elif position == 4: # bottom right
       y = root.fightRightHandPosition.y
       x = 0.5            
    
    htibox.translation = Vector3(x, y, -8)
    
    add_child(htibox)
    
    htibox.hit()
    
func spawn(): 
    var randomFigure = randi() % 9
    
    if randomFigure > 6:
        var randomNum = randi() % 3
    
        if randomNum == 0:
            createDodge("crouch")
        elif randomNum == 1:
            createDodge("right")
        else:
            createDodge("left")
    else:
        var hitBoxPosition = randi() % 5
        createHitBox(hitBoxPosition);
    

# func _process(delta):
#    var bodies = get_node("Player/ARVRCamera/Head").get_overlapping_bodies()
#    print(bodies);