extends Spatial

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

func both():
    get_node("both").show()
    get_node("left").hide()
    get_node("right").hide()
    
func left():
    get_node("both").hide()
    get_node("left").show()
    get_node("right").hide()    
    
func right():
    get_node("both").hide()
    get_node("left").hide()
    get_node("right").show()    