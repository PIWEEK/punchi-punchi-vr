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
var wait = 8
var RITHM = 500
var TIME_VIEW = 350
var BEAT_CORRECTION = 100
var HIT_CORRECTION = 0
var current_training

var TRAININGS = [
	{
		"rounds": [
			[JAB, CROSS, JAB, CROSS, JAB, CROSS, JAB, CROSS],
			[LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE, LEFT_UPPER, PAUSE, RIGHT_UPPER, PAUSE],
			[JAB, CROSS, JAB, CROSS, JAB, CROSS, JAB, CROSS, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE, LEFT_UPPER, PAUSE, RIGHT_UPPER, PAUSE]
		],
		"song": "ironbacon.ogg"
	},
	{
		"rounds": [
			[JAB, JAB, CROSS, PAUSE, JAB, JAB, CROSS, PAUSE],
			[LEFT_UPPER, LEFT_HOOK, RIGHT_UPPER, RIGHT_HOOK],
			[JAB, JAB, CROSS, PAUSE, JAB, JAB, CROSS, PAUSE, LEFT_UPPER, LEFT_HOOK, RIGHT_UPPER, RIGHT_HOOK]
		],
		"song": "electrodoodle.ogg"
	},
	{
		"rounds": [
			[JAB, CROSS, LEFT_UPPER, PAUSE, CROSS, JAB, RIGHT_UPPER, PAUSE],
			[LEFT_HOOK, RIGHT_HOOK, LEFT_UPPER, RIGHT_UPPER, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE],
			[JAB, CROSS, LEFT_UPPER, PAUSE, CROSS, JAB, RIGHT_UPPER, PAUSE, LEFT_HOOK, RIGHT_HOOK, LEFT_UPPER, RIGHT_UPPER, LEFT_HOOK, PAUSE, RIGHT_HOOK, PAUSE]
		],
		"song": "beachfront.ogg"
	}	
]


var current_round_num = 0
var current_round

var current_seq
var last_seq

var billboard_score
var billboard_hint
var billboard_hits
var current_hit = -1

var sound_player
var applause_sound
var hit_sounds = []
var MAX_TIME = 55
var time = 55
var points = 0
var num_hits = 0
var last_correct_hit = -1


var MODE_PLAY = 0
var MODE_WAIT = 1
var mode = MODE_PLAY
var waiting_time = 0
var root
var song

func _ready():
	current_training = 1
	root = get_node("/root/global")
	# Get the viewport and clear it
	var viewport_hits = get_node("ViewportHits")
	var viewport_score = get_node("ViewportScore")

	# Let four frames pass to make sure the vieport's is captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	

	# Retrieve the texture and set it to the viewport quad
	get_node("ViewportHitsContainer").material_override.albedo_texture = viewport_hits.get_texture()
	get_node("ViewportScoreContainer").material_override.albedo_texture = viewport_score.get_texture()


	billboard_hits = get_node("ViewportHits/Node2D/Label")
	billboard_hint = get_node("ViewportScore/Node2D/Hint")
	billboard_score = get_node("ViewportScore/Node2D/Label")
	sound_player = get_node("SoundPlayer")
	# Preload sounds
	hit_sounds.append(load("res://assets/music/jab.ogg"))
	hit_sounds.append(load("res://assets/music/cross.ogg"))
	hit_sounds.append(load("res://assets/music/hook.ogg"))
	hit_sounds.append(load("res://assets/music/hook.ogg"))
	hit_sounds.append(load("res://assets/music/upper.ogg"))
	hit_sounds.append(load("res://assets/music/upper.ogg"))
	hit_sounds.append(null)
	applause_sound = load("res://assets/music/applause.ogg")
	song = load("res://assets/music/"+TRAININGS[current_training]["song"])
	
	get_node("AudioStreamPlayer").stream = song
	get_node("AudioStreamPlayer").stream.set_loop(false)
	
	
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
	loading_time = 2
	reset(0)
	
	
	
func reset(round_num):
	current_round_num = round_num
	current_round = TRAININGS[current_training]["rounds"][current_round_num]
	time = MAX_TIME
	var text = ""
	var num = 0
	for s in current_round:
		text += HIT_NAMES[s] + ", "
		num += 1
		if num == 4:
			text += "\n"
			num = 0
				
	billboard_hint.set_text(text)
	billboard_hint.show()
	billboard_score.hide()
	billboard_hits.set_text("ROUND  "+str(round_num + 1))
	
	song_started = false	
	current_hit = -1
	last_seq = -1
	wait = 8
	mode = MODE_PLAY
	
	
func configure_target(target, hand, base_color, touch_color, hit):
	target.set_hand(hand)
	target.set_base_color(base_color)
	target.set_touch_color(touch_color)
	target.set_hit(hit)

func _process(delta):	
	if mode == MODE_PLAY:
		if loading_time <= 0:
			if not song_started:
				get_node("AudioStreamPlayer").play()
				song_started = true
			_process_hand(left_controller_area, LEFT)
			_process_hand(right_controller_area, RIGHT)
			_process_rithm(delta)
		else:
			loading_time -= delta
	elif mode == MODE_WAIT:
		waiting_time -= delta
		if waiting_time <= 0 :
			if current_round_num < 2:
				reset(current_round_num + 1)
			else:
				root.goto_scene("res://Calibration.tscn")
	
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
		if last_correct_hit != num_hits:
			points += 1			
			last_correct_hit = num_hits
	elif last_body[hand]:
		last_body[hand].untouch()
		hands[hand].rumble = 0
		last_body[hand] = null
		
func _process_rithm(delta):
	wait -= delta
	if wait > 0:
		billboard_hits.set_text(str(ceil(wait)))
	else:
		_process_time()
		if time > 0:
			var music_ms = int(get_node("AudioStreamPlayer").get_playback_position() * 1000) + BEAT_CORRECTION
			var remainder = music_ms % RITHM
			current_seq = int(floor(music_ms / RITHM) + HIT_CORRECTION) % len(current_round)
			billboard_hits.set_text(HIT_NAMES[current_round[current_seq]])
			if remainder < TIME_VIEW:
				if current_seq != last_seq:
					num_hits += 1
					last_seq = current_seq
					current_hit = current_round[current_seq]
					talk_hit(current_hit)
					
					
					targets[current_hit].set_active()
					if current_hit == CROSS:
						targets[JAB].hide()
			else:
				targets[current_round[current_seq]].set_inactive()
				targets[JAB].show()
				current_hit = -1
		else:
			targets[current_round[current_seq]].set_inactive()
			billboard_hits.set_text("GOOD\nWORK!")
			waiting_time = 10			
			mode = MODE_WAIT			
			sound_player.connect("finished", self, "play_applause", [sound_player])			
			
func play_applause(who):
	sound_player.disconnect("finished", self, "play_applause")
	_play_sound(applause_sound)

func _process_time():
	billboard_hint.hide()
	billboard_score.show()
	time = int(ceil(MAX_TIME - get_node("AudioStreamPlayer").get_playback_position()))
	if time < 0:
		time = 0
	if num_hits > 0:
		var points_percent = round((float(points) / num_hits) * 100)
		billboard_score.set_text(str(time)+"s\n"+str(points_percent)+"%")
	
	
			
func talk_hit(hit):
	if hit_sounds[hit]:
		_play_sound(hit_sounds[hit])
		
		
func _play_sound(sound):
	sound_player.stream = sound
	sound_player.stream.set_loop(false)
	sound_player.play()