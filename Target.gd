extends StaticBody

var hand = 1
var base_color = Color(255, 0, 0, 1)
var touch_color = Color(0, 255, 0, 1)

func _ready():
	var material = SpatialMaterial.new()
	material.albedo_color = base_color
	get_node("CollisionShape/MeshInstance").set_surface_material(0, material)
	set_physics_process(false)

func set_hand(h):
	self.hand = h
	
func set_base_color(c):
	self.base_color = c
	self.get_node("CollisionShape/MeshInstance").get_surface_material(0).albedo_color = base_color

func set_touch_color(c):
	self.touch_color = c

func touch():
	self.get_node("CollisionShape/MeshInstance").get_surface_material(0).albedo_color = touch_color
	
func untouch():
	self.get_node("CollisionShape/MeshInstance").get_surface_material(0).albedo_color = base_color