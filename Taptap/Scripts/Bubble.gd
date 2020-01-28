extends Area2D
class_name Bubble

func _on_destroy_timeout() -> void:
	Globals.bubble_missed += 1
	queue_free()