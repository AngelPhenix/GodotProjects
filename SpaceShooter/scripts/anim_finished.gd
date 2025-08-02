extends Sprite2D

# Waits "animation_finished" signal before deleting self
func _ready():
	$animation.play("fade_out")
	await $animation.animation_finished
	queue_free()