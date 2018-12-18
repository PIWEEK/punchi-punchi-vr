extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var touched = false

func _ready():
    get_node("SpatialPunch").hide()

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func hit(): 
    touched = true
    get_node("SpatialPunch").show()
    get_node("AnimationPlayer").play("Punch")
    remove_child(get_node("Spatial"))

func _on_AnimationPlayer_animation_finished(anim_name):
    get_parent().remove_child(self)

func dir(direction):
    if direction == 'left':
        get_node("Spatial").left()
    elif direction == 'right':
        get_node("Spatial").right()
    else:
        get_node("Spatial").both()
        