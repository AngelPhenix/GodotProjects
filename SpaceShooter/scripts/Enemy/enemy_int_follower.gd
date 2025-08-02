extends Area2D

var health = 2: set = set_health

const scn_explosion = preload("res://scenes/Explosion.tscn")
const scn_powerup_heal = preload("res://scenes/Powerup_health.tscn")
const scn_powerup_shoot = preload("res://scenes/Powerup_rate.tscn")
const scn_powerup_ulti = preload("res://scenes/Powerup_ulti.tscn")
const scn_label = preload("res://scenes/Ontop_score.tscn")

signal got_killed

func _physics_process(delta):
	get_parent().set_offset(get_parent().get_offset() + 150*delta)

# Method used every time the enemy receives damage
func set_health(new_health):
	if is_queued_for_deletion():
		var size_score_added = get_tree().get_nodes_in_group('scorepop').size()
		get_tree().get_nodes_in_group('scorepop')[size_score_added-1].queue_free()
		var additional_score = 50 * Engine.time_scale
		Audio_player.play("bullseye")
		get_tree().get_nodes_in_group('score')[0].score -= 5 * Engine.time_scale
		get_tree().get_nodes_in_group('score')[0].score += additional_score
		score_label(additional_score)
		return
	if health > new_health:
		Audio_player.play("hit_enemy")
		var damage_taken = health - new_health
	health = new_health
	if health <= 0: 
		var additional_score = 5 * Engine.time_scale
		get_tree().get_nodes_in_group('score')[0].score += additional_score
		score_label(additional_score)
		create_explosion()
		create_powerup()
		emit_signal("got_killed")

func score_label(score):
	var score_display = scn_label.instantiate()
	score_display.text = str("+", score)
	score_display.set_position(get_global_position())
	get_tree().get_nodes_in_group('world')[0].add_child(score_display)

# Creates an explosion at self position
func create_explosion():
	var explosion = scn_explosion.instantiate()
	explosion.set_position(get_global_position())
	#explosion.global_position = global_position
	get_tree().get_nodes_in_group('world')[0].add_child(explosion)

# 5% shootrate chance / 10% heal chance / 3% ult chance
func create_powerup():
	var rdm_seed = floor(randf_range(0,100))
	if(rdm_seed >= 0 && rdm_seed <= 4):
		var shoot_boost = scn_powerup_shoot.instantiate()
		shoot_boost.set_position(get_global_position())
		get_tree().get_nodes_in_group('world')[0].add_child(shoot_boost)
	if(rdm_seed >= 5 && rdm_seed <= 14):
		var heal_boost = scn_powerup_heal.instantiate()
		heal_boost.set_position(get_global_position())
		get_tree().get_nodes_in_group('world')[0].add_child(heal_boost)
	if(rdm_seed >= 15 && rdm_seed <= 17):
		var ult_boost = scn_powerup_ulti.instantiate()
		ult_boost.set_position(get_global_position())
		get_tree().get_nodes_in_group('world')[0].add_child(ult_boost)

# If hits player : damage player then destroy self
func _on_Enemy_area_entered(area):
	if area.is_in_group("ship"):
		Audio_player.play("hit_ship")
		Audio_player.play("explosion")
		area.health -= 1
		create_explosion()
		emit_signal("got_killed")