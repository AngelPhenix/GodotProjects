extends "res://scripts/basemenupanel.gd"

func _on_quit_button_pressed():
	get_tree().change_scene("res://scenes/GameMenu.tscn")

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_grid_game_over():
	slide_in()