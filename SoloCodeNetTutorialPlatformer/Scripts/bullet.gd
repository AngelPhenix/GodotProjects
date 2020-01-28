extends KinematicBody2D

export (int) var speed = 500
var velocity = Vector2()
var scn_impact = preload("res://Scenes/Impact.tscn")

func start(pos, direction):
	rotation = direction
	position = pos
	velocity = Vector2(speed, 0).rotated(rotation)

func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		var impact = scn_impact.instance()
		impact.start(collision.position)
		get_parent().add_child(impact)
		
		if collision.collider.has_method("hit"):
			collision.collider.hit(3)
		queue_free()
		
		if collision.collider.has_method("hit_by_enemy"):
			collision.collider.hit_by_enemy(1)
			