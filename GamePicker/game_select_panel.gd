extends VBoxContainer

var speed = 1500
var start_position = Vector2(75,-400)
var end_position = Vector2(75, 400)
var final_position: Vector2
var stopping = false;
var moving = true;
var tic_tac_toe = Vector2(75,145)
var guess_a_number = Vector2(75,40)
var flip_a_coin = Vector2(75,-60)
var rock_paper_scissors = Vector2(75,-165)

func set_speed(new_speed):
	speed = new_speed
	
func stop_at(stop_here):
	stopping = true
	final_position = stop_here;
	
func _process(delta):
	if moving:
		var step = speed * delta
		position.y += step
		
	if stopping:
		if position.y <= final_position.y + 5 and position.y >= final_position.y - 5:
			moving = false
			
	
	if position.y >= end_position.y:
		position = start_position
