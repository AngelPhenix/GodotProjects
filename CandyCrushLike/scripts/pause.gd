extends "res://scripts/basemenupanel.gd"

func _on_continue_pressed():
	get_tree().paused = false
	slide_out()

func _on_quit_pressed():
	get_tree().quit()

func _on_bot_ui_pause_menu():
	slide_in()
