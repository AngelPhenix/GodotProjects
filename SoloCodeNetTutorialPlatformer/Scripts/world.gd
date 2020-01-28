extends Node

onready var item = preload("res://Scenes/Collectable.tscn")
onready var grousk = preload("res://Scenes/Groutch.tscn")
onready var saw = preload("res://Scenes/Saw.tscn")
onready var brick = preload("res://Scenes/Breakwall.tscn")

signal score_changed(value)
signal hp_changed(value)
signal mp_changed(value)

export (int) var day_duration = 3
export var day_color = Color("#ffffff")
export var night_color = Color("#615679")
var tick = 0
var day_length = 0
var hours = 0
var number_day = 0
enum {DAY, NIGHT}
var cycle = DAY 

func _ready():
	camera_set_limit()
	spawn_items()
	$TileItems.hide()
	$TileBreakable.hide()
	
	day_length = 60 * 60 * day_duration
	tick = day_length / 2

func _physics_process(delta):
	tick += 1
	day_cycle()

func day_cycle():
	hours = int(tick / (day_length / 24))
	
	if tick > day_length:
		tick = 0
		number_day += 1
	
	if hours < 7 || hours > 18:
		cycle_test(NIGHT)
	else:
		cycle_test(DAY)

func cycle_test(new_cycle):
	if cycle != new_cycle:
		cycle = new_cycle
		var twe = Tween.new()
		if cycle == NIGHT:
			add_child(twe)
			twe.interpolate_property(
				$CanvasModulate,
				"color",
				day_color,
				night_color,
				10,
				Tween.TRANS_SINE,
				Tween.EASE_IN)
			twe.start()
			yield(twe, "tween_completed")
			twe.queue_free()
		else:
			add_child(twe)
			twe.interpolate_property(
				$CanvasModulate,
				"color",
				night_color,
				day_color,
				10,
				Tween.TRANS_SINE,
				Tween.EASE_IN)
			twe.start()
			yield(twe, "tween_completed")
			twe.queue_free()

func camera_set_limit():
	var zone = $TileMap.get_used_rect()
	var cells = $TileMap.cell_size

	$Player/camera.limit_top = zone.position.y * cells.y
	$Player/camera.limit_right = (zone.size.x + zone.position.x) * cells.x
	$Player/camera.limit_bottom = (zone.size.y + zone.position.y) * cells.y
	$Player/camera.limit_left = zone.position.x * cells.x

func spawn_items():
	for cell in $TileItems.get_used_cells():
		var id = $TileItems.get_cellv(cell)
		var tile_name = $TileItems.tile_set.tile_get_name(id)
		var position = $TileItems.map_to_world(cell)
		position = position + $TileItems.position
		var instanciated_object

		if tile_name in ["x1", "x10", "hp", "mp"]:
			instanciated_object = item.instance()
			instanciated_object.init(tile_name, position + $TileItems.cell_size/2)
			add_child(instanciated_object)
			instanciated_object.connect("picked_up", self, "_on_items_pickedup")

		if tile_name in ["grousk", "saw"]:
			if tile_name == "grousk":
				instanciated_object = grousk.instance()
			if tile_name == "saw":
				instanciated_object = saw.instance()
			instanciated_object.init(position + $TileItems.cell_size/2)
			add_child(instanciated_object)
		
	for cell in $TileBreakable.get_used_cells():
		var id = $TileBreakable.get_cellv(cell)
		var position = $TileBreakable.map_to_world(cell)
		position = position + $TileBreakable.position
		var breakable_wall = brick.instance()
		breakable_wall.init(position + $TileItems.cell_size)
		add_child(breakable_wall)
		

func _on_items_pickedup(body):
	match body:
		"x1": emit_signal("score_changed", 1)
		"x10" : emit_signal("score_changed", 10)
		"hp": emit_signal("hp_changed", 1)
		"mp": emit_signal("mp_changed", 1)