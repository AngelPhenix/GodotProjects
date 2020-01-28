extends Sprite

var positions = []
var index = 0

func _ready():
	for node in get_parent().get_children():
		if node is Label and node.visible:
			positions.append(node)
			node.modulate.a = 0.3
	set_selection(index)

func set_selection(new_index):
	if new_index >= 0 && new_index < len(positions):
		for option in positions:
			option.modulate.a = 0.3
		index = new_index
		var selected_node = positions[index]
		position = Vector2(selected_node.rect_position.x - texture.get_width()/2, selected_node.rect_position.y + selected_node.rect_size.y/2)
		selected_node.modulate.a = 1

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		set_selection(index - 1)
	if Input.is_action_just_pressed("ui_down"):
		set_selection(index + 1)
	if Input.is_action_just_pressed("ui_select"):
		var selected_position = positions[index]
		if selected_position.modulate.a == 1:
			selected_position.callback()