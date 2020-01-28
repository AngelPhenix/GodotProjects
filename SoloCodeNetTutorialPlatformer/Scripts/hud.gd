extends Control

onready var player = get_parent().get_node("Player")

var hp = 8
var hp_max = 8
var mp = 8
var mp_max = 8
var score = 0

signal dead

func _ready():
	player.connect("damaged", self, "_on_Player_damaged")
	Engine.time_scale = 1

func _process(delta):
	$CanvasLayer/VBoxContainer/HBoxContainer3/xx.text = str(score)
	$CanvasLayer/VBoxContainer/HBoxContainer2/mp.value = mp
	$CanvasLayer/VBoxContainer/HBoxContainer/hp.value = hp

func _on_World_hp_changed(value):
	hp = min(hp + value, hp_max)

func _on_World_mp_changed(value):
	mp = min(mp + value, mp_max)

func _on_World_score_changed(value):
	score += value

func _on_Player_damaged(value):
	hp -= value
	if hp <= 0:
		emit_signal("dead")
		Engine.time_scale = 0.5
		$CanvasLayer/anim.play("game_over")
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_restart_pressed():
	get_tree().reload_current_scene()
