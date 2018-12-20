extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var touched = false
var particles
var root

func _ready():
    root = get_node("/root/global");
    particles = get_node("Particles")
    particles.emitting = false
    get_node("SpatialPunch").hide()

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func hit(): 
    if !touched:
        touched = true
        get_node("Spatial").hide()
        particles.emitting = true
        particles.one_shot = true
        
        root.setTimeout(self, "destroy", particles.lifetime + 0.25)
        #get_node("SpatialPunch").show()
        #get_node("AnimationPlayer").play("Punch")

func _on_AnimationPlayer_animation_finished(anim_name):
    get_parent().remove_child(self)
    
func destroy():
    get_parent().remove_child(self)

func dir(direction):
    if direction == 'left':
        get_node("Spatial").left()
    elif direction == 'right':
        get_node("Spatial").right()
    else:
        get_node("Spatial").both()
        