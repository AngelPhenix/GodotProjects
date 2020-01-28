extends "res://Game/Button.gd"

func _on_pressed() -> void:
	var playerStats = BattleUnits.PlayerStats
	if playerStats != null:
		if playerStats.mp >= 8:
			playerStats.hp += 5
			playerStats.mp -= 8
			playerStats.ap -= 1