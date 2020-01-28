extends Area2D

var faced_direction: Vector2 = Vector2()
var speed: int = 200
var strength: int = 1

func _process(delta: float) -> void:
	translate(faced_direction * speed * delta)

func shoot(target_position: Vector2, player_position: Vector2) -> void:
	position = player_position
	faced_direction = (target_position - player_position).normalized()
	rotation = faced_direction.angle()

func _on_Bullet_body_entered(body: Object) -> void:
	if body.is_in_group("wall"):
		queue_free()
	if body.is_in_group("enemy"):
		if body.has_method("hit"):
			body.hit(strength)
			queue_free()

func _on_Bullet_area_entered(area: Object) -> void:
	if area.is_in_group("enemy"):
		if area.has_method("hit"):
			area.hit(strength)
			queue_free()