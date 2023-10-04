extends Control

var speed = 1500
var panel_1_pos = Vector2(0,-200)
var panel_2_pos = Vector2(0,200)
var start_position = Vector2(0,-400)
var end_position = Vector2(0, 400)
var final_position: Vector2
var stopping = false;
var moving = true;
var game_path = ""

func get_game_path(rando):
	if rando < 25:
		game_path = ConfigManager.TIC_TAC_TOE_PATH
	elif rando < 50:
		game_path = ConfigManager.PICK_A_NUMBER_PATH
	elif rando < 75:
		game_path = ConfigManager.FLIP_A_COIN_PATH
	else:
		game_path = ConfigManager.ROCK_PAPER_SCISSORS_PATH

func get_end_y(rando):
	if rando < 25:
		return -165 #Tic-Tac-Toe
	elif rando < 50:
		return -60 #pick a number
	elif rando < 75:
		return 40 #flip a coin
	else:
		return 145 #rock, paper, scissors

func check_for_stop():
	if speed < 500:
		$Timer2.stop()
		var rng = RandomNumberGenerator.new()
		rng.seed = hash(Time.get_datetime_string_from_system())
		var rando = 53 #rng.randf_range(1.0, 100.0)
		stopping = true
		final_position = Vector2(0, get_end_y(rando))
		get_game_path(rando)
		
func decrease_speed():
	speed -= 100

func _on_timer_1_timeout():
	decrease_speed()
	$Timer2.start()

func _on_timer_2_timeout():
	decrease_speed()
	check_for_stop()
	
func _on_timer_3_timeout():
	print("changing scene now")
	get_tree().change_scene_to_file(game_path)
	
func _process(delta):
	if moving:
		var step = speed * delta
		panel_1_pos.y += step
		
	if stopping:
		if panel_1_pos.y <= final_position.y + 5 and panel_1_pos.y >= final_position.y - 5:
			moving = false
			stopping = false
			$Timer3.start()
			print("timer3 started")
		
	if panel_1_pos.y - panel_2_pos.y > 400:
		panel_2_pos.y = panel_1_pos.y - 400
		
	if panel_1_pos.y - panel_2_pos.y < 400:
		panel_2_pos.y = panel_1_pos.y + 400
		
	if panel_1_pos.y >= end_position.y:
		panel_1_pos = start_position
		
	if panel_2_pos.y >= end_position.y:
		panel_2_pos = start_position	
	
	$Background/Mask/GameSelectPanel1.position = panel_1_pos
	$Background/Mask/GameSelectPanel2.position = panel_2_pos 	
	
	
func _ready():
	$Timer1.start()

func _on_game_select_panel_1_stopped():
	$Background/Mask/GameSelectPanel2.moving = false

	
