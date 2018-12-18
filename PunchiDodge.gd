extends Spatial

var dodgeScene = load("res://Dodge.tscn")
var hitboxScene = load("res://HitBox.tscn")
var head
var leftHand
var rightHand
var leftHandTouch
var rightHandTouch
var root
var INITIAL_POSITION = -32
var level = 0

func _ready():
    root = get_node("/root/global");
    root.initVR()
    
    head = get_node("Player/ARVRCamera/Head")
    head.connect("body_entered", self, "body_enter")
    
    leftHand = get_node("Player/LeftController")
    rightHand = get_node("Player/RightController")
    
    leftHandTouch = get_node("Player/LeftController/TouchArea")
    leftHandTouch.connect("body_entered", self, "leftPunch")
    
    rightHandTouch = get_node("Player/RightController/TouchArea")
    rightHandTouch.connect("body_entered", self, "rightPunch")
    
    root.setInterval(self, "spawn", 1)

func _physics_process(delta):
    var speed = 9 + (level * 0.5)
    for child in get_children():
        if isDodge(child):
            child.translate(Vector3(0, 0, delta * speed))
        elif isHitBox(child):
            if child.touched:
                child.translate(Vector3(0, 0, delta * -8))
            else:
                # print(speed)
                child.translate(Vector3(0, 0, delta * speed))
            
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
        self.remove_child(body)
        
func leftPunch(body): 
    leftHand.rumble = 1
    body.hit()   
    root.setTimeout(self, "stopRumble", 0.5)
    
func rightPunch(body): 
    rightHand.rumble = 1
    body.hit()       
    root.setTimeout(self, "stopRumble", 0.5)
    
func increaseLevel():
    if level < 50:
        level = level + 1
        
func stopRumbe():
    leftHand.rumble = 0
    rightHand.rumble = 0
    
func createDodge(type):
    var dodge = dodgeScene.instance()
    dodge.translation = Vector3(0, root.fightRightHandPosition.y + 0.5, INITIAL_POSITION)
    
    if type == "crouch":
        dodge.crouch()
    elif type == 'left':
        dodge.left()
    else:
        dodge.right()
        
    add_child(dodge)
    increaseLevel()
    
func createHitBox(position):
    var hitbox = hitboxScene.instance()
    
    var y
    var x = 0
    
    if position == 0: # top
       y = root.fightRightHandPosition.y + 0.5
       x = 0
    elif position == 1: # top left
       y = root.fightRightHandPosition.y + 0.25
       x = -0.5
       hitbox.dir("left")
    elif position == 2: # top right
       y = root.fightRightHandPosition.y + 0.25
       x = 0.5
       hitbox.dir("right")
    elif position == 3: # bottom left
       y = root.fightRightHandPosition.y
       x = -0.5
       hitbox.dir("left")
    elif position == 4: # bottom right
       y = root.fightRightHandPosition.y
       x = 0.5            
       hitbox.dir("right")
    
    hitbox.translation = Vector3(x, y, INITIAL_POSITION)
    
    add_child(hitbox)
    increaseLevel()
    
func spawn(): 
    var randomFigure = randi() % 9
    
    if randomFigure > 7:
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