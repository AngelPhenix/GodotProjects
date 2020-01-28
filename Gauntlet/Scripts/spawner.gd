extends Area2D

var health: int = 4
var existing_enemies: Array = []
onready var player: Object = get_tree().get_nodes_in_group("player")[0]
onready var enemy_container: Object = get_tree().get_nodes_in_group("enemy_container")[0]
const enemy_scn = preload("res://Scenes/Zombie.tscn")

func _on_spawn_timer_timeout() -> void:
	if existing_enemies.size() < 10:
		var new_enemy = enemy_scn.instance()
		new_enemy.global_position = position
		enemy_container.add_child(new_enemy)
		existing_enemies.append(new_enemy)
		new_enemy.spawner = self

func delete_object(enemy: Object) -> void:
	if existing_enemies.has(enemy):
		var enemy_index = existing_enemies.find(enemy, 0)
		existing_enemies.remove(enemy_index)

func hit(damage):
	health -= damage
	$anim.play("hit")
	if health <= 0:
		player.spawn_to_hunt -= 1
		for enemy in existing_enemies:
			enemy.spawner = null
		queue_free()