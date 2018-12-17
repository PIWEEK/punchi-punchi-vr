extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"


func hit():
    var mesh = get_node("CollisionShape/MeshInstance")
    
    var material = SpatialMaterial.new()
    # material.flags_transparent = true
    material.albedo_color = Color(0, 255, 0, 1)
    mesh .set_surface_material(0, material)    
    
func crouch():
    self.rotation_degrees = Vector3(0, 0, 90)    
    
func right():
    self.rotation_degrees = Vector3(0, 0, 50)    
    
func left():
    self.rotation_degrees = Vector3(0, 0, 130)    
    

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass
