extends Control

var overlay_scene: Node
var player_1_throw = ""
var player_2_throw = ""

func disable_buttons(disable):
	$Background/RockButton.set_disabled(disable)
	$Background/PaperButton.set_disabled(disable)
	$Background/ScissorsButton.set_disabled(disable)
	
func reset_throws():
	player_1_throw = ""
	player_2_throw = ""
	
func set_throw(throw):
	if player_1_throw == "":
		player_1_throw = throw
	else:
		player_2_throw = throw
	
func _ready():
	overlay_scene = GlobalManager.create_overlay("Rock, Paper, Scissors")
	add_child(overlay_scene)

func on_button_press(throw):
	disable_buttons(true)
	set_throw(throw)
	$NextTurnTimer.start()

func _on_rock_button_pressed():
	on_button_press("rock")
	$Background/RockButton.release_focus()

func _on_paper_button_pressed():
	on_button_press("paper")
	$Background/PaperButton.release_focus()

func _on_scissors_button_pressed():
	on_button_press("scissors")
	$Background/ScissorsButton.release_focus()
	
func create_tie_box():
	var confirm_box = GlobalManager.create_confirm_box("TIE!","It was a tie. Go again.","Ok", "Cancel")
	add_child(confirm_box)

func _on_next_turn_timer_timeout():
	if player_1_throw != "" and player_2_throw != "":
		if player_1_throw == "rock":
			if player_2_throw == "rock":
				create_tie_box()
			elif player_2_throw == "paper":
				overlay_scene.increase_player_2_score()
			elif player_2_throw == "scissors":
				overlay_scene.increase_player_1_score()
		elif player_1_throw == "paper":
			if player_2_throw == "rock":
				overlay_scene.increase_player_1_score()
			elif player_2_throw == "paper":
				create_tie_box()
			elif player_2_throw == "scissors":
				overlay_scene.increase_player_2_score()
		elif player_1_throw == "scissors":
			if player_2_throw == "rock":
				overlay_scene.increase_player_2_score()
			elif player_2_throw == "paper":
				overlay_scene.increase_player_1_score()
			elif player_2_throw == "scissors":
				create_tie_box()
		var winner = overlay_scene.check_for_winner()
		if winner != null:
			add_child(winner)
		reset_throws()
	disable_buttons(false)
	overlay_scene.switch_current_player()
