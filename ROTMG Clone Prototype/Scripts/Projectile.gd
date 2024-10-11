extends Node2D

var direction: Vector2 = Vector2()
var speed: int = 200

func _process(delta) -> void:
	# Déplacer le projectile
	position += direction * speed * delta
