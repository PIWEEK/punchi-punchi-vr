extends Spatial

var speed
var target_pos_l = null
var target_pos_r = null

var punch_rotation_target = [Vector3(0, 0, 0), Vector3(0, 0, 0)]
var punch_rotation_zero = [Vector3(0, 0, 0), Vector3(0, 0, 0)]
var punch_translation_target = [null, null]
var punch_translation_zero = [Vector3(0, 0, 0), Vector3(0, 0, 0)]
var hits_sequence = []
var gloves = []
var SPEED = 3

func _ready():
	gloves.append(get_node("GloveL"))
	gloves.append(get_node("GloveR"))
	punch_rotation_zero[0].x = gloves[0].get_node("GloveMesh").rotation.x
	punch_rotation_zero[0].y = gloves[0].get_node("GloveMesh").rotation.y
	punch_rotation_zero[0].z = gloves[0].get_node("GloveMesh").rotation.z
	
	punch_rotation_zero[1].x = gloves[1].get_node("GloveMesh").rotation.x
	punch_rotation_zero[1].y = gloves[1].get_node("GloveMesh").rotation.y
	punch_rotation_zero[1].z = gloves[1].get_node("GloveMesh").rotation.z
	
	
	punch_translation_zero[0].x = gloves[0].translation.x
	punch_translation_zero[0].y = gloves[0].translation.y
	punch_translation_zero[0].z = gloves[0].translation.z
	
	punch_translation_zero[1].x = gloves[1].translation.x
	punch_translation_zero[1].y = gloves[1].translation.y
	punch_translation_zero[1].z = gloves[1].translation.z
			
	
func jab():	

	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x - PI / 2, punch_rotation_zero[0].y - PI, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y + 0.2, punch_translation_zero[0].z),
		'speed': 100
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x - PI / 2, punch_rotation_zero[0].y - PI, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y + 0.2, punch_translation_zero[0].z+0.5),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x - PI / 2, punch_rotation_zero[0].y - PI, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y + 0.2, punch_translation_zero[0].z),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x, punch_rotation_zero[0].y, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y, punch_translation_zero[0].z),
		'speed': 1000
	})

func cross():	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x + PI / 2, punch_rotation_zero[1].y, punch_rotation_zero[1].z + PI),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y + 0.2, punch_translation_zero[1].z+0.2),
		'speed': 1000
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x + PI / 2, punch_rotation_zero[1].y, punch_rotation_zero[1].z + PI),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y + 0.2, punch_translation_zero[1].z+0.7),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x + PI / 2, punch_rotation_zero[1].y, punch_rotation_zero[1].z + PI),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y + 0.2, punch_translation_zero[1].z + 0.2),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x, punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y, punch_translation_zero[1].z),
		'speed': 1000
	})



func left_hook():	

	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x - PI / 2, punch_rotation_zero[0].y - PI +1, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y + 0.2, punch_translation_zero[0].z),
		'speed': 100
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x - PI / 2, punch_rotation_zero[0].y - PI + 1, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x + 0.25, punch_translation_zero[0].y + 0.2, punch_translation_zero[0].z+0.25),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x - PI / 2, punch_rotation_zero[0].y - PI - 1, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y + 0.2, punch_translation_zero[0].z+0.5),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x - PI / 2, punch_rotation_zero[0].y - PI, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y + 0.2, punch_translation_zero[0].z),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x, punch_rotation_zero[0].y, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y, punch_translation_zero[0].z),
		'speed': 1000
	})


func right_hook():	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x + PI / 2, punch_rotation_zero[1].y - 1, punch_rotation_zero[1].z + PI),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y + 0.2, punch_translation_zero[1].z+0.2),
		'speed': 1000
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x + PI / 2, punch_rotation_zero[1].y - 1, punch_rotation_zero[1].z + PI),
		'target': Vector3(punch_translation_zero[1].x - 0.25, punch_translation_zero[1].y + 0.2, punch_translation_zero[1].z+0.45),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x + PI / 2, punch_rotation_zero[1].y + 1, punch_rotation_zero[1].z + PI),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y + 0.2, punch_translation_zero[1].z+0.7),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x + PI / 2, punch_rotation_zero[1].y, punch_rotation_zero[1].z + PI),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y + 0.2, punch_translation_zero[1].z + 0.2),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x, punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y, punch_translation_zero[1].z),
		'speed': 1000
	})


func left_upper():	

	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x + PI - 0.5, punch_rotation_zero[0].y, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y, punch_translation_zero[0].z),
		'speed': 100
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x + PI - 0.5, punch_rotation_zero[0].y, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y - 0.25, punch_translation_zero[0].z+0.25),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x + PI/2, punch_rotation_zero[0].y, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y - 0.25, punch_translation_zero[0].z+0.5),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x + 0.5, punch_rotation_zero[0].y, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y, punch_translation_zero[0].z),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x, punch_rotation_zero[0].y, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y, punch_translation_zero[0].z),
		'speed': 1000
	})


func right_upper():	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x - (PI/2) - 0.5, punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y + 0.05, punch_translation_zero[1].z+0.2),
		'speed': 1000
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x - (PI/2) - 0.5, punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y - 0.3, punch_translation_zero[1].z+0.45),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x - (PI/2), punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y - 0.3, punch_translation_zero[1].z+0.7),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x - 0.5, punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y - 0.45, punch_translation_zero[1].z+0.7),
		'speed': 1000
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x - 0.5, punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y - 0.1, punch_translation_zero[1].z + 0.2),
		'speed': SPEED
	})
	
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x, punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y, punch_translation_zero[1].z),
		'speed': 1000
	})

func _process(delta):
	#rotate_punch(delta, 0)
	#rotate_punch(delta, 1)
	
	translate_punch(delta)
	
	
func rotate_punch(delta, glove):
	if len(gloves) > 0:		
		var speed = 0.01
		var amount = delta * speed
		rotate_punch_direction(glove, Vector3(1, 0, 0), amount, 'x')
		rotate_punch_direction(glove, Vector3(0, 1, 0), amount, 'y')
		rotate_punch_direction(glove, Vector3(0, 0, 1), amount, 'z')
					
func rotate_punch_direction(glove, axis, amount, direction):
	var current_rotation = fix_angle(gloves[glove].rotation[direction])
	var target_rotation = fix_angle(punch_rotation_target[glove][direction])
			
	if direction == 'y':
		print("Target: ",target_rotation, "Current: ", current_rotation)
		
	if target_rotation > current_rotation:						
		gloves[glove].rotate(axis, amount)
		if current_rotation >= target_rotation:
			gloves[glove].rotation[direction] = punch_rotation_target[glove][direction]	
			
	elif target_rotation < current_rotation:
		gloves[glove].rotate(axis, -amount)
		if current_rotation <= target_rotation:						
			gloves[glove].rotation[direction] = punch_rotation_zero[glove][direction]
			
	
func translate_punch(delta):
	if len(gloves) > 0:		
		if len(hits_sequence) > 0:
			var speed = hits_sequence[0]['speed']
			var amount = delta * speed
			var ok_x = translate_punch_direction(Vector3(amount, 0, 0), 'x')		
			var ok_y = translate_punch_direction(Vector3(0, amount, 0), 'y')
			var ok_z = translate_punch_direction(Vector3(0, 0, amount), 'z')
			
			if ok_x and ok_y and ok_z:
				hits_sequence.remove(0)		
					
func translate_punch_direction(amount, direction):	
	var glove = hits_sequence[0]['glove']
	gloves[glove].get_node("GloveMesh").rotation =  hits_sequence[0]['rotation']
	punch_translation_target = hits_sequence[0]['target']
	if punch_translation_target[direction] > gloves[glove].translation[direction]:						
		gloves[glove].translate(amount)
		if gloves[glove].translation[direction] >= punch_translation_target[direction]:
			gloves[glove].translation[direction] = punch_translation_target[direction]	
			
	elif punch_translation_target[direction] < gloves[glove].translation[direction]:
		amount = Vector3(-amount.x, -amount.y,-amount.z)
		gloves[glove].translate(amount)
		if gloves[glove].translation[direction] <= punch_translation_target[direction]:						
			gloves[glove].translation[direction] = punch_translation_target[direction]
	
	return gloves[glove].translation[direction] == punch_translation_target[direction]
			
				

func dummy_hit(hit):
	if hit == global.JAB:
		jab()
	elif hit == global.CROSS:
		cross()
	elif hit == global.LEFT_UPPER:
		left_upper()
	elif hit == global.LEFT_HOOK:
		left_hook()
	elif hit == global.RIGHT_UPPER:
		right_upper()
	elif hit == global.RIGHT_HOOK:
		right_hook()	
		
func reset():
	hits_sequence.clear()
	hits_sequence.append({
		'glove': 0,
		'rotation': Vector3(punch_rotation_zero[0].x, punch_rotation_zero[0].y, punch_rotation_zero[0].z),
		'target': Vector3(punch_translation_zero[0].x, punch_translation_zero[0].y, punch_translation_zero[0].z),
		'speed': 1000
	})
	hits_sequence.append({
		'glove': 1,
		'rotation': Vector3(punch_rotation_zero[1].x, punch_rotation_zero[1].y, punch_rotation_zero[1].z),
		'target': Vector3(punch_translation_zero[1].x, punch_translation_zero[1].y, punch_translation_zero[1].z),
		'speed': 1000
	})