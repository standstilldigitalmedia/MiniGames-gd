extends Control

func set_title_text(title):
	$TitleLabel.set_text(title)
	
func switch_current_player():
	if $Player1Container/PlayerName.get_text() == $CurrentPlayerContainer/CurrentPlayerNameLabel.get_text():
		$CurrentPlayerContainer/CurrentPlayerNameLabel.set_text($Player2Container/PlayerName.get_text())
	else:
		$CurrentPlayerContainer/CurrentPlayerNameLabel.set_text($Player1Container/PlayerName.get_text())
	
func get_player_1():
	return $Player1Container/PlayerName.get_text()
	
func get_player_2():
	return $Player2Container/PlayerName.get_text()
	
func set_current_player(current_player):
	$CurrentPlayerContainer/CurrentPlayerNameLabel.set_text(current_player)
	
func get_current_player():
	if $Player1Container/PlayerName.get_text() == $CurrentPlayerContainer/CurrentPlayerNameLabel.get_text():
		return 1
	elif $Player2Container/PlayerName.get_text() == $CurrentPlayerContainer/CurrentPlayerNameLabel.get_text():
		return 2
	return 0
	
func check_for_winner():
	var winner = ""
	if int($Player1Container/PlayerScore.get_text()) > 1:
		winner = get_player_1()
	elif int($Player2Container/PlayerScore.get_text()) > 1:
		winner = get_player_2()
		
	if  winner != "":
		var win_scene_resource = load(ConfigManager.WIN_SCENE_PATH)
		var win_scene = win_scene_resource.instantiate()
		win_scene.set_win_label(winner)
		ConfigManager.next_turn()
		return win_scene
	return null
	
func increase_player_1_score():
	var score = int($Player1Container/PlayerScore.get_text())
	score += 1
	$Player1Container/PlayerScore.set_text(str(score))
		
func increase_player_2_score():
	var score = int($Player2Container/PlayerScore.get_text())
	score += 1
	$Player2Container/PlayerScore.set_text(str(score))

func _ready():
	var player1 = ConfigManager.get_player_1()
	$Player1Container/PlayerName.set_text(player1)
	$Player2Container/PlayerName.set_text(ConfigManager.get_player_2())
	$CurrentPlayerContainer/CurrentPlayerNameLabel.set_text(player1)
