extends Node

var config: ConfigFile
const CONFIG_PATH = "user://mini_games.cfg"
const CONFIG_SECTION = "mini_games"
const CONFIG_PLAYER_NAMES = "player_names"
const CONFIG_NEXT_TIME = "next_time"
const CONFIG_CURRENT_PLAYER = "current_player"
const NAME_SPLIT_CHAR = "*"

const GAME_PICKER_SCENE_PATH = "res://GamePicker/game_picker.tscn"
const WELCOME_SCENE_PATH = "res://Welcome/welcome.tscn"

const BUTTON_SCENE_PATH = "res://UI/Scenes/my_button.tscn"
const CONFIRM_BOX_SCENE_PATH = "res://MyConfirmBox/my_confirm_box.tscn"
const WHOSE_TURN_SCENE_PATH = "res://WhoseTurn/whose_turn.tscn"

const OVERLAY_SCENE_PATH = "res://OverlayPanel/overlay_panel.tscn"
const WIN_SCENE_PATH = "res://WinScene/win_scene.tscn"

const FLIP_A_COIN_PATH = "res://FlipACoin/flip_a_coin.tscn"
const PICK_A_NUMBER_PATH = "res://PickANumber/pick_a_number.tscn"
const ROCK_PAPER_SCISSORS_PATH = "res://RockPaperScissors/rock_paper_scissors.tscn"
const TIC_TAC_TOE_PATH = "res://TicTacToe/tic_tac_toe.tscn"

func name_string_to_array():
	var name_string = config.get_value(CONFIG_SECTION, CONFIG_PLAYER_NAMES)
	if name_string != null:
		var split_array = name_string.split(NAME_SPLIT_CHAR, false)
		if split_array != null:
			return split_array
	return []
		
func is_name_in_list(nameToCheck):
	var split_array = name_string_to_array()
	for array_name in split_array:
		if array_name == nameToCheck:
			return true
	return false
	
func get_player_1():
	var player1 = config.get_value(CONFIG_SECTION,CONFIG_CURRENT_PLAYER)
	if player1 == null or player1 == "":
		var names_array = name_string_to_array()
		if names_array.size() == 0:
			return ""
		config.set_value(CONFIG_SECTION, CONFIG_CURRENT_PLAYER, names_array[0])
		player1 = names_array[0]
	return player1
	
func get_player_2():
	var player1 = get_player_1()
	var player2 = ""
	var names_array = name_string_to_array()
	for i in names_array.size():
		if names_array[i] == player1:
			var next = i + 1
			if next > names_array.size():
				next = 0;
			player2 = names_array[next]
	return player2
			
func next_turn():
	config.set_value(CONFIG_SECTION, CONFIG_CURRENT_PLAYER, get_player_2())
	
func get_next_time():
	return config.get_value(CONFIG_SECTION, CONFIG_NEXT_TIME)
	
func set_next_time(next_time):
	config.set_value(CONFIG_SECTION, CONFIG_NEXT_TIME, next_time)

func write_config():
	config.save(CONFIG_PATH)
	
func read_config():
	config = ConfigFile.new()
	var err = config.load(CONFIG_PATH)
	
	if err != OK:
		config = ConfigFile.new()
		config.set_value(CONFIG_SECTION, CONFIG_PLAYER_NAMES, "")
		config.set_value(CONFIG_SECTION, CONFIG_NEXT_TIME, false)
		config.set_value(CONFIG_SECTION, CONFIG_CURRENT_PLAYER, "")

func add_name_to_config(name_to_add):
	var names_string = config.get_value(CONFIG_SECTION, CONFIG_PLAYER_NAMES)
	if names_string == null:
		names_string = ""
	names_string += name_to_add + NAME_SPLIT_CHAR
	config.set_value(CONFIG_SECTION, CONFIG_PLAYER_NAMES, names_string)
	
func remove_name_from_config(name_to_remove):
	var split_array = name_string_to_array()
	var names_string = ""
	for array_name in split_array:
		if array_name != name_to_remove:
			names_string += array_name + NAME_SPLIT_CHAR
	config.set_value(CONFIG_SECTION, CONFIG_PLAYER_NAMES, names_string)
