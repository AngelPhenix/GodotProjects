extends Node2D

export(PackedScene) var projectile_scene
export var number_of_projectiles = 8
export var fire_interval = 0.2
var time_passed = 0.0
var tau = PI * 2

func _process(delta):
	time_passed += delta
	if time_passed >= fire_interval:
		shoot_radial()
		time_passed = 0.0

func shoot_radial():
	for i in range(number_of_projectiles):
		var angle = tau * i / number_of_projectiles
		var direction = Vector2(cos(angle), sin(angle))
		var projectile = projectile_scene.instance()
		projectile.global_position = global_position
		projectile.direction = direction
		get_parent().add_child(projectile)
