extends KinematicBody2D

# variables
var speed: int = 120
var max_health: int = 20
var health: int = 20
var resistance: int = 1
var coins: int = 0
var treasures: int = 0
var velocity: Vector2 = Vector2()
var spawn_to_hunt: int = 0
var weapons: Dictionary = {}
var equipped_weapon: Dictionary = {}
var current_weapon_name: String
var nearby_chest: Node
var bullet_scn: PackedScene = preload("res://Scenes/bullet.tscn")
var hud_scn: PackedScene = preload("res://Scenes/Interface/Interface.tscn")
onready var walls_map: Node = get_parent().get_node("Walls")
onready var weapon_preload: Node = get_parent().get_node("WeaponPreload")

var shoot: bool = true
var is_playing: bool = false
var touching_enemy: bool = false

signal hurt(health)
signal coin_pickedup(value)

func _ready() -> void:
	weapon_preload.initialize_weapon_player()
	current_weapon_name = weapons.keys()[0]

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide(velocity.normalized() * speed)
	rotation += get_local_mouse_position().angle()
	var target_offset = (get_global_mouse_position() - global_position)/4
	$camera.offset = $camera.offset.linear_interpolate(target_offset, delta * 4.0)

func get_input() -> void:
	velocity = Vector2()
	velocity.x = -int(Input.is_action_pressed('ui_left')) + int(Input.is_action_pressed('ui_right'))
	velocity.y = -int(Input.is_action_pressed('ui_up')) + int(Input.is_action_pressed('ui_down'))
	if velocity != Vector2():
		if !is_playing:
			($anim as AnimationPlayer).play('walk')
			is_playing = true
	else:
		($anim as AnimationPlayer).stop()
		is_playing = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_down"):
		shooting()

func shooting() -> void:
	($audio/gunshot as AudioStreamPlayer2D).play()
	var bullet = bullet_scn.instance()
	get_tree().get_root().add_child(bullet)
	bullet.shoot(get_global_mouse_position(), global_position)
	bullet.get_node("sprite").texture = load(equipped_weapon[current_weapon_name].get("bullet_sprite"))
	bullet.get_node("light").color = Color(equipped_weapon[current_weapon_name].get("light_color"))
	bullet.strength = int(equipped_weapon[current_weapon_name].get("attack"))
	($shoot_rate as Timer).start()

func taking_damage(damage: int) -> void:
	if touching_enemy:
		health -= damage / resistance
		emit_signal("hurt", health)
		yield(get_tree().create_timer(0.33), "timeout")
		taking_damage(damage)

func change_weapon(index: int) -> void:
	equipped_weapon.erase(equipped_weapon.keys()[0])
	equipped_weapon[weapons.keys()[index]] = weapons.get(weapons.keys()[index])
	current_weapon_name = weapons.keys()[index]

func add_coins(value: int) -> void:
	coins += value
	emit_signal("coin_pickedup", coins)
	($audio/treasure as AudioStreamPlayer2D).play()

func add_treasure(value: int) -> void:
	treasures += value
	($audio/treasure as AudioStreamPlayer2D).play()

func _on_Timer_timeout() -> void:
	if(Input.is_action_pressed("mouse_down")):
		shooting()
		($shoot_rate as Timer).start()

var body_should_damage_us_map: Dictionary = {}
func _on_hitbox_body_entered(body: Object) -> void:
	# If the body hit is an enemy
	if body.is_in_group("enemy"):
		# if the enemy is already in the dictionary but not erase, its because the
		# yield isn't done yet and thus, to not get spammed by damages
		if body_should_damage_us_map.has(body):
			# we are already looping, just notify the loop to keep damaging
			body_should_damage_us_map[body] = true
		# if the enemy is not in the dictionary : add it to it
		else:
			# no loop yet, so start one now
			body_should_damage_us_map[body] = true
			# While the body is in the dictionary, take damage every 0.33 sec
			while body_should_damage_us_map[body]:
				($audio/hurt as AudioStreamPlayer2D).play()
				health -= body.strength / resistance
				emit_signal("hurt", health)
				yield(get_tree().create_timer(0.33), "timeout")
			# Not in loop anymore, meaning body is not near us / is dead : No more damage, kick it from dic
			body_should_damage_us_map.erase(body)

func _on_hitbox_body_exited(body: Object) -> void:
	if body.is_in_group("enemy"):
		body_should_damage_us_map[body] = false # tell our loop to stop damaging

func _on_EndLevel_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene("res://Stages/FinishedStages/Map02.tscn")
