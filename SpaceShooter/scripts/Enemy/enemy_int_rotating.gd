extends "res://scripts/Enemy/enemy.gd"

const scn_laser = preload("res://scenes/Laser_ball.tscn")

var in_position = false

func _physics_process(_delta):
	if global_position.y < 100:
		velocity.y = 150
	else:
		velocity.y = 0
		global_rotation += 0.2
		if !in_position:
			in_position = true
			collision_layer = 1
			shoot()

# Resets timer, adds a laser as children of world group at cannon position.
func shoot():
	$shoot_time.start()
	Audio_player.play("laser_enemy")
	var laser = scn_laser.instantiate()
	laser.set_position($cannon.get_global_position())
	laser.set_rotation(get_rotation())
	get_tree().get_nodes_in_group('world')[0].call_deferred("add_child", laser)

func _on_shoot_time_timeout():
	shoot()
