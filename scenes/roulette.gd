extends PanelContainer

@onready var canvas = $VBoxContainer/SubViewportContainer/SubViewport/VBoxContainer
@onready var viewport = $VBoxContainer/SubViewportContainer
@onready var type_label = $VBoxContainer/type
var offset_achieved = false
var height = 0
var height_offset = 0
@export var spd_multiplier = 0
@export var d = 0
@export var num = 0
@export var variants = []

func set_up(d : int, num : int, spd_multiplier : float):
	self.d = d
	self.num = num
	self.spd_multiplier = spd_multiplier

	variants.append(randi_range(1, d))
	for i in range(1, num + 1):
		variants.append(randi_range(1, d))
		while variants[i] == variants[i - 1]:
			variants[i] = randi_range(1, d)

func _ready() -> void:
	type_label.text = "d" + str(d)
	for i in range(num - 1):
		new_el(variants[i])

	height = canvas.get_combined_minimum_size().y
	height -= (viewport.get_combined_minimum_size().y) / 2 + height / num * 2.5
	height_offset = (float(variants[0] + variants[1]) / float(d * 3) - 0.4) * height / num
	if abs(height_offset) < height / num / 5:
		height_offset = 0
	self.spd_multiplier = spd_multiplier
	
	for i in range(0): #про запас но лучше не трогать
		new_el(d)


func _process(delta: float) -> void:
	if !offset_achieved:
		canvas.position.y -= delta * (height + height_offset + canvas.position.y) * spd_multiplier
		if canvas.position.y - 4 < -height - height_offset:
			if canvas.position.y > -height - height_offset + 1.:
				canvas.position.y -= 1.
			elif canvas.position.y < -height - height_offset - 1.:
				canvas.position.y += 1.
			else:
				offset_achieved = true
	else:
		canvas.position.y -= delta * (height + canvas.position.y) * spd_multiplier * 2.3
		if canvas.position.y - 3 < -height and canvas.position.y + 3 > -height:
			if canvas.position.y > -height + 1.:
				canvas.position.y -= 1.
			elif canvas.position.y < -height - 1.:
				canvas.position.y += 1.
			else:
				canvas.position.y = -height


func new_el(pre_result) -> int:
	var label = Label.new()
	var separator = HSeparator.new()
	label.text = str(pre_result)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	canvas.add_child(label)
	
	if d == 20:
		if pre_result == 1:
			label.add_theme_color_override("font_color", Color("#7B001C"))
		elif pre_result == 20:
			label.add_theme_color_override("font_color", Color("#F4A900"))
	
	canvas.add_child(separator)
	return pre_result
