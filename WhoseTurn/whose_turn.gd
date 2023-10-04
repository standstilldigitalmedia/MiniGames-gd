extends Control

@export var welcome_scene: PackedScene

func _ready():
	var player1 = ConfigManager.get_player_1()
	$BackgroundRect/TitleLabel.set_text(player1 + " gets to go first!")
	$BackgroundRect/TurnButton.set_text(player1)


func _on_turn_button_pressed():
	get_tree().change_scene_to_file(ConfigManager.GAME_PICKER_SCENE_PATH)


func _on_back_button_pressed():
	ConfigManager.set_next_time(false)
	ConfigManager.write_config()
	#get_tree().unload_current_scene()
	get_tree().change_scene_to_file(ConfigManager.WELCOME_SCENE_PATH)
