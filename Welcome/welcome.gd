extends Control

const BUTTON_SCENE_PATH = "res://UI/Scenes/my_button.tscn"
const CONFIRM_BOX_SCENE_PATH = "res://MyConfirmBox/my_confirm_box.tscn"
const WHOSE_TURN_SCENE_PATH = "res://WhoseTurn/whose_turn.tscn"

func enable_begin_button():
	var split_array = ConfigManager.name_string_to_array()
	if split_array.size() > 1:
		$MainBackground/BeginButton.disabled = false
	else:
		$MainBackground/BeginButton.disabled = true

func add_name_button(name_to_add):
	var name_button_scene = load(BUTTON_SCENE_PATH)
	var name_button = name_button_scene.instantiate()
	#name_button.custom_minimum_size = $BeginButton.custom_minimum_size
	name_button.set_text(name_to_add)
	name_button.pressed.connect(confirm_remove_name.bind(name_to_add))
	$MainBackground/NameButtonsContainer.add_child(name_button)
	
func remove_name_button(name_to_remove):
	for name_button in $MainBackground/NameButtonsContainer.get_children():
		if name_button.get_text() == name_to_remove:
			name_button.queue_free()
			
func remove_name(name_to_remove):
	remove_name_button(name_to_remove)
	ConfigManager.remove_name_from_config(name_to_remove)
	ConfigManager.write_config()
	enable_begin_button()
			
func confirm_remove_name(name_to_remove):
	var confirm_box_scene = load(CONFIRM_BOX_SCENE_PATH)
	var confirm_box = confirm_box_scene.instantiate()
	confirm_box.set_confirm_box("Delete " + name_to_remove + "?","Are you sure you want to delete " + name_to_remove + "?","Yes", "No")
	confirm_box.button1.connect(remove_name.bind(name_to_remove))
	add_child(confirm_box)
	
func spawn_buttons():
	var split_array = ConfigManager.name_string_to_array()
	for b_name in split_array:
		add_name_button(b_name)

func _on_add_name_button_pressed():
	var input_name = $MainBackground/NameInputBackground/NameInput.get_text()
	if input_name.length() > 3 and !ConfigManager.is_name_in_list(input_name):
		ConfigManager.add_name_to_config(input_name)
		add_name_button(input_name)
		$MainBackground/NameInputBackground/NameInput.set_text("")
		ConfigManager.write_config()
		enable_begin_button()

func _on_begin_button_pressed():
	ConfigManager.set_next_time($MainBackground/NextTimeCheckBox.button_pressed)
	ConfigManager.write_config()
	get_tree().change_scene_to_file(WHOSE_TURN_SCENE_PATH)
	
func _ready():
	ConfigManager.read_config()
	if ConfigManager.get_next_time():
		$MainBackground/NextTimeCheckBox.button_pressed = true;
		_on_begin_button_pressed()
	else:
		$MainBackground/NextTimeCheckBox.button_pressed = false;
	spawn_buttons()
	enable_begin_button()
