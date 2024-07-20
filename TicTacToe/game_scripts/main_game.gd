extends Control



func _on_music_button_pressed():
	var _musicbtn = %music_button
	var _musiclbl = %music_label
	
	if !music.playing:
		music.play()
		_musiclbl.text = "MUSIC: ON"
		print("Play Music")
	else:
		music.stream_paused = true
		_musiclbl.text = "MUSIC: OFF"
		print('Pause Music')

func _on_play_game_button_pressed():
	clicksfx.play()
	var _game_mode = get_tree().change_scene_to_file("res://main_scenes/game_modes.tscn")
	print("Playing the Game", "Game Mode Shows")

func _on_credits_button_pressed():
	clicksfx.play()
	var _credits = get_tree().change_scene_to_file("res://game_scenes/credits.tscn")
	print("Click Credits", "Credits Shows")
	



