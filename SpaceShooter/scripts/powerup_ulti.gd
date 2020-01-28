extends "res://scripts/powerup.gd"

# If powerup_health collides with ship
func _on_area_enter(area):
	if area.is_in_group("ship"):
		Audio_player.play("powerup")
		area.is_ultimate = true
		queue_free()