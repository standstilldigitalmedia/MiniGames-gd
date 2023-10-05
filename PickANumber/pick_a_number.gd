extends Control

var overlay_scene: Node
var player_1_guess = 0
var player_2_guess = 0
var rng: RandomNumberGenerator

func player_wins(player_name):
	var win_scene_resource = load(ConfigManager.WIN_SCENE_PATH)
	var win_scene = win_scene_resource.instantiate()
	win_scene.set_win_label(player_name)
	add_child(win_scene)

func _ready():
	var overlay_resource = load(ConfigManager.OVERLAY_SCENE_PATH)
	overlay_scene = overlay_resource.instantiate()
	overlay_scene.set_title_text("Flip A Coin")
	add_child(overlay_scene)
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_datetime_string_from_system())

func _on_submit_button_pressed():
	$Background/ControlContainer/SubmitButton.disabled = true
	if player_1_guess == 0:
		player_1_guess = int($Background/ControlContainer/TextEditBackground/NumberTextEdit.get_text())
		$NextTurnTimer.start()
	else:
		player_2_guess = int($Background/ControlContainer/TextEditBackground/NumberTextEdit.get_text())
		$NextTurnTimer.start()
	$Background/ControlContainer/TextEditBackground/NumberTextEdit.set_text("")
		

func _on_next_turn_timer_timeout():
	if player_1_guess != 0 and player_2_guess != 0:
		var rando = rng.randf_range(1.0, 100.0)
		var player_1_score = 0
		var player_2_score = 0
		if player_1_guess > rando:
			player_1_score = player_1_guess - rando
		else:
			player_1_score = rando - player_1_guess
		
		if player_2_guess > rando:
			player_2_score = player_2_guess - rando
		else:
			player_2_score = rando - player_2_guess
		
		if player_1_score < player_2_score:
			overlay_scene.increase_player_1_score()
		elif player_2_score < player_1_score:
			overlay_scene.increase_player_2_score()
		else:
			var confirm_box_scene = load(ConfigManager.CONFIRM_BOX_SCENE_PATH)
			var confirm_box = confirm_box_scene.instantiate()
			confirm_box.set_confirm_box("TIE!","It was a tie. Go again.","Ok", "Cancel")
			add_child(confirm_box)
		player_1_guess = 0
		player_2_guess = 0
			
	var winner = overlay_scene.check_for_winner()
	if  winner != "":
		player_wins(winner)
	
	overlay_scene.switch_current_player()
	$Background/ControlContainer/SubmitButton.disabled = false
