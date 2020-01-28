extends Sprite

func init(pos, sprite):
	position = pos
	texture = sprite.texture
	flip_h = sprite.flip_h
	hframes = sprite.hframes
	vframes = sprite.vframes
	frame = sprite.frame
	scale = sprite.get_parent().scale
	
	$anim.play("fade_out")
	yield($anim, "animation_finished")
	queue_free()