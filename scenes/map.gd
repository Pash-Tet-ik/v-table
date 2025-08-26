extends PanelContainer

@export var img_bytes : PackedByteArray

var is_dragging : bool = false
var dragging_offset = Vector2.ZERO


func _ready() -> void:
	if img_bytes:
		var img = Image.new()
		img.load_png_from_buffer(img_bytes)
		set_texture(ImageTexture.create_from_image(img))

func _process(delta):
	if is_dragging:
		rpc("sync_position", get_global_mouse_position() + dragging_offset)

func _on_header_button_down() -> void:
	if multiplayer.is_server():
		if !G.smth_is_pick:
			is_dragging = true
			dragging_offset = global_position - get_global_mouse_position()
			G.smth_is_pick = true

func _on_header_button_up() -> void:
	if multiplayer.is_server():
		is_dragging = false
		dragging_offset = Vector2.ZERO
		G.smth_is_pick = false


func set_texture(img : ImageTexture):
	$VBoxContainer/TextureRect.texture = img

func _on_close_pressed() -> void:
	if multiplayer.is_server():
		rpc("delite")


@rpc("any_peer", "call_local")
func sync_position(pos: Vector2):
	global_position = pos


@rpc("any_peer", "call_local")
func delite():
	if multiplayer.is_server():
		queue_free()
