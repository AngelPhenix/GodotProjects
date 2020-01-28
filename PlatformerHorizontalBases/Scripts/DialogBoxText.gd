extends RichTextLabel

onready var player = get_tree().get_nodes_in_group("player")[0]
var dialog: Array = ["Pawaaaa"]
var page: int = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("action"):
		if visible_characters > get_total_character_count():
			if page < dialog.size() -1:
				page += 1
				bbcode_text = dialog[page]
				visible_characters = 0
			else:
				player.move_loop_state = true
				get_parent().queue_free()
		else:
			visible_characters = get_total_character_count()

func _ready():
	bbcode_text = dialog[page]
	visible_characters = 0
	player.move_loop_state = false

func _on_char_timer_timeout():
	visible_characters = visible_characters + 1