extends Area2D

signal teleportation

func _on_TeleportTile_body_entered(body):
	if body.is_in_group("player"):
		emit_signal("teleportation", position)

func _on_TeleportTile_body_exited(body):
	if body.is_in_group("player"):
		body.can_teleport = true
