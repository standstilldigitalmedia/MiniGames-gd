extends Node

class_name GlobalManager

static func init_random_rng():
	var rng = RandomNumberGenerator.new()
	rng.seed = hash(Time.get_datetime_string_from_system())
	return rng
	
static func create_overlay(title):
	var overlay_resource = load(ConfigManager.OVERLAY_SCENE_PATH)
	var overlay_scene = overlay_resource.instantiate()
	overlay_scene.set_title_text(title)
	return overlay_scene
	
static func create_confirm_box(title, question, button_1_text, button_2_text):
	var confirm_box_scene = load(ConfigManager.CONFIRM_BOX_SCENE_PATH)
	var confirm_box = confirm_box_scene.instantiate()
	confirm_box.set_confirm_box(title, question, button_1_text, button_2_text)
	return confirm_box
