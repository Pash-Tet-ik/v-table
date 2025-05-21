extends Node2D

var zoom_speed = 10
var drag = false
var pre_mouse_position = Vector2.ZERO
var table : Node
var input_access = true


func _ready() -> void:
	table = get_parent()
	G.user = self


func _process(delta: float) -> void:
	if input_access:
		if Input.is_action_just_pressed("will_up"):
			$camera.zoom += Vector2.ONE * delta * zoom_speed
		if Input.is_action_just_pressed("will_down"):	
			if ($camera.zoom - Vector2.ONE * delta * zoom_speed).x < 0.15:
				$camera.zoom = Vector2.ONE * 0.15
			else:
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
