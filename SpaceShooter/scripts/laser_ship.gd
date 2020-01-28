extends "res://scripts/laser.gd"

# If laser ship collides with enemy
func _on_area_enter(area):
	if area.is_in_group("enemy"):
		area.health -= 1
		create_flare()
		queue_free()
	if area.is_in_group("boss"):
		area.health -= 1
		create_flare()
		queue_free()