extends Area2D

const scn_flare = preload("res://scenes/Flare.tscn")
var speed = 100
var faced_direction = Vector2()

func _ready():
	if get_tree().get_nodes_in_group("ship").size() > 0:
		var ship_position = get_tree().get_nodes_in_group("ship")[0].global_position
		faced_direction = (ship_position - global_position).normalized()
	else:
		var ship_position = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y)
		faced_direction = (ship_position - global_position).normalized()
	create_flare()
	$anim.play("flashing_ball")

func _physics_process(delta):
	position += faced_direction * speed * delta

func create_flare():
	var flare = scn_flare.instantiate()
	flare.set_position(get_position())
	get_tree().get_nodes_in_group("world")[0].add_child(flare)

func _on_vis_notifier_screen_exited():
	queue_free()

func _on_Laser_area_entered(area):
	if area.is_in_group("ship"):
		area.health -= 1
		create_flare()
		queue_free()