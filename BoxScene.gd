extends Spatial

var left_controller_area
var right_controller_area
var last_body = [null, null]
var left_hand_base_color = Color(0, 0, 255, 1)
var left_hand_touch_color = Color(0, 255, 0, 1)
var right_hand_base_color = Color(255, 0, 0, 1)
var right_hand_touch_color = Color(0, 255, 0, 1)
var LEFT = 0
var RIGHT = 1

func _ready():
	left_controller_area = get_parent().get_node("ARVROrigin/LeftController/TouchArea")
	right_controller_area = get_parent().get_node("ARVROrigin/RightController/TouchArea")
	configure_target(get_node("JabTarget"), LEFT, left_hand_base_color, left_hand_touch_color)
	configure_target(get_node("LeftHookTarget"), LEFT, left_hand_base_color, left_hand_touch_color)
	configure_target(get_node("LeftUpperTarget"), LEFT, left_hand_base_color, left_hand_touch_color)
	configure_target(get_node("CrossTarget"), RIGHT, right_hand_base_color, right_hand_touch_color)
	configure_target(get_node("RightHookTarget"), RIGHT, right_hand_base_color, right_hand_touch_color)
	configure_target(get_node("RightUpperTarget"), RIGHT, right_hand_base_color, right_hand_touch_color)
		
	
	
func configure_target(target, hand, base_color, touch_color):
	target.set_hand(hand)
	target.set_base_color(base_color)
	target.set_touch_color(touch_color)

func _process(delta):
	_process_hand(left_controller_area, LEFT)
	_process_hand(right_controller_area, RIGHT)
	
func _process_hand(area, hand):
	var current_body = null
	var bodies = area.get_overlapping_bodies()
	if len(bodies) > 0 and bodies[0] is StaticBody and bodies[0].has_method("touch") and bodies[0].hand == hand:
		current_body = bodies[0]			
	if current_body:
		if current_body == last_body[hand]:
			return
			
		if last_body[hand]:
			last_body[hand].untouch()
			
		current_body.touch()		
		last_body[hand] = current_body
	elif last_body[hand]:
		last_body[hand].untouch()
		last_body[hand] = null
		
	
