extends Area2D

# Connects signal coming from ship when ultimate laser timer is done
func _ready():
	var ship = get_tree().get_nodes_in_group('ship')[0]
	ship.connect("ult_finished", self, "_on_Ship_ult_finished")
	$anim.play("spawn")

# When enemies hit : oneshots them
func _on_Ultimate_laser_area_entered(area):
	if area.is_in_group("enemy"):
		area.health -= 9999

# When timer ult laser done : destroy itself
func _on_Ship_ult_finished():
	queue_free()