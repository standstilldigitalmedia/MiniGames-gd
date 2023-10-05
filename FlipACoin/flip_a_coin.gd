extends Control

var overlay_scene: Node
var flipping = true
var stopping = false
var choice: String
var rng: RandomNumberGenerator

func buttons_disabled(en):
	$HeadsButton.set_disabled(en)
	$TailsButton.set_disabled(en)
	
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
	buttons_disabled(true)
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
	var winner = GlobalManager.get_win_scene(overlay_scene)
	if winner != null:
		add_child(winner)
	overlay_scene.switch_current_player()
	buttons_disabled(false)
	$FlippingTimer.wait_time = 0.3
	$FlippingTimer.start()
	flipping = true

func _ready():
	rng = GlobalManager.init_random_rng()
	overlay_scene = GlobalManager.create_overlay("Flip A Coin")
	add_child(overlay_scene)
	$Background/FlippingCoin/Tails.hide()
