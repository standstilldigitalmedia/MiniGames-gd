extends Control

func set_win_label(winner):
	$Background/WinLabel.set_text(winner + " WINS!")
	
func _on_play_again_button_pressed():
	get_tree().change_scene_to_file(ConfigManager.WELCOME_SCENE_PATH)
