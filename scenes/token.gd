extends Area2D

@export var img_bytes : PackedByteArray

var is_dragging : bool = false
var dragging_offset = Vector2.ZERO
var size_mod = 1


func _ready() -> void:
	if img_bytes:
		var img = Image.new()
		img.load_png_from_buffer(img_bytes)
		scale = Vector2.ONE * size_mod
		set_texture(ImageTexture.create_from_image(img), 50., 50.)

func _process(delta):
	if is_dragging:
		rpc("sync_position", get_global_mouse_position() + dragging_offset)


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if !G.smth_is_pick:
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = true
			dragging_offset = global_position - get_global_mouse_position()
			G.smth_is_pick = true
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			if multiplayer.is_server():
				rpc("delite")


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and !event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_dragging = false
		dragging_offset = Vector2.ZERO
		G.smth_is_pick = false


func set_texture(img : ImageTexture, x : float, y : float):
	$Sprite2D.texture = img
	$Sprite2D.scale = Vector2(x / img.get_width(), y / img.get_height())

@rpc("any_peer", "call_local")
func sync_position(pos: Vector2):
	global_position = pos

@rpc("any_peer", "call_local")
func delite():
	if multiplayer.is_server():
		queue_free()
