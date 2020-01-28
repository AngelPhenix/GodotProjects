extends Area2D

export var velocity = Vector2()
const scn_flare = preload("res://scenes/Flare.tscn")

func _ready():
	create_flare()
	var connection = connect("area_entered", self, "_on_area_enter")
	if connection == 0:
		return

func _process(delta):
	translate(velocity * delta)

func create_flare():
	var flare = scn_flare.instance()
	flare.set_position(get_position())
	get_tree().get_nodes_in_group("world")[0].add_child(flare)

func _on_vis_notifier_screen_exited():
	queue_free()