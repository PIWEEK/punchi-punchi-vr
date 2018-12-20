extends Spatial

var onColor = "ff0000" 
var offColor = "000000" 
var step = 0.3

var empty = [
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0],
    [0, 0, 0, 0, 0]
]

var numbers = [
    [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1]  
    ],
    [
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1]
    ],
    [
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1]
    ],
    [
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1]
    ],
    
    [
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1]  
    ],
    [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1]  
    ],
    [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1]  
    ],
    [
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 1, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0],
        [0, 0, 1, 0, 0]  
    ],
    [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1]  
    ],
    [
        [1, 1, 1, 1, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 0, 0, 0, 1],
        [1, 1, 1, 1, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [0, 0, 0, 0, 1],
        [1, 1, 1, 1, 1]  
    ]
]

var root
var currentNumber = 0
var panel1
var panel2

func _ready():
    root = get_node("/root/global");
    panel1 = createPanel(Vector3(0, 0, 0), 9, 5)
    panel2 = createPanel(Vector3(2, 0, 0), 9, 5)
    
    add_child(panel1)
    add_child(panel2)
    
    root.setInterval(self, "spawnNumber", 1)

func spawnNumber():
    printNumber(panel1, currentNumber)
    
    if currentNumber < 9:
        currentNumber = currentNumber + 1
    
func createPanel(position, rows, colums):
    var panel = Spatial.new()
    panel.translation = position
    
    for row in range(rows):
        var rowSpatial = Spatial.new()
        for column in range(colums):
            createPoint(rowSpatial, false, Vector3(column * 0.3, row * 0.3, 0))
            
        panel.add_child(rowSpatial)
    return panel
    
func changeStatus(elm, on):
    if on:
        elm.mesh.material.albedo_color = onColor
        elm.mesh.material.emission_enabled = true
        elm.mesh.material.emission = onColor
    else:
        elm.mesh.material.albedo_color = offColor
        elm.mesh.material.emission_enabled = false
        elm.mesh.material.emission = offColor        
    
func createPoint(parent, on, position):
    var mesh = MeshInstance.new()
    var sphere = SphereMesh.new()
    var material = SpatialMaterial.new()
    
    mesh.translation = position
    mesh.scale = Vector3(0.1, 0.1, 0.1)
    
    material.albedo_color = onColor
    material.metallic_specular = 0
    material.flags_unshaded = true
    
    if on:
        material.albedo_color = onColor
        material.emission_enabled = true
        material.emission = onColor
    else:
        material.albedo_color = offColor
        
    sphere.material = material
    mesh.mesh = sphere
    parent.add_child(mesh)
    
func printNumber(panel, number):
    var children = panel.get_children()
    var currentNumber = numbers[number]
        
    currentNumber.invert()
        
    for rowIndex in range(currentNumber.size()):  
        for columnIndex in range(currentNumber[rowIndex].size()):
            if currentNumber[rowIndex][columnIndex] == 1:
                changeStatus(children[rowIndex].get_children()[columnIndex], true)
            else:
                changeStatus(children[rowIndex].get_children()[columnIndex], false)