extends Node

var bubble_missed: int = 0

func _process(delta: float) -> void:
	if bubble_missed >= 10:
		get_tree().change_scene("res://Scenes/World.tscn")
		bubble_missed = 0