extends Spatial

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    pass


#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

#        transform = dodge.get_transform()
#        transform.origin += Vector3(delta,0,0)
#        dodge.set_transform(transform)

func _physics_process(delta):
    for dodge in get_children():
        dodge.translate(Vector3(0,0,delta))