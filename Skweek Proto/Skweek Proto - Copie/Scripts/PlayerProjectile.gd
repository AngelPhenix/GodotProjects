extends Area2D

var speed = 800
var direction: Vector2


func _physics_process(delta: float) -> void:
	translate(speed * direction * delta)


func _on_PlayerProjectile_body_entered(body):
	if body.is_in_group("des_wall"):
		queue_free()
		body.create_tile_on_destroy()
	if body.is_in_group("wall"):
		queue_free()
