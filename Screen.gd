extends Spatial

var onColor = Color("ff0000")  
var offColor = Color("000000")  

func _ready():
    createPoint(true, Vector3(0, 1, 0))
    createPoint(false, Vector3(0, 0, 0))

func createPoint(emission, position):
    var mesh = MeshInstance.new()
    mesh.set_scale(Vector3(0.2, 0.2, 0.2))
    mesh.translation = position
    
    var sphere = SphereMesh.new()
    var material = SpatialMaterial.new()
    material.metallic_specular = 0
    
    if emission:
        material.albedo_color = onColor
        material.emission_enabled = true
        material.emission = onColor
        material.emission_energy = 16
    else:
        material.albedo_color = offColor
        material.emission_enabled = false 
    
    sphere.set_material(material)    
    
    mesh.set_mesh(sphere)
    get_node("Slot").add_child(mesh)
