extends Spatial

var speed
var target_pos_l = null
var target_pos_r = null
var test

func _ready():
	pass	

func _process(delta):
	
	get_node("GloveL").get_transform().basis.x[0] +=1