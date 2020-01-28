extends Node2D

const BattleUnits = preload("res://BattleUnits.tres")

export (int) var hp = 25 setget set_hp
export (int) var damage = 3

signal dead
signal end_turn

func _ready():
	BattleUnits.Enemy = self

func _exit_tree():
	BattleUnits.Enemy = null

func set_hp(new_hp) -> void:
	hp = new_hp
	$HPLabel.text = str(hp) + "hp"

func attack() -> void:
	yield(get_tree().create_timer(0.4), "timeout")
	$anim.play("attack")
	yield($anim, "animation_finished")
	emit_signal("end_turn")

func deal_damage(value: int) -> void:
	BattleUnits.PlayerStats.hp -= damage

func take_damage(value: int) -> void:
	self.hp -= value
	if is_dead():
		emit_signal("dead")
		queue_free()
	else:
		$anim.play("shake")

func is_dead() -> bool:
	return hp <= 0