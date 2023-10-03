extends Control

const GAME_PICKER_SCENE_PATH = "res://GamePicker/game_picker.tscn"
const WELCOME_SCENE_PATH = "res://Welcome/welcome.tscn"

@export var welcome_scene: PackedScene

func _ready():
	var whose_turn = ConfigManager.get_whose_turn()
	$BackgroundRect/TitleLabel.set_text(whose_turn + " gets to go first!")
	$BackgroundRect/TurnButton.set_text(whose_turn)


func _on_turn_button_pressed():
	get_tree().change_scene_to_file(GAME_PICKER_SCENE_PATH)


func _on_back_button_pressed():
	ConfigManager.set_next_time(false)
	ConfigManager.write_config()
	#get_tree().unload_current_scene()
	get_tree().change_scene_to_file(WELCOME_SCENE_PATH)
