extends Area2D

var value: int = 1

func _on_Coin_body_entered(body: Object) -> void:
	if body.is_in_group("player"):
		body.add_coins(value)
		queue_free()