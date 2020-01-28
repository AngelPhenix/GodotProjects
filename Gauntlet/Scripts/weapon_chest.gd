extends StaticBody2D

var player_in_area: bool = false
var opened: bool = false
var opened_chest_texture: StreamTexture = preload("res://Sprites/weapon_chest_open.png")
onready var weapon_preload: Node = get_tree().get_nodes_in_group("wp_preload")[0]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && !opened && player_in_area:
		weapon_preload.create_weapon(position)
		opened = true
		($sprite as Sprite).texture = opened_chest_texture
		$opening.play()
		set_process(false)

func _on_pickup_area_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true

func _on_pickup_area_body_exited(body):
	if body.is_in_group("player"):
		player_in_area = false