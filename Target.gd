extends StaticBody

var hand = 1
var base_color = Color(255, 0, 0, 1)
var touch_color = Color(0, 255, 0, 1)
var inactive_color = Color(0, 0, 0, 1)
var hit = 0
var material


func _ready():
	material = SpatialMaterial.new()
	material.albedo_color = inactive_color
	get_node("CollisionShape/MeshInstance").set_surface_material(0, material)
	set_physics_process(false)

func set_hand(h):
	self.hand = h
	
func set_base_color(c):
	self.base_color = c

func set_touch_color(c):
	self.touch_color = c

func set_hit(h):
	self.hit = h

func touch():
	material.albedo_color = touch_color
	
func untouch():
	material.albedo_color = base_color
	
func set_inactive():
	material.albedo_color = inactive_color

func set_active():
	if material.albedo_color == inactive_color:
		material.albedo_color = base_color