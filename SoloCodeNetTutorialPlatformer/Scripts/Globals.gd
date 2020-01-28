extends Node

const pause_scn = preload("res://Scenes/MainMenu.tscn")

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		var pause = pause_scn.instance()
		add_child(pause)