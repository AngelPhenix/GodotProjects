extends Node

var projectile_count: int = 10

# Méthode pour tirer en cercle
func shoot_in_circle() -> void:
	#36° pour chaque tir
	# 3*36° => Tir n°3
	var angle_increment: float = 360 / projectile_count
	for i in range(projectile_count):
		var angle: float = deg2rad(i * angle_increment) # Tir0 : 0° / Tir1 : 36° / Tir2 : 72° / [...]
		var direction: Vector2 = Vector2(cos(angle), sin(angle))
		# TIIIIIIIIR
		# Spawn le tir + lui donner la direction


func shoot_in_wave() -> void:
	var base_angle: float = 0
	pass
