extends Control

func _on_goback_button_pressed():
	var _goback = get_tree().change_scene_to_file("res://main_home.tscn")
	clicksfx.play()
	print("playing Click")
