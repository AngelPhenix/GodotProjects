extends Node

const BattleUnits = preload("res://BattleUnits.tres")

export (Array, PackedScene) var enemies = []

onready var battleActionButtons = $UI/BattleActionButtons
onready var nextRoomButton = $UI/CenterContainer/NextRoomButton
onready var enemyPosition = $EnemyPosition

func _ready() -> void:
	randomize()
	start_player_turn()
	var enemy = BattleUnits.Enemy
	if enemy != null:
		enemy.connect("dead", self, "_on_Enemy_dead")

func start_player_turn() -> void:
	battleActionButtons.show()
	var playerStats = BattleUnits.PlayerStats
	playerStats.ap = playerStats.max_ap
	yield(playerStats, "end_turn")
	start_enemy_turn()

func start_enemy_turn() -> void:
	battleActionButtons.hide()
	var enemy = BattleUnits.Enemy
	if enemy != null && !enemy.is_queued_for_deletion():
		enemy.attack()
		yield(enemy, "end_turn")
	start_player_turn()

func create_new_enemy():
	enemies.shuffle()
	var Enemy = enemies.front()
	var enemy = Enemy.instance()
	enemyPosition.add_child(enemy)
	enemy.connect("dead", self, "_on_Enemy_dead")

func _on_Enemy_dead():
	nextRoomButton.show()
	battleActionButtons.hide()

func _on_NextRoomButton_pressed():
	nextRoomButton.hide()
	$anim.play("fade")
	yield($anim, "animation_finished")
	var playerStats = BattleUnits.PlayerStats
	playerStats.ap = playerStats.max_ap
	battleActionButtons.show()
	create_new_enemy()