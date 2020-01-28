extends Sprite

func init(pos):
	position = pos

func _on_anim_animation_finished(anim_name):
	queue_free()
