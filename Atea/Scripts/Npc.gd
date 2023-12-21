extends Area2D

onready var player = get_tree().get_nodes_in_group("player")[0]
var player_near: bool = false
var dialog = ["A little tutorial to start the game, girl ?!", 
	"... What ?! A tutorial in 2019 ? ...", 
	"Gotta do what you gotta do !"]

func _process(delta: float) -> void:
	if player_near && Input.is_action_just_pressed("action") && !player.talking:
		player.talking = true
		globals.launch_dialog(self, dialog)

func _on_NPC_body_entered(body: PlayerController) -> void:
	if body is PlayerController:
		player_near = true

func _on_NPC_body_exited(body: PlayerController) -> void:
	if body is PlayerController:
		player_near = false
		if player.talking:
			player.talking = false