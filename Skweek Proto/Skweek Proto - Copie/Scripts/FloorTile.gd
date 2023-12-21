extends Area2D

onready var sprite: Sprite = ($Sprite as Sprite)
signal converted


func _on_Floor_body_entered(body):
	if body.is_in_group("player"):
		if sprite.frame == 0:
			sprite.frame = 1
			emit_signal("converted")
