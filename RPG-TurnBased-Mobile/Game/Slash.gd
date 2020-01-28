extends Node2D

func _on_anim_animation_finished(anim_name):
	queue_free()