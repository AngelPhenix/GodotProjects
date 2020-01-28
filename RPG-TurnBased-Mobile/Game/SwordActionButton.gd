extends "res://Game/Button.gd"

const Slash = preload("res://Game/Slash.tscn")

func _on_pressed():
	var enemy = BattleUnits.Enemy
	var playerStats = BattleUnits.PlayerStats
	if enemy != null && playerStats != null:
		create_slash(enemy.global_position)
		enemy.take_damage(4)
		playerStats.mp += 2
		playerStats.ap -= 1

func create_slash(position: Vector2) -> void:
	var slash = Slash.instance()
	var main = get_tree().current_scene
	main.add_child(slash)
	slash.position = position