extends "res://scripts/laser.gd"

# If laser enemy collides with ship
func _on_area_enter(area):
	if area.is_in_group("ship"):
		area.health -= 1
		create_flare()
		queue_free()