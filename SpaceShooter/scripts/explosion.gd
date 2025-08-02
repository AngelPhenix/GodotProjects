extends Sprite2D

# Plays fade_out animation until "animation_finished" signal received then delete
func _ready():
	Audio_player.play("explosion")
	$animation.play("fade_out")
	await $animation.animation_finished
	queue_free()