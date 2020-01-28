extends Node

const enemies = [preload("res://scenes/Enemy_clever.tscn"),
preload("res://scenes/Enemy_kamikaze.tscn"),
preload("res://scenes/Enemy_rotating.tscn")]

const scn_boss = preload("res://scenes/Boss01.tscn")
const scn_warning = preload("res://scenes/Warning.tscn")

func _ready():
	spawn()

func spawn():
	$spawn_timer.wait_time = rand_range(0.4, 0.9)
	$spawn_timer.start()
	var game_width = get_viewport().get_visible_rect().size.x
	randomize()
	var enemy = enemies[randi() % enemies.size()].instance()
	var half_x_enemy_sprite = enemy.get_node("sprite").texture.get_size().x/2
	var position = Vector2()
	position.x = rand_range(0+half_x_enemy_sprite, game_width-half_x_enemy_sprite)
	position.y = 0-half_x_enemy_sprite
	enemy.set_position(position)
	$container.add_child(enemy)

func _on_spawn_timer_timeout():
	if get_tree().get_nodes_in_group('score')[0].score < 1500:
		spawn()
	else:
		$spawn_timer.stop()
		var warning = scn_warning.instance()
		warning.position = Vector2(90,150)
		get_tree().get_nodes_in_group("world")[0].add_child(warning)
		warning.connect("warning_done", self, "spawn_boss")

func spawn_boss():
	var boss = scn_boss.instance()
	boss.set_position(Vector2(get_viewport().get_visible_rect().size.x/2, -20))
	$container.add_child(boss)

# choose spawner between two spawn function
# 1 spawner will simply spawn the enemies in the static spawn method that will spawn monsters
# in a certain area of the map because they don't have path2d to follow and can't get out of the screen.
# The second spawner will spawn the enemies having path2ds only and at different spawning points
# so they won't get out of the screen while following their path