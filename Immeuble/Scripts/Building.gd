extends StaticBody2D

func _on_VisibilityNotifier2D_screen_exited() -> void:
	get_tree().get_root().get_node("World").algo()
	queue_free()
