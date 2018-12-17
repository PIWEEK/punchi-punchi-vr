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

var JAB = 0
var CROSS = 1
var LEFT_HOOK = 2
var RIGHT_HOOK = 3
var LEFT_UPPER = 4
var RIGHT_UPPER = 5
var PAUSE = 6

var targets = []

var loading_time = 5
var song_started = false
var wait = 3
var RITHM = 500
var TIME_VIEW = 350
var BEAT_CORRECTION = 100

var SEQUENCE = [JAB, CROSS, LEFT_UPPER, PAUSE, CROSS, JAB, RIGHT_UPPER, PAUSE]
var current_seq
func _ready():
	left_controller_area = get_parent().get_node("Player/LeftController/TouchArea")
	right_controller_area = get_parent().get_node("Player/RightController/TouchArea")
	
	targets.append(get_node("JabTarget"))
	targets.append(get_node("CrossTarget"))
	targets.append(get_node("LeftHookTarget"))
	targets.append(get_node("RightHookTarget"))
	targets.append(get_node("LeftUpperTarget"))
	targets.append(get_node("RightUpperTarget"))
	targets.append(get_node("PauseTarget"))
	
	configure_target(get_node("JabTarget"), LEFT, left_hand_base_color, left_hand_touch_color)
	configure_target(get_node("LeftHookTarget"), LEFT, left_hand_base_color, left_hand_touch_color)
	configure_target(get_node("LeftUpperTarget"), LEFT, left_hand_base_color, left_hand_touch_color)
	configure_target(get_node("CrossTarget"), RIGHT, right_hand_base_color, right_hand_touch_color)
	configure_target(get_node("RightHookTarget"), RIGHT, right_hand_base_color, right_hand_touch_color)
	configure_target(get_node("RightUpperTarget"), RIGHT, right_hand_base_color, right_hand_touch_color)
	
	song_started = false
	loading_time = 5
	
	
	
		
	
	
func configure_target(target, hand, base_color, touch_color):
	target.set_hand(hand)
	target.set_base_color(base_color)
	target.set_touch_color(touch_color)

func _process(delta):	
	if loading_time <= 0:
		if not song_started:
			get_node("AudioStreamPlayer").play()
			song_started = true
		_process_hand(left_controller_area, LEFT)
		_process_hand(right_controller_area, RIGHT)
		_process_rithm(delta)
	else:
		loading_time -= delta
	
func _process_hand(area, hand):
	var current_body = null
	var bodies = area.get_overlapping_bodies()
	if len(bodies) > 0:
		for body in bodies:
			if body is StaticBody and body.has_method("touch") and body.hand == hand:
				current_body = body
				break	
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
		
func _process_rithm(delta):
	wait -= delta
	if wait < 0:
		var music_ms = int(get_node("AudioStreamPlayer").get_playback_position() * 1000) + BEAT_CORRECTION
		var remainder = music_ms % RITHM
		current_seq = int(floor(music_ms / RITHM)) % len(SEQUENCE)
		if remainder < TIME_VIEW:
			targets[SEQUENCE[current_seq]].show()
		else:
			targets[SEQUENCE[current_seq]].hide()
			
		
#
#
#		timeout -= delta
#		if timeout <=0:
#			targets[SEQUENCE[current_seq]].hide()
#			current_seq += 1
#			current_seq = current_seq % len(SEQUENCE)
#			timeout = RITHM
#		elif timeout <= TIME_VIEW:
#			targets[SEQUENCE[current_seq]].show()
