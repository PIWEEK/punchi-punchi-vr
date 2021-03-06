extends Spatial

var dodgeScene = load("res://Dodge.tscn")
var hitboxScene = load("res://HitBox.tscn")
var head
var leftHand
var rightHand
var leftHandTouch
var rightHandTouch
var root
var INITIAL_POSITION = -48
var level = 0
var score
var points = 0
var lastHitbox
var limit
var interval
var waitTime  = 1

func _ready():
    root = get_node("/root/global");
    root.initVR()
    root.initGloves(self)
    
    head = get_node("Player/ARVRCamera/Head")
    head.connect("body_entered", self, "body_enter")
    
    leftHand = get_node("Player/LeftController")
    rightHand = get_node("Player/RightController")
    
    leftHandTouch = get_node("Player/LeftController/TouchArea")
    leftHandTouch.connect("body_entered", self, "leftPunch")
    
    rightHandTouch = get_node("Player/RightController/TouchArea")
    rightHandTouch.connect("body_entered", self, "rightPunch")
    
    limit = get_node("Limit")
    limit.connect("body_entered", self, "limitArea")
    
    score = get_node("Score")
    
    interval = root.setInterval(self, "spawn", waitTime)
    score.printScore(points)

func _physics_process(delta):
    #print(Performance.get_monitor(Performance.TIME_FPS))
    var overlappingLeft = leftHandTouch.get_overlapping_bodies()
    var overlappingRight = rightHandTouch.get_overlapping_bodies()
    var speed = 10
    
    for child in get_children():
        if isDodge(child):
            child.translate(Vector3(0, 0, delta * speed))
        elif isHitBox(child):
            if child.touched:
                child.translate(Vector3(0, 0, delta * -1))
            else:
                child.translate(Vector3(0, 0, delta * speed))
    
func isDodge(body):
    return body.get_filename() == dodgeScene.get_path()
    
func isHitBox(body):
    return body.get_filename() == hitboxScene.get_path()

# head
func body_enter(body): 
    if isDodge(body) or isHitBox(body):
        if points > 0:
            points = points - 1
            score.printScore(points)
            
        self.remove_child(body)
    
func stopRumble():
    leftHand.rumble = 0
    rightHand.rumble = 0    
        
func leftPunch(body): 
    if isHitBox(body) and !body.touched:
        body.translation.z = leftHand.translation.z
        leftHand.rumble = 1
        body.hit()   
        root.setTimeout(self, "stopRumble", 0.25)
        
        if points < 100:
            points = points + 1
            score.printScore(points)    
    
func rightPunch(body): 
    if isHitBox(body) and !body.touched:
        body.translation.z = rightHand.translation.z
        rightHand.rumble = 1
        body.hit()       
        root.setTimeout(self, "stopRumble", 0.25)
        
        if points < 100:
            points = points + 1
            score.printScore(points)    
    
func increaseLevel():
    if level < 100:
        if level == 10:
            waitTime = waitTime - 0.1
            interval.set_wait_time(waitTime)
        elif level == 20:
            waitTime = waitTime - 0.1
            interval.set_wait_time(waitTime)
        elif level == 30:
            waitTime = waitTime - 0.1
            interval.set_wait_time(waitTime)
        elif level == 40:
            waitTime = waitTime - 0.1
            interval.set_wait_time(waitTime)
        elif level == 50:
            waitTime = waitTime - 0.1
            interval.set_wait_time(waitTime)
        elif level == 60:
            waitTime = waitTime - 0.1
            interval.set_wait_time(waitTime)
        elif level == 70:
            waitTime = waitTime - 0.1
            interval.set_wait_time(waitTime)                        
        elif level == 80:
            waitTime = waitTime - 0.1
            interval.set_wait_time(waitTime)                                    
            
        level = level + 1
    else:
        print("limit")
        
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
       hitbox.dir("center")
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
    
    if !lastHitbox:
        get_node("AudioStreamPlayer").play()
    
    lastHitbox = hitbox
    
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
    
func limitArea(body):
    if isHitBox(body):
        if points > 0:
            points = points - 1
            score.printScore(points)
            
    self.remove_child(body)

# func _process(delta):
#    var bodies = get_node("Player/ARVRCamera/Head").get_overlapping_bodies()
#    print(bodies);