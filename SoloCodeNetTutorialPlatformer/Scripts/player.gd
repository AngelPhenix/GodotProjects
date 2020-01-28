extends KinematicBody2D

var scn_bullet = preload("res://Scenes/Bullet.tscn")
var scn_dash = preload("res://Scenes/Dash.tscn")
var scn_bomb = preload("res://Scenes/Bomb.tscn")
onready var scn_hud = get_parent().get_node("HUD")

var velocity = Vector2()
var mouse_position = Vector2()
var speed = 350
var jump_force = -550
var jump_count = 0
var dir_projectile = 1
var health = 100
var can_shoot = true
const GRAVITY = 1000
var direction_x
var direction_y
var max_speed = 350
var min_speed = 0.5

var lighting = false
var is_ladder = false

# State Machine #
var state
enum {IDLE, WALK, JUMP_UP, JUMP_DOWN, HURT, DASH, DEAD, LADDER}
var dashing = false

signal damaged

func _ready():
	scn_hud.connect("dead", self, "_on_HUD_dead")
	change_state(IDLE)
	

func _physics_process(delta):
	movement_loop()
	state_loop()
	if state == LADDER:
		velocity.y = lerp(velocity.y, 0, 0.50)
	else:
		velocity.y += GRAVITY * delta
	velocity = move_and_slide_with_snap(velocity, Vector2(0,2), Vector2(0,-1))
	$arm.look_at(get_global_mouse_position())
	$arm/Light2D.enabled = lighting

func movement_loop():
	mouse_position = get_global_mouse_position()
	var bullet_dir = mouse_position - $arm/muzzle.global_position
	var rot = bullet_dir.angle()
	if is_on_floor():
		jump_count = 0
	var right = Input.is_action_pressed("right")
	var left = Input.is_action_pressed("left")
	var jump = Input.is_action_just_pressed("jump")
	var shoot = Input.is_action_pressed("shoot")
	var dash = Input.is_action_just_pressed("dash")
	var light = Input.is_action_just_pressed("light")
	var down = Input.is_action_pressed("down")
	var up = Input.is_action_pressed("up")
	var bomb = Input.is_action_just_pressed("bomb")
	
	if state == DASH:
		direction_x = direction_x
	else:
		direction_x = int(right) - int(left)
	
	direction_y = int(down) - int(up)
	
	if dash && is_on_floor(): 
		dashing = true
	
	if light:
		lighting = !lighting
	
	if direction_x == 1:
		if state == DASH:
			velocity.x = max_speed * 2
		else:
			velocity.x = speed
		$sprite.flip_h = false
		$arm.flip_v = false
		dir_projectile = 1
		$arm.position.x = -5

	elif direction_x == -1:
		if state == DASH:
			velocity.x = -max_speed * 2
		else:
			velocity.x = -speed
		$sprite.flip_h = true
		$arm.flip_v = true
		dir_projectile = -1
		$arm.position.x = 5
	else:
		velocity.x = lerp(velocity.x, 0, 0.30)
		if velocity.x > -min_speed && velocity.x < min_speed:
			velocity.x = 0
	
	if down && jump:
		set_collision_mask_bit(7, false)
	elif jump && jump_count < 2:
		if jump_count == 0:
			$sounds/jump.pitch_scale = 0.8
		else:
			$sounds/jump.pitch_scale = 1.1
		$sounds/jump.play()
		velocity.y = jump_force
		jump_count += 1
	
	if shoot && can_shoot:
		can_shoot = false
		$sounds/laser.play()
		$shoot_timer.start()
		$arm/arm_anim.play("recule")
		var bullet = scn_bullet.instance()
		bullet.start($arm/muzzle.global_position, rot)
		get_parent().add_child(bullet)

	if bomb && can_shoot:
		can_shoot = false
		$sounds/laser.play()
		$shoot_timer.start()
		$arm/arm_anim.play("recule")
		var bombe = scn_bomb.instance()
		bombe.start($arm/muzzle.global_position, rot)
		get_parent().add_child(bombe)
		bombe.connect("explode", self, "_on_bomb_explode")
	
	if state == LADDER:
		velocity.y = direction_y * (max_speed * 1.5)
	
	if velocity.y != 0:
		$camera.zoom.x = lerp($camera.zoom.x, 1.05, 0.05)
		$camera.zoom.y = lerp($camera.zoom.y, 1.05, 0.05)
	else:
		$camera.zoom.x = lerp($camera.zoom.x, 1, 0.05)
		$camera.zoom.y = lerp($camera.zoom.y, 1, 0.05)

func hit_by_enemy(damage):
	emit_signal("damaged", damage)
	change_state(HURT)

func state_loop():
	if state == IDLE && velocity.x != 0:
		change_state(WALK)
	if state in [WALK, HURT, DASH] && velocity.x == 0:
		change_state(IDLE)
	if state in [IDLE, WALK] && !is_on_floor():
		change_state(JUMP_UP)
	if state == JUMP_UP && velocity.y > 0:
		change_state(JUMP_DOWN)
	if state in [JUMP_UP, JUMP_DOWN] && is_on_floor():
		change_state(IDLE)
	if state == WALK && dashing:
		change_state(DASH)
	if state == DASH && !dashing:
		change_state(IDLE)
	if direction_y != 0 && is_ladder:
		change_state(LADDER)
	if state == LADDER && !is_ladder:
		change_state(IDLE)

func change_state(new_state):
	state = new_state
	match state:
		IDLE:
			animation_play("idle")
		WALK:
			animation_play("walk")
		JUMP_UP:
			animation_play("jump_up")
		JUMP_DOWN:
			animation_play("jump_down")
		DASH:
			for x in range(0,5):
				var dash_ghost = scn_dash.instance()
				dash_ghost.init(position, $sprite)
				get_parent().add_child(dash_ghost)
				yield(get_tree().create_timer(0.05), "timeout")
			dashing = false
		LADDER:
			return
		HURT:
			animation_play("hurt")
		DEAD:
			$hitbox.set_deferred("monitoring", false)
			set_physics_process(false)

func animation_play(animation):
	if $anim.current_animation != animation:
		$anim.play(animation)

func _on_shoot_time_timeout():
	can_shoot = true

func _on_hitbox_body_entered(body):
	if body.is_in_group("enemy"):
		var collision_position = global_position - body.global_position
		velocity.x = sign(collision_position.x) * (speed * 2)
		velocity.y = -300
		velocity = move_and_slide(velocity, Vector2(0,-1))
		
		health -= 10
		emit_signal("damaged", body.strength)
		change_state(HURT)

func _on_pass_verif_body_exited(body):
	set_collision_mask_bit(7, true)

func _on_ladder_verif_area_shape_entered(area_id, area, area_shape, self_shape):
	if area.is_in_group("ladder"):
		is_ladder = true

func _on_ladder_verif_area_shape_exited(area_id, area, area_shape, self_shape):
	if area.is_in_group("ladder"):
		is_ladder = false

func _on_HUD_dead():
	change_state(DEAD)

func _on_bomb_explode():
	$camera/ScreenShake.start(10, 5, 0.2)