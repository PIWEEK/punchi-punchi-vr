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


var targets = []
var hands = []

var loading_time = 5
var song_started = false
var wait = 8
var RITHM = 500
var TIME_VIEW = 350
var BEAT_CORRECTION = 100
var boxing_punch
var dummy

var current_seq
var last_seq

var billboard_score
var billboard_hint
var billboard_time
var current_hit = -1

var sound_player
var effect_player
var applause_sound
var bell_sound
var three_sound
var two_sound
var one_sound
var punch_sounds = []
var hit_sounds = []
var MAX_TIME = 55
var time = 55
var points = 0
var num_hits = 0
var last_correct_hit = -1
var last_wait_second = -1


var MODE_PLAY = 0
var MODE_WAIT = 1
var mode = MODE_PLAY
var waiting_time = 0
var root
var song
var punch_rotation_target = Vector3(0, 0, 0)

func _ready():	
	root = get_node("/root/global")
	root.initVR()
	
	get_node("Player/LeftController/GloveL").show()
	get_node("Player/RightController/GloveR").show()
	
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

	boxing_punch = get_node("BoxingPunch")
	dummy = get_node("Dummy")
	billboard_time = get_node("ViewportScore/Node2D/LabelTime")
	billboard_hint = get_node("ViewportHits/Node2D/Hint")
	billboard_score = get_node("ViewportScore/Node2D/LabelScore")
	sound_player = get_node("SoundPlayer")
	effect_player = get_node("EffectPlayer")
	# Preload sounds
	hit_sounds.append(load("res://assets/music/jab.ogg"))
	hit_sounds.append(load("res://assets/music/cross.ogg"))
	hit_sounds.append(load("res://assets/music/hook.ogg"))
	hit_sounds.append(load("res://assets/music/hook.ogg"))
	hit_sounds.append(load("res://assets/music/upper.ogg"))
	hit_sounds.append(load("res://assets/music/upper.ogg"))
	hit_sounds.append(null)
	applause_sound = load("res://assets/music/applause.ogg")
	bell_sound = load("res://assets/music/bell.ogg")
	three_sound = load("res://assets/music/three.ogg")
	two_sound = load("res://assets/music/two.ogg")
	one_sound = load("res://assets/music/one.ogg")
	punch_sounds.append(load("res://assets/music/punch1.ogg"))
	punch_sounds.append(load("res://assets/music/punch2.ogg"))
	punch_sounds.append(load("res://assets/music/punch3.ogg"))
	punch_sounds.append(load("res://assets/music/punch4.ogg"))
	punch_sounds.append(load("res://assets/music/punch5.ogg"))
	song = load("res://assets/music/"+global.current_song)
	
	get_node("AudioStreamPlayer").stream = song
	get_node("AudioStreamPlayer").stream.set_loop(false)
	
	
	left_controller_area = get_node("Player/LeftController/TouchArea")
	right_controller_area = get_node("Player/RightController/TouchArea")
	
	hands.append(get_node("Player/LeftController"))
	hands.append(get_node("Player/RightController"))
	
	targets.append(get_node("BoxingPunch/JabTarget"))
	targets.append(get_node("BoxingPunch/CrossTarget"))
	targets.append(get_node("BoxingPunch/LeftHookTarget"))
	targets.append(get_node("BoxingPunch/RightHookTarget"))
	targets.append(get_node("BoxingPunch/LeftUpperTarget"))
	targets.append(get_node("BoxingPunch/RightUpperTarget"))
	targets.append(get_node("BoxingPunch/PauseTarget"))
	
	configure_target(get_node("BoxingPunch/JabTarget"), LEFT, left_hand_base_color, left_hand_touch_color, global.JAB)
	configure_target(get_node("BoxingPunch/CrossTarget"), RIGHT, right_hand_base_color, right_hand_touch_color, global.CROSS)
	configure_target(get_node("BoxingPunch/LeftHookTarget"), LEFT, left_hand_base_color, left_hand_touch_color, global.LEFT_HOOK)
	configure_target(get_node("BoxingPunch/RightHookTarget"), RIGHT, right_hand_base_color, right_hand_touch_color, global.RIGHT_HOOK)
	configure_target(get_node("BoxingPunch/LeftUpperTarget"), LEFT, left_hand_base_color, left_hand_touch_color, global.LEFT_UPPER)	
	configure_target(get_node("BoxingPunch/RightUpperTarget"), RIGHT, right_hand_base_color, right_hand_touch_color, global.RIGHT_UPPER)	
	loading_time = 2
	reset()
	
	
func display_hint():	
	var text = "[center]\n"
	if len(global.current_coreo) == 8:
		text += "\n"
	var num = 0
	var color
	for s in global.current_coreo:
		if num == current_seq:
			text += "[i][color=#FFFFFF]" + global.HIT_NAMES[s] + "[/color][/i]"
		else:
			text += "[color=#00FF00]" + global.HIT_NAMES[s] + "[/color]"
		text += "[color=#00FF00], [/color]"
		num += 1
		if num % 4 == 0:
			text += "\n"
	if len(global.current_coreo) == 8:
		text += "\n"
	text += "[/center]"
				
	billboard_hint.bbcode_text = text
	
	
func reset():
	randomize()
	_play_sound(bell_sound)
	time = MAX_TIME	
	display_hint()
	billboard_hint.show()
	billboard_score.hide()
	billboard_time.set_text("")
	
	last_wait_second = -1	
	song_started = false	
	current_hit = -1
	last_seq = -1
	wait = 8
	
	for t in targets:	
		t.set_inactive()
				
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
			get_tree().change_scene("res://MenuScene.tscn")		
	rotate_punch(delta)
	
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
			_play_effect(punch_sounds[randi() % len(punch_sounds)])
			last_correct_hit = num_hits
			if current_hit == global.JAB or current_hit == global.CROSS:
				punch_rotation_target.x = -0.05
			elif current_hit == global.LEFT_UPPER:
				punch_rotation_target.y = -0.1
				punch_rotation_target.x = 0.03
			elif current_hit == global.LEFT_HOOK:
				punch_rotation_target.y = -0.1
			elif current_hit == global.RIGHT_UPPER:
				punch_rotation_target.y = 0.1
				punch_rotation_target.x = 0.03
			elif current_hit == global.RIGHT_HOOK:
				punch_rotation_target.y = 0.1
	elif last_body[hand]:
		last_body[hand].untouch()
		hands[hand].rumble = 0
		last_body[hand] = null
		
func _process_rithm(delta):
	wait -= delta
	if wait > 0:
		var wait_second = ceil(wait)
		if wait_second != last_wait_second:
			last_wait_second = wait_second
			billboard_time.set_text(str(wait_second))
			if wait_second == 3:
				_play_sound(three_sound)
			elif wait_second == 2:
				_play_sound(two_sound)
			if wait_second == 1:
				_play_sound(one_sound)
	else:
		_process_time()
		if time > 0:
			var music_ms = int(get_node("AudioStreamPlayer").get_playback_position() * 1000) + BEAT_CORRECTION
			var remainder = music_ms % RITHM
			current_seq = int(floor(music_ms / RITHM)) % len(global.current_coreo)			
			if remainder < TIME_VIEW:
				if current_seq != last_seq:					
					last_seq = current_seq
					display_hint()
					current_hit = global.current_coreo[current_seq]
					talk_hit(current_hit)
					dummy.dummy_hit(current_hit)
					if current_hit != global.PAUSE:
						num_hits += 1
					
					targets[current_hit].set_active()
					targets[current_hit].show()
					if current_hit == global.CROSS:
						targets[global.JAB].hide()
					if current_hit == global.JAB:
						targets[global.CROSS].hide()
			else:
				for t in targets:	
					t.set_inactive()
				targets[global.JAB].show()
				targets[global.CROSS].show()
				current_hit = -1
		else:
			targets[global.current_coreo[current_seq]].set_inactive()
			billboard_hint.bbcode_text = "\n\n\n[center][b][color=#FF0000]GOOD WORK[/color][/b][/center]"
			waiting_time = 10			
			mode = MODE_WAIT		
			for t in targets:	
				t.untouch()
			hands[0].rumble = 0
			hands[1].rumble = 0
			sound_player.connect("finished", self, "play_applause", [sound_player])			
			
func play_applause(who):
	sound_player.disconnect("finished", self, "play_applause")
	_play_sound(applause_sound)

func _process_time():
	billboard_time.hide()
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
	
func _play_effect(sound):
	effect_player.stream = sound
	effect_player.stream.set_loop(false)
	effect_player.play()
	
func rotate_punch(delta):
	if boxing_punch:		
		var speed = 1
		var amount = delta * speed
		rotate_punch_direction(Vector3(1, 0, 0), amount, 'x')
		rotate_punch_direction(Vector3(0, 1, 0), amount, 'y')
		rotate_punch_direction(Vector3(0, 0, 1), amount, 'z')
					
func rotate_punch_direction(axis, amount, direction):
	if punch_rotation_target[direction] > boxing_punch.rotation[direction]:						
		boxing_punch.rotate(axis, amount)
		if boxing_punch.rotation[direction] >= punch_rotation_target[direction]:			
			if punch_rotation_target[direction] == 0:
				boxing_punch.rotation[direction] = 0
			else:
				punch_rotation_target[direction] = 0
	elif punch_rotation_target[direction] < boxing_punch.rotation[direction]:
		boxing_punch.rotate(axis, -amount)
		if boxing_punch.rotation[direction] <= punch_rotation_target[direction]:			
			if punch_rotation_target[direction] == 0:
				boxing_punch.rotation[direction] = 0
			else:
				punch_rotation_target[direction] = 0
				