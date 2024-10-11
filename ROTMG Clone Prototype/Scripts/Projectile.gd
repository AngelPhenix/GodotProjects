extends Node2D

var direction: Vector2 = Vector2()
var speed: int = 200
var wave_amplitude = 0
var wave_frequency = 0
var amplitude_growth = 60

var time_alive = 0
var lifetime = 15.0
var initial_delay = 0.5


func _process(delta) -> void:
	time_alive += delta
	
#	var perpendicular_direction = Vector2(-direction.y, direction.x)
#
#	var wave_offset = perpendicular_direction * sin(time_alive * wave_frequency) * (wave_amplitude + amplitude_growth * time_alive)
#
#	var move = direction * speed * delta + wave_offset * delta
#
#	position += move

	# Faire croître l'amplitude avec le temps
	var current_amplitude = wave_amplitude + amplitude_growth * time_alive
	
	# Calcul du vecteur perpendiculaire à la direction du projectile
	var perp_dir = Vector2(-direction.y, direction.x)
	
	# Mouvement de vague basé sur le temps avec amplitude croissante
	# Le facteur de temps est multiplié par la fréquence pour contrôler le rythme de l'oscillation
	var wave_offset = perp_dir * sin(time_alive * wave_frequency) * current_amplitude
	
	# Déplacement principal avec un ajout du décalage perpendiculaire
	var move = direction * speed * delta + wave_offset * delta
	
	# Déplacer la balle
	position += move

	if time_alive >= lifetime:
		queue_free()
