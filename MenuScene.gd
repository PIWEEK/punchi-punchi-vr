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
	
	
	get_node("Player/LeftController/GloveL").show()
	get_node("Player/RightController/GloveR").show()
	
	boxing_punch = get_node("BoxingPunch")
	hit_box = get_node("HitBox")
	
	left_controller_area = get_node("Player/LeftController/TouchArea")
	right_controller_area = get_node("Player/RightController/TouchArea")
		
	hands.append(get_node("Player/LeftController"))
	hands.append(get_node("Player/RightController"))
	
	punch_ball_music = get_node("PunchBallMusic")
	punch_ball_coreo = get_node("PunchBallCoreo")
	punch_ball_coreo.get_node("music").hide()
	punch_ball_coreo.get_node("boxing glove").show()
	
	
	touching = false
	loading = false
	
	current_song_num = 0
	current_coreo_num = 0

	play_song()
	display_hint()
	is_ready = true

func _process(delta):
	if is_ready and not loading:
		var touching_left = _process_hand(left_controller_area, LEFT)
		var touching_right = _process_hand(right_controller_area, RIGHT)
		touching = touching_left or touching_right
	
	
func _process_hand(area, hand):
	var current_body = null
	var bodies = area.get_overlapping_bodies()
	if len(bodies) > 0:
		if not touching:
			for body in bodies:			
				if body.get_parent() == hit_box:
					loading = 1
					print("PunchiDodge!!!")
					get_tree().change_scene("res://PunchiDodge.tscn")		
					return true
				elif body.get_parent() == boxing_punch:
					loading = 1
					print("Boxing Punch!!!")
					get_tree().change_scene("res://BoxScene.tscn")
					return true
				elif body.get_parent() == punch_ball_music:
					change_song()
					return true
				elif body.get_parent() == punch_ball_coreo:
					change_coreo()
					return true
		return true
	else:
		return false
			
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
	var text = ""
	var num = 0
	for s in global.current_coreo:
		text += global.HIT_NAMES[s] + ", "
		num += 1
		if num == 4:
			text += "\n"
			num = 0
				
	billboard_hint.set_text(text)
