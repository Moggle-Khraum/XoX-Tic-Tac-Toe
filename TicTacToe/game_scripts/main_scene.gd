extends Node

# Exported variables for marker scenes
@export var circle_scene : PackedScene
@export var cross_scene : PackedScene

# Constants for player markers
const PLAYER_X = 1
const PLAYER_O = -1

# Variables to track game state
var current_player: int
var winner : int
var grid_data : Array
var board_size : int
var cell_size : float
var player_panel_pos: Vector2i
var temp_marker
var move_count: int

# Called when the node enters the scene tree for the first time.
func _ready():
	board_size = $Board.texture.get_width()
	cell_size = board_size / 3.0
	#Get Coordinates of the small panel on the right side.
	player_panel_pos = $PlayerPanel.position
	new_game()
	move_count = 0

# Handles mouse input for placing markers
func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if winner == 0:
			place_marker(event.position)

# Places a marker at the given screen position
func place_marker(position):
	var grid_pos = Vector2i(position / cell_size)
	 # Check if grid_pos is within the valid range
	if is_valid_grid_pos(grid_pos) and grid_data[grid_pos.y][grid_pos.x] == 0:
		move_count += 1
		print(move_count)
		grid_data[grid_pos.y][grid_pos.x] = current_player
		create_marker(current_player, grid_pos * cell_size + Vector2(cell_size / 2, cell_size / 2))
		if check_winner(current_player):
			end_game(current_player)
		elif move_count == 9:
			draw_game()
		else:
			switch_player()

# Checks if the given grid position is within the valid range
func is_valid_grid_pos(grid_pos):
	print("Invalid Boundary")
	return grid_pos.x >= 0 and grid_pos.x < 3 and grid_pos.y >= 0 and grid_pos.y < 3
	

# Resets the game state for a new game
func new_game():
	current_player = PLAYER_X
	winner = 0
	move_count = 0
	grid_data = [
		[0, 0, 0],
		[0, 0, 0],
		[0, 0, 0]
	]
	
	# Remove all children (assuming all markers are children of the Board node)
	get_tree().call_group("circles", "queue_free")
	get_tree().call_group("crosses", "queue_free")
	get_tree().paused = false
	
	#Create a marker to show starting player's turn
	var marker_preview = Vector2i(int(cell_size / 2.0), int(cell_size / 2.0))
	create_marker(current_player, player_panel_pos + marker_preview, true)

# Creates a marker on the board for the given player
func create_marker(player, position, temp=false):
	if player == PLAYER_X:
		clicksfx.play()
		var circle = circle_scene.instantiate()
		circle.position = position
		add_child(circle)
		if temp: temp_marker = circle
	else:
		clicksfx.play()
		var cross = cross_scene.instantiate()
		cross.position = position
		add_child(cross)
		if temp: temp_marker = cross


# Checks if there's a winner
func check_winner(player):
	for i in range(3):
		if (grid_data[i][0] + grid_data[i][1] + grid_data[i][2] == player * 3 or  # Rows
			grid_data[0][i] + grid_data[1][i] + grid_data[2][i] == player * 3 or  # Columns
			grid_data[0][0] + grid_data[1][1] + grid_data[2][2] == player * 3 or  # Diagonal top-left to bottom-right
			grid_data[0][2] + grid_data[1][1] + grid_data[2][0] == player * 3):   # Diagonal top-right to bottom-left
			return true
	return false

# Ends the game and displays the winner
func end_game(player):
	winner = player
	%game_over.show()
	if winner == PLAYER_X:
		print("Game Over! Player 0 wins!")
		%game_over.get_node("GameOver/Panel/PlayerWinsLabel").text = "Player O Wins!"
		get_tree().paused = true
	elif winner == PLAYER_O:
		print("Game Over! Player x wins!")
		%game_over.get_node("GameOver/Panel/PlayerWinsLabel").text = "Player X Wins!"
		get_tree().paused = true
	

# Switches the current player
func switch_player():
	current_player *= -1
	temp_marker.queue_free()
	create_marker(current_player, player_panel_pos + Vector2i(int(cell_size / 2.0), int(cell_size / 2.0)), true)
	
func draw_game():
	get_tree().paused = true
	print("Game Over! It's a DRAW!")
	%game_over.show()
	%game_over.get_node("GameOver/Panel/PlayerWinsLabel").text = "It's a DRAW!"
	
func _on_retry_pressed():
	clicksfx.play()
	#This will hide canvasLayer and free all the Markers 
	%game_over.hide()
	new_game()
	print("Game Over!")
	
func _on_home_pressed():
	clicksfx.play()
	get_tree().paused = false
	var _goback = get_tree().change_scene_to_file("res://main_home.tscn")
	print("Quiting Game", "Going Home")
	
	
