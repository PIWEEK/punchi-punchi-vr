extends Spatial

var root
var LEFT = 0
var RIGHT = 1
var left_controller_area
var right_controller_area
var hands = []
var boxing_punch
var hit_box
var punch_ball_music
var punch_ball_coreo
var loading
var easy
var middle
var hard
var current_song_num = 0
var current_coreo_num = 0
var touching = false
var billboard_hint
var is_ready = false
var dummy
var current_seq
var last_seq
var RITHM = 500
var left_controller
var right_controller
var boxing_menu_mode = false

func _ready():	
	is_ready = false
	root = get_node("/root/global")
	root.initVR()
	
	# Get the viewport and clear it
	var viewport_hints = get_node("ViewportHints")
	billboard_hint = get_node("ViewportHints/Node2D/Hint")

	# Let two frames pass to make sure the vieport's is captured
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	

	# Retrieve the texture and set it to the viewport quad
	get_node("ViewportHintsContainer").material_override.albedo_texture = viewport_hints.get_texture()
	
	left_controller = get_node("Player/LeftController")
	right_controller = get_node("Player/RightController")
	hands.append(left_controller)
	hands.append(right_controller)
	
	left_controller.get_node("GloveL").show()
	right_controller.get_node("GloveR").show()	
	
	boxing_punch = get_node("SelectGameMenu/BoxingPunch")
	hit_box = get_node("SelectGameMenu/HitBox")
	
	left_controller_area = get_node("Player/LeftController/TouchArea")
	right_controller_area = get_node("Player/RightController/TouchArea")
		
	hands.append(get_node("Player/LeftController"))
	hands.append(get_node("Player/RightController"))
	
	punch_ball_music = get_node("BoxingMenu/PunchBallMusic")
	punch_ball_coreo = get_node("BoxingMenu/PunchBallCoreo")
	punch_ball_coreo.get_node("music").hide()
	punch_ball_coreo.get_node("boxing glove").show()
	
	dummy = get_node("BoxingMenu/Dummy")
	billboard_hint.bbcode_text = "\n\n\n[center][b][color=#FF0000]ELIGE JUEGO[/color][/b][/center]"
	
	
	touching = false
	loading = false
	
	current_song_num = 0
	current_coreo_num = 0
	current_seq = 0
	last_seq = -1	
	boxing_menu_mode = false
	is_ready = true

func _process(delta):
	if is_ready and not loading:
		var touching_left = _process_hand(left_controller_area, LEFT)
		var touching_right = _process_hand(right_controller_area, RIGHT)
		touching = touching_left or touching_right
		if boxing_menu_mode:
			_process_rithm(delta)
	
	
func _process_hand(area, hand):
	var current_body = null
	var bodies = area.get_overlapping_bodies()
	if len(bodies) > 0:
		if not touching:
			hands[hand].rumble = 1
			for body in bodies:			
				if body.get_parent() == hit_box:
					loading = 1
					get_tree().change_scene("res://PunchiDodge.tscn")		
					return true
				elif body.get_parent() == boxing_punch:
					start_boxing_menu()
					return true
				elif body.get_parent() == punch_ball_music:
					change_song()
					return true
				elif body.get_parent() == punch_ball_coreo:
					change_coreo()
					return true
		return true
	else:
		hands[hand].rumble = 0
		return false

func start_boxing_menu():
	get_node("SelectGameMenu").hide()
	get_node("SelectGameMenu").translate(Vector3(0, -1000, 0))
	get_node("BoxingMenu").show()
	play_song()
	display_hint()
	left_controller.connect("button_pressed", self, "button_pressed")    
	right_controller.connect("button_pressed", self, "button_pressed")
	boxing_menu_mode = true
			
func change_song():
	current_song_num = (current_song_num + 1) % len(global.SONGS)
	global.current_song = global.SONGS[current_song_num]
	play_song()
			
			
func change_coreo():
	current_coreo_num = (current_coreo_num + 1) % len(global.COREOS)
	global.current_coreo = global.COREOS[current_coreo_num]
	display_hint()
	
func play_song():
	var song = load("res://assets/music/"+global.current_song)
	get_node("AudioStreamPlayer").stream = song
	get_node("AudioStreamPlayer").stream.set_loop(false)	
	get_node("AudioStreamPlayer").play()
	get_node("AudioStreamPlayer").seek(8)
	
func display_hint():	
	var text = "[center][i][color=#0000FF]COREO SELECCIONADA[/color][/i][/center]\n\n[center]"
	if len(global.current_coreo) == 8:
		text += "\n"
	var num = 0
	var color
	for s in global.current_coreo:
		color = "#00FF00"
		if num == current_seq:
			color = "#FFFFFF"
		text += "[color=" + color + "]" + global.HIT_NAMES[s] + "[/color]"
		text += "[color=#00FF00], [/color]"
		num += 1
		if num % 4 == 0:
			text += "[/center]\n[center]"
	if len(global.current_coreo) == 8:
		text += "\n"
	text += "[/center]\n[center][color=#0000FF]PULSA EL GATILLO PARA EMPEZAR[/color][/center]"
				
	billboard_hint.bbcode_text = text

func _process_rithm(delta):	
	var music_ms = int(get_node("AudioStreamPlayer").get_playback_position() * 1000)
	var remainder = music_ms % RITHM
	current_seq = int(floor(music_ms / RITHM)) % len(global.current_coreo)	
	if current_seq != last_seq:					
		last_seq = current_seq
		var current_hit = global.current_coreo[current_seq]
		dummy.dummy_hit(current_hit)
		display_hint()	
	
func button_pressed(a):
	print("Pressed!")
	loading = 1
	get_tree().change_scene("res://BoxScene.tscn")