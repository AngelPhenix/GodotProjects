extends "res://Scripts/Constructors/Enemy.gd"

func _ready() -> void:
	health = 5
	weight = 0.8

func _physics_process(delta: float) -> void:
	velocity.y += gravity
	
	velocity = move_and_slide(velocity, Vector2(0,-1))
	
	if is_on_floor():
		velocity.x = 0

func _on_player_detection_body_entered(body: PlayerController) -> void:
	if body is PlayerController:
		($sprite as Sprite).modulate = Color(0.231495, 0.184314, 0.788235)

func _on_player_detection_body_exited(body: PlayerController) -> void:
	if body is PlayerController:
		($sprite as Sprite).modulate = Color(0.757813, 0.215887, 0.109528)
