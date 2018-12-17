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

var HIT_NAMES = ["JAB", "CROSS", "L HOOK", "R HOOK", "L UPPER", "R UPPER", "WAIT"]

var targets = []
var hands = []

var loading_time = 5
var song_started = false
var wait = 4
var RITHM = 500
var TIME_VIEW = 350
var BEAT_CORRECTION = 100
var HIT_CORRECTION = 16

var SEQUENCE = [JAB, CROSS, JAB, CROSS, JAB, CROSS, JAB, CROSS, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE, LEFT_UPPER, LEFT_HOOK, RIGHT_UPPER, RIGHT_HOOK, LEFT_UPPER, LEFT_HOOK, RIGHT_UPPER, RIGHT_HOOK]
var current_seq

var billboard
var current_hit = -1

func _ready():
	# Get the viewport and clear it
	var viewport = get_node("Viewport")
	#viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)

	# Let two frames pass to make sure the vieport's is captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")

	# Retrieve the texture and set it to the viewport quad
	get_node("Viewport_quad").material_override.albedo_texture = viewport.get_texture()


	billboard = get_node("Viewport/Node2D/Label")
	
	left_controller_area = get_parent().get_node("Player/LeftController/TouchArea")
	right_controller_area = get_parent().get_node("Player/RightController/TouchArea")
	
	hands.append(get_parent().get_node("Player/LeftController"))
	hands.append(get_parent().get_node("Player/RightController"))
	
	targets.append(get_node("JabTarget"))
	targets.append(get_node("CrossTarget"))
	targets.append(get_node("LeftHookTarget"))
	targets.append(get_node("RightHookTarget"))
	targets.append(get_node("LeftUpperTarget"))
	targets.append(get_node("RightUpperTarget"))
	targets.append(get_node("PauseTarget"))
	
	configure_target(get_node("JabTarget"), LEFT, left_hand_base_color, left_hand_touch_color, JAB)
	configure_target(get_node("CrossTarget"), RIGHT, right_hand_base_color, right_hand_touch_color, CROSS)
	configure_target(get_node("LeftHookTarget"), LEFT, left_hand_base_color, left_hand_touch_color, LEFT_HOOK)
	configure_target(get_node("RightHookTarget"), RIGHT, right_hand_base_color, right_hand_touch_color, RIGHT_HOOK)
	configure_target(get_node("LeftUpperTarget"), LEFT, left_hand_base_color, left_hand_touch_color, LEFT_UPPER)	
	configure_target(get_node("RightUpperTarget"), RIGHT, right_hand_base_color, right_hand_touch_color, RIGHT_UPPER)
	
	song_started = false
	loading_time = 5
	current_hit = -1
	
	
func configure_target(target, hand, base_color, touch_color, hit):
	target.set_hand(hand)
	target.set_base_color(base_color)
	target.set_touch_color(touch_color)
	target.set_hit(hit)

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
			if body is StaticBody and body.has_method("touch") and body.hand == hand and body.hit == current_hit:
				current_body = body
				break	
	if current_body:
		if current_body == last_body[hand]:
			return
			
		if last_body[hand]:
			last_body[hand].untouch()
			
		current_body.touch()				
		last_body[hand] = current_body
		hands[hand].rumble = 1
	elif last_body[hand]:
		last_body[hand].untouch()
		hands[hand].rumble = 0
		last_body[hand] = null
		
func _process_rithm(delta):
	wait -= delta
	if wait > 0:
		billboard.set_text(str(ceil(wait)))
	else:
		var music_ms = int(get_node("AudioStreamPlayer").get_playback_position() * 1000) + BEAT_CORRECTION
		var remainder = music_ms % RITHM
		current_seq = int(floor(music_ms / RITHM) + HIT_CORRECTION) % len(SEQUENCE)
		billboard.set_text(HIT_NAMES[SEQUENCE[current_seq]])
		if remainder < TIME_VIEW:
			current_hit = SEQUENCE[current_seq]
			targets[current_hit].set_active()
			if current_hit == CROSS:
				targets[JAB].hide()
		else:
			targets[SEQUENCE[current_seq]].set_inactive()
			targets[JAB].show()
			current_hit = -1
			
		
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
