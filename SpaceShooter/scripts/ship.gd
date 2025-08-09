extends Area2D

# Health = 4 (Like the sprites of the health bar is)
var health = 4: set = set_health
var max_health = health * 2
var is_double_shooting = false: set = double_shooting
var is_ultimate = false: set = ultimate
var is_shooting = true
var motion = Vector2()

@onready var scn_laser = preload("res://scenes/Laser_ship.tscn")
@onready var scn_explosion = preload("res://scenes/Explosion.tscn")
@onready var scn_flash = preload("res://scenes/Flash.tscn")
@onready var scn_ultimate = preload("res://scenes/Ultimate_laser.tscn")
@onready var scn_fire_reactor = preload("res://scenes/Fire_reactor.tscn")
@onready var ship_ultimate_sprite = preload("res://sprites/SelfMadeArt/player_ship01_ulti.png")
@onready var ship_sprite = preload("res://sprites/SelfMadeArt/player_ship01.png")
@onready var ship_slowmotion = preload("res://sprites/SelfMadeArt/player_ship01_slow.png")

# Connected to spr_health.gd (built-in). Emmited when health is changed
signal health_changed
# Connected to Ultimate_laser.tscn. Emmited when $ult_time is done
signal ult_finished

# Shoots at start of game
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	shoot()

func input():
	if Input.is_action_pressed("mouse_down"):
		Engine.time_scale = 2
		if get_tree().get_nodes_in_group('reactor').size() <= 0:
			add_fire_reactor(Vector2(0,17))
		else:
			return
	elif Input.is_action_pressed("ui_down"):
		Engine.time_scale = 0.5
		$sprite.texture = ship_slowmotion
		remove_fire_reactor()
	else:
		Engine.time_scale = 1
		$sprite.texture = ship_sprite
		remove_fire_reactor()

# Ship follows mouse X position and clamps to left and right of screen
func _physics_process(_delta):
	# motion variable to have some kind of transition between the first and second position (no position jumping)
	motion.x = (get_global_mouse_position().x - get_position().x) * 0.3
	motion.y = (get_global_mouse_position().y - get_position().y) * 0.3
	translate(Vector2(motion.x, motion.y))
	# Clamping the player to the side of the screen using screen size and player size/2
	var window_width = get_viewport_rect().size.x
	var player_width = $sprite.texture.get_width()
	var pos = get_position()
	pos.x = clamp(pos.x, 0+(player_width/2), window_width-(player_width/2))
	set_position(pos)
	input()

# Called on boss when area entered (ship enters boss area)
func kill():
	create_explosion()
	queue_free()

# Create lasers at their origins every shoot_time wait_time
func shoot():
	$shoot_time.start()
	if is_shooting:
		Audio_player.play("laser_ship")
		create_laser(global_position + Vector2(0,-15))
		if is_double_shooting:
			var laser_left = create_laser(global_position + Vector2(0, -15))
			var laser_right = create_laser(global_position + Vector2(0, -15))
			laser_left.velocity.x = -20
			laser_right.velocity.x = 20

# Conditions when health is changed
func set_health(new_value):
	# Got hit
	if new_value < health:
		Audio_player.play("hit_ship")
		get_tree().get_nodes_in_group("world")[0].add_child(scn_flash.instantiate())
	# Going from 4 to 5 HP (Shield up)
	if health == 4 and new_value == 5:
		$shield/anim.play("fade_in")
	# Going from 5 to 4 HP (Shield down)
	if health == 5 and new_value == 4:
		$shield/anim.play_backwards("fade_in")
	# if already got health max
	if new_value > max_health:
		get_tree().get_nodes_in_group('score')[0].score += 50
		return
	# if just got health max
	if new_value == max_health:
		$shoot_time.wait_time /= 2
	# if had health max and got hit
	if health == max_health and new_value != max_health:
		$shoot_time.wait_time *= 2
	health = new_value
	# Used in script in node "spr_health" in the Stage_Game scene
	emit_signal("health_changed",health)
	if health <= 0:
		create_explosion()
		queue_free()
		Engine.time_scale = 1
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# Double shoots for 5 seconds before passing it back to false
func double_shooting(new_value):
	is_double_shooting = new_value
	if is_double_shooting:
		$ds_time.start()

# Spawns lasers at the given position using the main node in the Laser_ship scene
func create_laser(pos):
	var laser = scn_laser.instantiate()
	laser.set_position(pos)
	get_tree().get_nodes_in_group('world')[0].call_deferred('add_child', laser)
	# return laser to be used in shoot() if double_shooting
	return laser

func add_fire_reactor(pos):
	var fire_reactor = scn_fire_reactor.instantiate()
	fire_reactor.set_position(pos)
	add_child(fire_reactor)

func remove_fire_reactor():
	if get_tree().get_nodes_in_group('reactor').size() > 0:
		get_tree().get_nodes_in_group('reactor')[0].queue_free()

# Adds explosion scene to the root node of the game
func create_explosion():
	var explosion = scn_explosion.instantiate()
	explosion.set_position(get_position())
	get_tree().get_nodes_in_group('world')[0].add_child(explosion)

func ultimate(new_value):
	is_ultimate = new_value
	if is_ultimate:
		$ult_time.start()
		if get_tree().get_nodes_in_group("ulti").size() == 0:
			fire_ultimate()
			is_shooting = false

func fire_ultimate():
	$sprite.texture = ship_ultimate_sprite
	var ultimate = scn_ultimate.instantiate()
	ultimate.set_position(Vector2(0,-15))
	call_deferred("add_child", ultimate)

# if shoot_time timer timeout : shoot
func _on_shoot_time_timeout():
	shoot()

# if ds_time timeout : stops double shooting
func _on_ds_time_timeout():
	is_double_shooting = false

func _on_ult_time_timeout():
	is_ultimate = false
	$sprite.texture = ship_sprite
	emit_signal("ult_finished")
	is_shooting = true

func level_finished():
	$collisionbox.queue_free()
	$shoot_time.queue_free()
	set_physics_process(false)
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", -200, 4).set_trans(Tween.TRANS_EXPO)

func _on_tween_tween_completed(_object, _key):
	await get_tree().create_timer(5).timeout
	get_tree().change_scene_to_file("res://stages/Stage_Game.tscn")
