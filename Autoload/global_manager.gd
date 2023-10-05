extends Node

class_name GlobalManager

static func get_win_scene(overlay_scene):
	var winner = overlay_scene.check_for_winner()
	if  winner != "":
		var win_scene_resource = load(ConfigManager.WIN_SCENE_PATH)
		var win_scene = win_scene_resource.instantiate()
		win_scene.set_win_label(winner)
		return win_scene
	return null

static func init_random_rng():
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_datetime_string_from_system())
	return rng
	
static func create_overlay(title):
	var overlay_resource = load(ConfigManager.OVERLAY_SCENE_PATH)
	var overlay_scene = overlay_resource.instantiate()
	overlay_scene.set_title_text(title)
	return overlay_scene
