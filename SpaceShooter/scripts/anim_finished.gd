extends Sprite

# Waits "animation_finished" signal before deleting self
func _ready():
	$animation.play("fade_out")
	yield($animation, "animation_finished")
	queue_free()