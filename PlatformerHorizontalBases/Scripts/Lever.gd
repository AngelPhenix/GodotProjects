extends Area2D

var player_near: bool = false
var activated: bool = false
export var event_duration: float = 2.0

onready var player_camera: Camera2D = get_tree().get_nodes_in_group("player")[0].get_node("camera")

func _process(delta: float) -> void:
	if player_near && Input.is_action_just_pressed("action") && !activated:
		for node in get_children():
			if node.has_method("interaction"):
				globals.shake(player_camera, event_duration)
				$Door01.interaction(event_duration)
				activated = true

# If player enters object's area
func _on_Lever_body_entered(body: PlayerController) -> void:
	if body is PlayerController:
		player_near = true
		globals.add_outline(self)

#If player gets out of object's area
func _on_Lever_body_exited(body: PlayerController) -> void:
	if body is PlayerController:
		player_near = false
		globals.remove_outline(self)