extends Node

var outline_shader: Shader = preload("res://Shaders/outline.shader")
var dialog_box_scn: PackedScene = preload("res://Scenes/DialogBox.tscn")
onready var hud: Node = get_tree().get_nodes_in_group("player_hud")[0]

# ====================== DIALOG BOX ======================
func launch_dialog(npc: Object, dialog_from_npc: Array):
	var dialog_box: Object = dialog_box_scn.instance()
	var dialog_text: RichTextLabel = dialog_box.get_node("text")
	dialog_text.dialog = dialog_from_npc
	hud.add_child(dialog_box)

# ====================== CAMERA SHAKE ======================
func shake(camera: Camera2D, duration: float = 2.0, amplitude: float = 5.0) -> void:
	camera.amplitude = amplitude
	var camera_timer: Timer = camera.get_node("shake_duration")
	camera_timer.wait_time = duration
	camera_timer.start()
	camera.set_process(true)

# ====================== SHADERS ======================
func add_outline(object_to_outline: Object, width: int = 2, outline_color: Color = Color(255,255,255)) -> void:
	var sprite = object_to_outline.get_node("sprite")
	var material = ShaderMaterial.new()
	sprite.material = material
	sprite.material.shader = outline_shader
	sprite.material.set_shader_param("width", width)
	sprite.material.set_shader_param("outline_color", outline_color)

func remove_outline(outlined_object: Object) -> void:
	outlined_object.get_node("sprite").material = null