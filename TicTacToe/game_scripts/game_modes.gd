extends Control



func _on_goback_button_pressed():
	clicksfx.play()
	var _go_back = get_tree().change_scene_to_file("res://main_home.tscn")
	print("Going Home", "Game Mode Closes")


func _on_x_3_button_pressed():
	clicksfx.play()
	var _game_modex3 = get_tree().change_scene_to_file("res://main_scenes/play_game.tscn")
	print("3x3 Grid", "Playing Game")

func _on_x_4_button_pressed():
	clicksfx.play()
	var _game_modex4 = get_tree().change_scene_to_file("res://main_scenes/play_game4x4.tscn")
	print("4x4 Grid", "Playing Game")
