extends Control

var overlay_scene: Node
var blank_theme: Theme
var o_button_theme: Theme
var x_button_theme: Theme
var value_grid = []

func is_cat():
	for a in 3:
		for b in 3:
			if value_grid[a][b] == 0:
				return false
	return true

func disable_all(disable):
	for a in 3:
		for b in 2:
			get_node("Background/BackgroundContainerRect/GridContainer/Button" + str(a) + str(b)).set_disabled(disable)

func set_all_to_blank():
	for a in 3:
		for b in 3:
			get_node("Background/BackgroundContainerRect/GridContainer/Button" + str(a) + str(b)).set_theme(blank_theme)

func register_click(x,y):
	if value_grid[x][y] == 0:
		disable_all(true)
		var clicked_button = get_node("Background/BackgroundContainerRect/GridContainer/Button" + str(x) + str(y))
		clicked_button.release_focus()
		if overlay_scene.get_current_player() == 1:
			clicked_button.set_theme(x_button_theme)
			value_grid[x][y] = 1
		else:
			clicked_button.set_theme(o_button_theme)
			value_grid[x][y] = 2
		$NextTurnTimer.start()
			
func set_listeners():
	for a in 3:
		for b in 3:
			get_node("Background/BackgroundContainerRect/GridContainer/Button" + str(a) + str(b)).pressed.connect(register_click.bind(a,b)) 

func re_init_value_grid():
	for a in 3:
		for b in 3:
			value_grid[a][b] = 0
			
func init_value_grid():
	for a in 3:
		value_grid.append([])
		for b in 3:
			value_grid[a].append(0)
			
func show_round_winner(winner):
	var confirm_box : Node
	if winner == 1:
		overlay_scene.increase_player_1_score()
		confirm_box = GlobalManager.create_confirm_box("Winner!", overlay_scene.get_player_1() + " Wins!", "Ok", "Cancel")
	else:
		overlay_scene.increase_player_2_score()
		confirm_box = GlobalManager.create_confirm_box("Winner!", overlay_scene.get_player_2() + " Wins!", "Ok", "Cancel")
	add_child(confirm_box)
	re_init_value_grid()
	set_all_to_blank()
			
func check_for_win():
	var center = value_grid[1][1]
	if center != 0:
		if value_grid[0][0] == center and value_grid[2][2] == center: #diagonal top left to botom right
			show_round_winner(center)
		if value_grid[2][0] == center and value_grid[0][2] == center: #diagonal top right to bottom left
			show_round_winner(center)
		if value_grid[0][1] == center and value_grid[2][1] == center: #horizontal through center
			show_round_winner(center)
		if value_grid[1][0] == center and value_grid[1][2] == center: #vertical through center
			show_round_winner(center)
	var top_left = value_grid[0][0]
	if top_left != 0:
		if value_grid[1][0] == top_left and value_grid[2][0] == top_left: #horizontal along the top
			show_round_winner(top_left)
		if value_grid[0][1] == top_left and value_grid[0][2] == top_left: #vertically down left side
			show_round_winner(top_left)
	var bottom_right = value_grid[2][2]
	if bottom_right != 0:
		if value_grid[0][2] == bottom_right and value_grid[1][2] == bottom_right: #horizontal along the bottom
			show_round_winner(bottom_right)
		if value_grid [2][0] == bottom_right and value_grid[2][1] == bottom_right: #vertically down right side
			show_round_winner(bottom_right)
			
func _ready():
	overlay_scene = GlobalManager.create_overlay("Tic-Tac-Toe")
	add_child(overlay_scene)
	
	blank_theme = load("res://TicTacToe/Themes/blank_button_theme.tres")
	o_button_theme = load("res://TicTacToe/Themes/o_button_theme.tres")
	x_button_theme = load("res://TicTacToe/Themes/x_button_theme.tres")
	set_all_to_blank()
	init_value_grid()
	set_listeners()


func _on_next_turn_timer_timeout():
	check_for_win()
	overlay_scene.switch_current_player()
	disable_all(false)
	var winner = overlay_scene.check_for_winner()
	if winner != null:
		add_child(winner)
