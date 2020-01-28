

func _ready() -> void:
	player.connect("hurt", self, "_on_player_hurt")
	var health = player.health
	$hp.max_value = health

func _on_player_hurt(health: int) -> void:
	$hp.value = health