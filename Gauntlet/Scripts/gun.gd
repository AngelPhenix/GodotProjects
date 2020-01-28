extends Area2D

var weapon_informations: Dictionary = {}
var can_pickup: bool = false
onready var hud_weapon: Node = get_tree().get_nodes_in_group("wp_container")[0]
onready var player: Node = get_tree().get_nodes_in_group("player")[0]

signal weapon_pickedup

func _ready() -> void:
	connect("weapon_pickedup", hud_weapon, "_on_Gun_weapon_pickedup")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action") && can_pickup:
		# If the player has 5 weapons already : delete the one selected
		if player.weapons.size() > 4:
			var selected_weapon: String = player.weapons.keys()[hud_weapon.index]
			player.weapons.erase(selected_weapon)
			hud_weapon.weapons.remove(hud_weapon.index)
			var node_to_delete: Node = hud_weapon.get_node("Weapons/Container").get_child(hud_weapon.index)
			hud_weapon.delete_node(node_to_delete)
		var weapon_key = weapon_informations.keys()
		var weapon_name = weapon_key[0]
		player.weapons[weapon_name] = weapon_informations.get(weapon_name)
		emit_signal("weapon_pickedup", $sprite.texture)
		queue_free()

func _on_Gun_body_entered(body):
	if body.is_in_group("player"):
		can_pickup = true

func _on_Gun_body_exited(body):
	if body.is_in_group("player"):
		can_pickup = false