extends Control

onready var player: Node = get_tree().get_nodes_in_group("player")[0]
onready var weapon_container: Node = get_node("Weapons/Container")
onready var selected_weapon: Node = get_node("Weapons/Container/Gun1")
var rect_gun_scn = preload("res://Scenes/Interface/GunNode.tscn")
var index: int = 0
var weapons: Array = []

func _ready() -> void:
	visible = true
	$CoinCounter/number.text = str(player.coins)
	$Health_Bar/hp.max_value = player.max_health
	$Health_Bar/hp.value = player.health
	player.connect("coin_pickedup", self, "_on_coin_pickedup")
	player.connect("hurt", self, "_on_player_hurt")
	
	for node in weapon_container.get_children():
		if node.texture != null:
			weapons.append(node)
			node.modulate.a = 0.3
	weapons[0].modulate.a = 1

func select_weapon(new_index: int) -> void:
	if new_index >= 0 && new_index < len(weapons):
		for weapon in weapons:
			weapon.modulate.a = 0.3
		index = new_index
		var selected_weapon = weapons[index]
		selected_weapon.modulate.a = 1
		player.change_weapon(index)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_WHEEL_UP:
				select_weapon(index - 1)
			if event.button_index == BUTTON_WHEEL_DOWN:
				select_weapon(index + 1)

func delete_node(node: Node) -> void:
	weapon_container.remove_child(node)
	node.queue_free()

func _on_coin_pickedup(total_coins: int) -> void:
	$CoinCounter/number.text = str(total_coins)

func _on_player_hurt(new_health: int) -> void:
	$Health_Bar/hp.value = new_health

func _on_Gun_weapon_pickedup(weapon_texture: StreamTexture) -> void:
	var new_node = rect_gun_scn.instance()
	new_node.texture = weapon_texture
	new_node.modulate.a = 0.3
	$Weapons/Container.add_child(new_node)
	weapons.append(new_node)
	select_weapon(index)