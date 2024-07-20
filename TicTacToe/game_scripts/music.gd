extends AudioStreamPlayer

func _on_finished():
	music.play()
	print("Music Looped")
