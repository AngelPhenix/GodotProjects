extends TextureRect

signal pause_menu

func _on_pause_pressed():
	emit_signal("pause_menu")
	get_tree().paused = true