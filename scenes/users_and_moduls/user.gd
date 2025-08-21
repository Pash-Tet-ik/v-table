extends Node2D

var zoom_speed = 10
var drag = false
var pre_mouse_position = Vector2.ZERO
var input_access = true


func _ready() -> void:
	G.user = self


func _process(delta: float) -> void:
	if input_access:
		if Input.is_action_just_pressed("will_up"):
			if ($camera.zoom - Vector2.ONE * delta * zoom_speed).x < 2.:
				$camera.zoom += Vector2.ONE * delta * zoom_speed

		if Input.is_action_just_pressed("will_down"):	
			if ($camera.zoom - Vector2.ONE * delta * zoom_speed).x > 0.25:
				$camera.zoom -= Vector2.ONE * delta * zoom_speed

		if Input.is_action_just_pressed("will_btn"):
			drag = true

	if Input.is_action_just_released("will_btn"):
		drag = false
		pre_mouse_position = Vector2.ZERO

	if drag:
		if pre_mouse_position == Vector2.ZERO:
			pre_mouse_position = get_global_mouse_position()
		else:
			position += pre_mouse_position - get_global_mouse_position()
