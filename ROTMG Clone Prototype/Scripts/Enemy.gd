extends Node2D

onready var projectile_scn: PackedScene = preload("res://Scenes/Projectile.tscn")

# FOR THE SHOOT IN WAVE, ALWAYS ADD ONE PROJECTILE UNLESS FULL CIRCLE
var projectile_count: int = 18
# Largeur de la wave ????
var wave_amplitude = 200
# Hauteur de la wave ????
var wave_frequency = 4* PI

# Méthode pour tirer en cercle
func shoot_in_circle() -> void:
	var angle_increment: float = 360 / projectile_count
	for i in range(projectile_count):
		var angle: float = deg2rad(i * angle_increment) # Tir0 : 0° / Tir1 : 36° / Tir2 : 72° / [...]
		var direction: Vector2 = Vector2(cos(angle), sin(angle)) # Turns angle into direction Vector
		spawn_projectile(global_position, direction, true)

# Méthode pour tirer en éventail
func shoot_in_wave() -> void:
	var starting_angle = 180
	var angle_increment = 10
	for i in range(projectile_count):
		var angle: float = deg2rad(starting_angle + i * angle_increment)
		var direction: Vector2 = Vector2(cos(angle), sin(angle))
		spawn_projectile(global_position, direction)

# Méthode pour créer et tirer un projectile dans une direction donnée
func spawn_projectile(enemy_pos: Vector2, direction: Vector2, wave: bool = false) -> void:
	var projectile = projectile_scn.instance()
	projectile.position = enemy_pos
	projectile.direction = direction
	if wave:
		projectile.wave_amplitude = wave_amplitude
		projectile.wave_frequency = wave_frequency
	get_parent().add_child(projectile)


func _on_Timer_timeout():
	shoot_in_circle()
#	shoot_in_wave()
