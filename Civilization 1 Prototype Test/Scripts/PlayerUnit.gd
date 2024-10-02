extends KinematicBody2D
class_name BaseUnit

onready var map: TileMap = get_tree().get_root().get_node("/root/World/Map")
onready var fow_map: TileMap = get_tree().get_root().get_node('/root/World/FOW')

# MOVING VARIABLES
var movement: Vector2
var tile_size: int
var is_moving: bool = false
var total_movements: int = 3
var movements_left: int
export var animation_speed: float = .5

# GAME VARIABLES
var health: int = 1
var attack: int = 1
var defense: int = 1
var vision_radius: int = 2
var is_selected: bool = false
var turn_id: int

# FSM VARIABLES
var state: int
enum unit_state {STOPPED, PLAYING, WAITING, MOVING}
signal change_unit

# ENVIRONMENT VARIABLES
var terrain: int
enum {WATER, GROUND}

# Base the tile_size on the size of the texture used * sprite scale.
func _ready() -> void:
	connect("change_unit", get_tree().get_root().get_node("/root/World"), "get_next_unit", [get_parent().get_parent()])
	tile_size = ($sprite as Sprite).texture.get_width() * ($sprite as Sprite).scale.x
	movements_left = total_movements
	clear_fog_at(global_position)
	state_loop()

# Stops the inputs if the unit didn't finish its movement.
func _physics_process(delta: float) -> void:
	if state == unit_state.PLAYING && !is_moving:
		movement_loop()
	state_loop()

func state_loop():
	if state == unit_state.PLAYING && movement != Vector2.ZERO:
		change_state(unit_state.MOVING)
	if state in [unit_state.PLAYING, unit_state.MOVING] && movement == Vector2.ZERO:
		change_state(unit_state.PLAYING)
	if state == unit_state.MOVING && movements_left == 0:
		change_state(unit_state.STOPPED)

func change_state(new_state: int) -> void:
	state = new_state
	match state:
		unit_state.PLAYING:
			($anim as AnimationPlayer).play("idle")
		unit_state.MOVING:
			($tween as Tween).interpolate_property(self, "position", position, position + movement * tile_size, animation_speed, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			($tween as Tween).start()
		unit_state.STOPPED:
			($anim as AnimationPlayer).stop()
			yield(get_tree().create_timer(0.2), "timeout")
			emit_signal("change_unit")

# unit not moving, get movement to execute tween with "animation_speed"(export) speed.
func movement_loop() -> void:
	if Input.is_action_just_pressed("top"):
		movement = Vector2(0,-1)
	elif Input.is_action_just_pressed("top-right"):
		movement = Vector2(1,-1)
	elif Input.is_action_just_pressed("right"):
		movement = Vector2(1, 0)
	elif Input.is_action_just_pressed("down-right"):
		movement = Vector2(1, 1)
	elif Input.is_action_just_pressed("down"):
		movement = Vector2(0, 1)
	elif Input.is_action_just_pressed("down-left"):
		movement = Vector2(-1, 1)
	elif Input.is_action_just_pressed("left"):
		movement = Vector2(-1, 0)
	elif Input.is_action_just_pressed("top-left"):
		movement = Vector2(-1, -1)
	else:
		movement = Vector2()
	
	check_tile(movement)

func check_tile(direction: Vector2) -> void:
	var ground_cells: Array = map.get_used_cells_by_id(GROUND)
	var player_pos: Vector2 = map.world_to_map(position)
	if !ground_cells.has(player_pos + direction):
		movement = Vector2()

func clear_fog_at(unit_position: Vector2) -> void:
	var unit_tile_position = unit_position / tile_size
	for x in range(unit_tile_position.x - vision_radius, unit_tile_position.x + (vision_radius+1)):
		for y in range(unit_tile_position.y - vision_radius, unit_tile_position.y + (vision_radius+1)):
			fow_map.set_cell(x, y, -1)

# Unit moving, stop flickering animation and inputs.
func _on_tween_tween_started(object: Object, key: NodePath) -> void:
	($sprite as Sprite).visible = true
	($anim as AnimationPlayer).stop()
	is_moving = true
	movements_left -= 1
	clear_fog_at(global_position)

# Unit finished moving : inputs are free and flickering animation restarts.
func _on_tween_tween_completed(object: Object, key: NodePath) -> void:
	is_moving = false
	movement = Vector2.ZERO
	clear_fog_at(global_position)
