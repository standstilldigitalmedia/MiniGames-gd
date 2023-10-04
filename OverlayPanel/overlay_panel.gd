extends Control

func set_title_text(title):
	$TitleLabel.set_text(title)
	
func increase_player_1_score():
	var score = int($Player1Container/PlayerScore.get_text())
	score += 1
	$Player1Container/PlayerScore.set_text(score)
	if score == 2:
		print("Player1 Wins")
		
func increase_player_2_score():
	var score = int($Player2Container/PlayerScore.get_text())
	score += 1
	$Player2Container/PlayerScore.set_text(score)
	if score == 2:
		print("Player2 Wins")	

func _ready():
	var player1 = ConfigManager.get_player_1()
	$Player1Container/PlayerName.set_text(player1)
	$Player2Container/PlayerName.set_text(ConfigManager.get_player_2())
	$CurrentPlayerContainer/CurrentPlayerNameLabel.set_text(player1)
