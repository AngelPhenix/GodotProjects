extends "res://scripts/Enemy/enemy.gd"

const scn_laser = preload("res://scenes/laser_enemy.tscn")

# Set random movement, starts shooting.
func _ready():
	randomize()
	var possible_movement = [velocity.x, -velocity.x]
	velocity.x = possible_movement[randi() % possible_movement.size()]
	shoot()

# If enemy_clever touches sides of screen : bounces.
func _process(_delta):
	if get_position().x <= 0 + $sprite.texture.get_width()/2:
		velocity.x = abs(velocity.x)
	if get_position().x >= get_viewport_rect().size.x - $sprite.texture.get_width()/2:
		velocity.x = -abs(velocity.x)

# Resets timer, adds a laser as children of world group at cannon position.
func shoot():
	$shoot_time.start()
	Audio_player.play("laser_enemy")
	var laser = scn_laser.instantiate()
	laser.set_position($cannon.get_global_position())
	get_tree().get_nodes_in_group('world')[0].call_deferred("add_child", laser)

# Shoots when timer timesout.
func _on_timer_timeout():
	shoot()
