extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
    connect("on_area_enter",self,"body_enter")

func body_enter(body):
    print(body.get_name())

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass
