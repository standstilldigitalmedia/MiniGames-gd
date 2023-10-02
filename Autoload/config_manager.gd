extends Node

var config: ConfigFile
const CONFIG_PATH = "user://mini_games.cfg"
const CONFIG_SECTION = "mini_games"
const CONFIG_PLAYER_NAMES = "player_names"
const CONFIG_NEXT_TIME = "next_time"
const CONFIG_WHOSE_TURN = "whose_turn"
const NAME_SPLIT_CHAR = "*"

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
	
func get_whose_turn():
	var whose_turn = config.get_value(CONFIG_SECTION,CONFIG_WHOSE_TURN)
	if whose_turn == null or whose_turn == "":
		var names_array = name_string_to_array()
		if names_array.size() == 0:
			return ""
		config.set_value(CONFIG_SECTION, CONFIG_WHOSE_TURN, names_array[0])
		return names_array[0]
	return whose_turn
	
func next_turn():
	var whose_turn = get_whose_turn()
	var new_whose_turn = ""
	var names_array = name_string_to_array()
	for i in names_array.size():
		if names_array[i] == whose_turn:
			var next = i + 1
			if next > names_array.size():
				next = 0;
			new_whose_turn = names_array[next]
	config.set_value(CONFIG_SECTION, CONFIG_WHOSE_TURN, new_whose_turn)
	
	
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
		config.set_value(CONFIG_SECTION, CONFIG_WHOSE_TURN, "")

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
