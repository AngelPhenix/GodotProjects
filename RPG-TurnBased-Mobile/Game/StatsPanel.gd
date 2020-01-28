extends Panel

onready var hpLabel = $StatsContainer/HP
onready var apLabel = $StatsContainer/AP
onready var mpLabel = $StatsContainer/MP

func _on_PlayerStats_hp_changed(value: int) -> void:
	hpLabel.text = "HP\n" + str(value)

func _on_PlayerStats_ap_changed(value: int) -> void:
	apLabel.text = "AP\n" + str(value)

func _on_PlayerStats_mp_changed(value: int) -> void:
	mpLabel.text = "MP\n" + str(value)
