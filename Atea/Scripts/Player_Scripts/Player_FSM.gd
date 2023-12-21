extends AnimationTree

onready var playback: AnimationNodeStateMachinePlayback = get("parameters/playback")
onready var player: PlayerController = get_parent()

func _ready() -> void:
	playback.start("Idle")

func _process(delta: float) -> void:
	# Moving animations
	if Input.is_action_pressed("right"):
		playback.travel("Run")
		player.get_node("sprite").flip_h = false
	elif Input.is_action_pressed("left"):
		playback.travel("Run")
		player.get_node("sprite").flip_h = true
	else:
		playback.travel("Idle")

	# Jumping Animations
	if player.velocity.y < 0:
		if player.jump_count == 2:
			playback.travel("Double_jump")
		else:
			playback.travel("Rise")
	else: 
		if !player.is_on_floor():
			playback.travel("Fall")
	
	if player.dashing:
		playback.travel("Dash")