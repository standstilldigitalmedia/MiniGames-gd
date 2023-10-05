extends Control

var overlay_scene: Node
var flipping = true
var stopping = false
var choice: String
var rng: RandomNumberGenerator

func player_wins(player_name):
	var win_scene_resource = load(ConfigManager.WIN_SCENE_PATH)
	var win_scene = win_scene_resource.instantiate()
	win_scene.set_win_label(player_name)
	add_child(win_scene)
	
func _on_flipping_timer_timeout():
	if flipping:
		if $Background/FlippingCoin/Tails.visible:
			$Background/FlippingCoin/Tails.hide()
			$Background/FlippingCoin/Heads.show()
		else:
			$Background/FlippingCoin/Tails.show()
			$Background/FlippingCoin/Heads.hide()
		if !stopping:	
			$FlippingTimer.wait_time = rng.randf_range(0.15, 0.6)
			
func _on_slow_down_timer_timeout():
	$FlippingTimer.wait_time += 0.1
	if $FlippingTimer.wait_time > 1:
		flipping = false
		$FlippingTimer.stop()
		$SlowDownTimer.stop()
		if $Background/FlippingCoin/Tails.visible:
			if choice == "tails":
				if overlay_scene.get_current_player() == 1:
					overlay_scene.increase_player_1_score()
				else:
					overlay_scene.increase_player_2_score()
		else:
			if choice == "heads":
				if overlay_scene.get_current_player() == 1:
					overlay_scene.increase_player_1_score()
				else:
					overlay_scene.increase_player_2_score()
		$NextTurnTimer.start()
		
func on_button_press():
	stopping = true
	$HeadsButton.set_disabled(true)
	$TailsButton.set_disabled(true)
	$SlowDownTimer.start()

func _on_heads_button_pressed():
	$HeadsButton.release_focus()
	choice = "heads"
	on_button_press()

func _on_tails_button_pressed():
	$TailsButton.release_focus()
	choice = "tails"
	on_button_press()

func _on_next_turn_timer_timeout():
	var winner = overlay_scene.check_for_winner()
	if  winner != "":
		player_wins(winner)
	overlay_scene.switch_current_player()
	$HeadsButton.set_disabled(false)
	$TailsButton.set_disabled(false)
	$FlippingTimer.wait_time = 0.3
	$FlippingTimer.start()
	flipping = true

func _ready():
	rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_datetime_string_from_system())
	var overlay_resource = load(ConfigManager.OVERLAY_SCENE_PATH)
	overlay_scene = overlay_resource.instantiate()
	overlay_scene.set_title_text("Flip A Coin")
	add_child(overlay_scene)
	$Background/FlippingCoin/Tails.hide()
