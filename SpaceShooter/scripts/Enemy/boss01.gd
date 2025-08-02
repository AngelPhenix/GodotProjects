extends Area2D

var in_position = false
var phasetwo = false
var phasethree = false
var phasefour = false

var health = 100: set = health_changed
var velocity = Vector2()

const scn_laser = preload("res://scenes/Laser_enemy.tscn")
const scn_ball = preload("res://scenes/Laser_ball_boss.tscn")
const scn_explosion = preload("res://scenes/Explosion.tscn")
const scn_label = preload("res://scenes/Ontop_score.tscn")

signal level_done

func _ready():
	var player = get_tree().get_nodes_in_group("ship")[0]
	connect("level_done", Callable(player, "level_finished"))
	collision_mask = 0

func _physics_process(delta):
	translate(velocity * delta)
	if !in_position:
		if global_position.y < 20:
			velocity.y = 30
		else:
			velocity.y = 0
			in_position = true
			collision_layer = 1
			await get_tree().create_timer(0.5).timeout
			phase_one()

func health_changed(new_value):
	health = new_value
	if health < 75 && !phasetwo:
		phase_two()
		phasetwo = true
	elif health < 50  && !phasethree:
		phase_three()
		phasethree = true
	elif health < 25 && !phasefour:
		phase_four()
		phasefour = true
	elif health <= 0:
		emit_signal("level_done")
		var additional_score = 1000 * Engine.time_scale
		get_tree().get_nodes_in_group('score')[0].score += additional_score
		score_label(additional_score)
		create_explosion()
		queue_free()

func score_label(score):
	var score_display = scn_label.instantiate()
	score_display.text = str("+", score)
	score_display.set_position(get_position())
	get_tree().get_nodes_in_group('world')[0].add_child(score_display)

func phase_one():
	shoot_laser_01()
	shoot_laser_02()
	shoot_laserbeam_01()
	shoot_laserbeam_02()

func phase_two():
	$laser_shoot_01.wait_time = 0.1
	$laser_shoot_02.wait_time = 0.1
	$laser_beams_01.stop()
	$laser_beams_02.stop()
	shoot_laser_01()
	shoot_laser_02()
	$laser_middle.wait_time = 0.7
	shoot_middle()

func phase_three():
	$laser_shoot_01.stop()
	$laser_shoot_02.stop()
	$laser_middle.wait_time = 0.3
	shoot_middle()

func phase_four():
	$laser_shoot_01.wait_time = 0.5
	$laser_shoot_02.wait_time = 0.5
	$laser_beams_01.wait_time = 0.7
	$laser_beams_02.wait_time = 0.7
	$laser_middle.wait_time = 0.8
	shoot_laser_01()
	shoot_laser_02()
	shoot_laserbeam_01()
	shoot_laserbeam_02()
	shoot_middle()

# Left laser
func shoot_laser_01():
	$laser_shoot_01.start()
	Audio_player.play("laser_enemy")
	var laser01 = scn_laser.instantiate()
	laser01.set_position($cannnons/laser_shoot01.get_global_position())
	get_tree().get_nodes_in_group('world')[0].call_deferred("add_child", laser01)

#right laser
func shoot_laser_02():
	$laser_shoot_02.start()
	Audio_player.play("laser_enemy")
	var laser02 = scn_laser.instantiate()
	laser02.set_position($cannnons/laser_shoot02.get_global_position())
	get_tree().get_nodes_in_group('world')[0].call_deferred("add_child", laser02)

# middle-left beam
func shoot_laserbeam_01():
	$laser_beams_01.start()
	Audio_player.play("laser_enemy")
	var beam01 = scn_laser.instantiate()
	beam01.set_position($cannnons/laser_beam01.get_global_position())
	get_tree().get_nodes_in_group('world')[0].call_deferred("add_child", beam01)

# middle-right beam
func shoot_laserbeam_02():
	$laser_beams_02.start()
	Audio_player.play("laser_enemy")
	var beam02 = scn_laser.instantiate()
	beam02.set_position($cannnons/laser_beam02.get_global_position())
	get_tree().get_nodes_in_group('world')[0].call_deferred("add_child", beam02)

# middle cannon
func shoot_middle():
	$laser_middle.start()
	Audio_player.play("laser_enemy")
	var middle_laser = scn_ball.instantiate()
	middle_laser.set_position($cannnons/laser_middle.get_global_position())
	get_tree().get_nodes_in_group('world')[0].call_deferred("add_child", middle_laser)

func _on_laser_shoot_01_timeout():
	shoot_laser_01()

func _on_laser_shoot_02_timeout():
	shoot_laser_02()

func _on_laser_beams_01_timeout():
	shoot_laserbeam_01()

func _on_laser_beams_02_timeout():
	shoot_laserbeam_02()

func _on_laser_middle_timeout():
	shoot_middle()

func create_explosion():
	var explosion = scn_explosion.instantiate()
	explosion.set_position(get_position())
	get_tree().get_nodes_in_group('world')[0].add_child(explosion)

func _on_Boss01_area_entered(area):
	if area.is_in_group("ship"):
		Audio_player.play("hit_ship")
		area.kill()