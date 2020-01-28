extends KinematicBody2D
class_name Unit

onready var map: TileMap = get_tree().get_root().get_node("/root/World/Map")

# MOVING VARIABLES
var movement: Vector2
var tile_size: int
var is_moving: bool = false
export var animation_speed: float = .5

# GAME VARIABLES
var attack: int = 1
var defense: int = 1
var total_movements: int = 3
var is_selected: bool = false
var turn_id: int
var movements_left: int
signal change_unit

# FSM VARIABLES
var state: int
enum unit_state {STOPPED, PLAYING, WAITING, MOVING}

# ENVIRONMENT VARIABLES
var terrain: int
enum {WATER, GROUND}

# Base the tile_size on the size of the texture used * sprite scale.
func _ready() -> void:
	connect("change_unit", get_tree().get_root().get_node("/root/World"), "get_next_unit", [get_parent().get_parent()])
	tile_size = ($sprite as Sprite).texture.get_width() * ($sprite as Sprite).scale.x
	movements_left = total_movements
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

# Unit moving, stop flickering animation and inputs.
func _on_tween_tween_started(object: Object, key: NodePath) -> void:
	($sprite as Sprite).visible = true
	($anim as AnimationPlayer).stop()
	is_moving = true
	movements_left -= 1

# Unit finished moving : inputs are free and flickering animation restarts.
func _on_tween_tween_completed(object: Object, key: NodePath) -> void:
	is_moving = false
	movement = Vector2.ZERO