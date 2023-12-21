extends Node2D

onready var tiles: PackedScene = preload("res://Scenes/FloorTile.tscn")
onready var walls: PackedScene = preload("res://Scenes/WallTile.tscn")
onready var spawn_player: PackedScene = preload("res://Scenes/Spawn_Player.tscn")
onready var death_tiles: PackedScene = preload("res://Scenes/DeathTile.tscn")
onready var des_walls: PackedScene = preload("res://Scenes/DesWallTile.tscn")
onready var projectile: PackedScene = preload("res://Scenes/PlayerProjectile.tscn")
onready var teleport_scn: PackedScene = preload("res://Scenes/TeleportTile.tscn")

onready var player: Node = preload("res://Scenes/Player.tscn").instance()
onready var GUI: Node = get_tree().get_nodes_in_group("gui")[0]

var playing_zone: Rect2
var tp_array: Array


func _ready() -> void:
	$TileMap.visible = false
	$GUI/Control.visible = true
	player.connect("health_changed", GUI, "_life_changed")
	player.connect("shoot", self, "_on_player_shoot")
	# On récupère toutes les tiles qui ont l'ID 0 (Floor)
	for tile in $TileMap.get_used_cells_by_id(0):
		var new_tile: Node = tiles.instance()
		new_tile.position = tile * $TileMap.cell_size + $TileMap.cell_size / 2
		new_tile.connect("converted", GUI, "_on_converted_tile")
		add_child(new_tile)
		GUI.tile_number += 1
	
	# On récupère toutes les tiles qui ont l'ID 1 (Wall)
	for tile in $TileMap.get_used_cells_by_id(1):
		var new_wall: Node = walls.instance()
		new_wall.position = tile * $TileMap.cell_size + $TileMap.cell_size / 2
		add_child(new_wall)

	# On récupère toutes les tiles qui ont l'ID 2 (DestructableWalls)
	for tile in $TileMap.get_used_cells_by_id(2):
		var des_wall: Node = des_walls.instance()
		des_wall.position = tile * $TileMap.cell_size + $TileMap.cell_size / 2
		des_wall.connect("creating_tile", self, "_on_deswall_destroyed")
		add_child(des_wall)
	
	# On récupère toutes les tiles qui ont l'ID 3 (Player_Spawner)
	for tile in $TileMap.get_used_cells_by_id(3):
		var new_spawn_player: Node = spawn_player.instance()
		new_spawn_player.position = tile * $TileMap.cell_size + $TileMap.cell_size / 2
		add_child(new_spawn_player)
		_add_player(new_spawn_player.position)
	
	# On récupère toutes les tiles qui ont l'ID 4 (DeathTiles)
	for tile in $TileMap.get_used_cells_by_id(4):
		var death_tile: Node = death_tiles.instance()
		death_tile.position = tile * $TileMap.cell_size + $TileMap.cell_size / 2
		add_child(death_tile)
	
	# On récupère toutes les tiles qui ont l'ID 5 (Teleport)
	for tile in $TileMap.get_used_cells_by_id(5):
		var teleport_tile: Node = teleport_scn.instance()
		teleport_tile.position = tile * $TileMap.cell_size + $TileMap.cell_size / 2
		teleport_tile.connect("teleportation", self, "_on_teleport")
		tp_array.append(teleport_tile.position)
		add_child(teleport_tile)
	
	_update_label_onstart()
	_add_background_cr()


func _add_player(n_position: Vector2) -> void:
	_camera_settings(player)
	player.position = n_position
	player.start_position = n_position
	add_child(player)


# We're adding a background to the whole tilemap
func _add_background_cr() -> void:
	var color_rect = ColorRect.new()
	color_rect.color = Color(0,0,0,1)
	color_rect.show_behind_parent = true
	color_rect.rect_position.x = playing_zone.position.x
	color_rect.rect_position.y = playing_zone.position.y * $TileMap.cell_size.y
	color_rect.rect_size.x = playing_zone.size.x * $TileMap.cell_size.x
	color_rect.rect_size.y = playing_zone.size.y * $TileMap.cell_size.y
	add_child(color_rect)


# Updates the Tile number $Label in the GUI to display the correct number of tiles to convert
func _update_label_onstart() -> void:
	GUI.get_node("Tiles").text = "Tiles to convert : " + str(GUI.tile_number)
	GUI.get_node("LifeHUD").value = player.life


func _on_teleport(current_position: Vector2) -> void:
	if player.can_teleport:
		var tp_array_dupe: Array = tp_array.duplicate()
		tp_array_dupe.erase(current_position)
		player.position = tp_array_dupe[0]
		player.can_teleport = false


func _camera_settings(attached_to: Node) -> void:
	playing_zone = $TileMap.get_used_rect()
	var camera = attached_to.get_node("Camera2D")
	camera.limit_left = playing_zone.position.x
	camera.limit_top = playing_zone.position.y * $TileMap.cell_size.y
	camera.limit_right = playing_zone.size.x * $TileMap.cell_size.x
	camera.offset.x = $GUI/Control/ColorRect.rect_size.x
	camera.limit_bottom = (playing_zone.size.y * $TileMap.cell_size.y) + camera.limit_top


func _on_player_shoot(player_direction: Vector2) -> void:
	var new_projectile: Node = projectile.instance()
	new_projectile.direction = player_direction
	new_projectile.position = player.position
	add_child(new_projectile)


func _on_deswall_destroyed(pos) -> void:
	var new_tile: Node = tiles.instance()
	new_tile.position = pos
	new_tile.connect("converted", GUI, "_on_converted_tile")
	call_deferred("add_child", new_tile)
	GUI.tile_number += 1
	GUI.get_node("Tiles").text = "Tiles to convert : " + str(GUI.tile_number)
