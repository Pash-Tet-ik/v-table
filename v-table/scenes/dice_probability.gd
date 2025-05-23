# dice_probability.gd
extends Control

# --- UI Элементы ---
@onready var modifier_spinbox = $MarginContainer/VBoxContainer/ModifierInput/ModifierSpinBox
@onready var graph_container = $MarginContainer/VBoxContainer/GraphContainer
@onready var back_button = $BackButton

# UI для Преимущества/Помехи (Advantage/Disadvantage)
@onready var adv_dis_active_checkbox = $MarginContainer/VBoxContainer/AdvantageDisadvantageToggle/AdvDisActiveCheckBox
@onready var adv_dis_settings_container = $MarginContainer/VBoxContainer/AdvantageDisadvantageSettings
@onready var adv_dis_type_optionbutton = $MarginContainer/VBoxContainer/AdvantageDisadvantageSettings/AdvDisTypeOptionButton
@onready var adv_dis_count_spinbox = $MarginContainer/VBoxContainer/AdvantageDisadvantageSettings/AdvDisCountSpinBox

# UI для Бонусных кубов
@onready var bonus_dice_active_checkbox = $MarginContainer/VBoxContainer/BonusDiceToggle/BonusDiceActiveCheckBox
@onready var bonus_dice_settings_container = $MarginContainer/VBoxContainer/BonusDiceSettings
@onready var bonus_dice_rows_container = $MarginContainer/VBoxContainer/BonusDiceSettings/BonusDiceRowsContainer
@onready var add_bonus_die_button = $MarginContainer/VBoxContainer/BonusDiceSettings/AddBonusDieButton

# --- Константы для расчёта ---
const D20_SIDES = 20 # Основной куб d20
const CRIT_FAIL = 1
const CRIT_SUCCESS = 20
const MIN_DC = 5
const MAX_DC = 25

const BONUS_DICE_TYPES = { "d4": 4, "d6": 6, "d8": 8, "d10": 10, "d12": 12, "d20": 20 }
const BONUS_DICE_TYPE_NAMES = ["d4", "d6", "d8", "d10", "d12", "d20"]

# --- Массив для хранения вероятностей P(pass DC) ---
var probabilities: Array[float] = []

# --- Константы для графика ---
const GRAPH_MARGIN = 40.0
const GRAPH_COLOR = Color(0.2, 0.6, 1.0)
const AXIS_COLOR = Color(0.7, 0.7, 0.7)
const TEXT_COLOR = Color(0.9, 0.9, 0.9)
const LABEL_FONT_SIZE = 14

var label_font: Font 

# --- Состояния ---
# Преимущество/Помеха
var adv_dis_is_active: bool = false
var adv_dis_is_advantage: bool = true # true для преимущества, false для помехи
var adv_dis_roll_count: int = 1       # Количество *дополнительных* d20 (т.е. 1 -> 2d20)

# Бонусные кубы
var bonus_dice_is_active: bool = false
var bonus_dice_configs: Array[Dictionary] = [] # [{ "count": int, "sides": int }, ...]

# --- Tooltip ---
var graph_points_data: Array[Dictionary] = []
var tooltip_node: Label
const TOOLTIP_HOVER_RADIUS_SQUARED = 8.0 * 8.0


func _ready() -> void:
	if not is_instance_valid(label_font):
		label_font = SystemFont.new() 

	# --- Общие настройки ---
	modifier_spinbox.min_value = -20; modifier_spinbox.max_value = 25
	modifier_spinbox.value = 0; modifier_spinbox.step = 1
	
	# --- Настройки Преимущества/Помехи ---
	adv_dis_settings_container.visible = false
	adv_dis_active_checkbox.button_pressed = adv_dis_is_active
	adv_dis_type_optionbutton.clear()
	adv_dis_type_optionbutton.add_item("Преимущество", 0)
	adv_dis_type_optionbutton.add_item("Помеха", 1)
	adv_dis_type_optionbutton.selected = 0 if adv_dis_is_advantage else 1
	adv_dis_count_spinbox.min_value = 1
	adv_dis_count_spinbox.max_value = 5 # Максимум 5 доп. d20
	adv_dis_count_spinbox.value = adv_dis_roll_count
	adv_dis_count_spinbox.step = 1
	
	# --- Настройки Бонусных кубов ---
	bonus_dice_settings_container.visible = false
	bonus_dice_active_checkbox.button_pressed = bonus_dice_is_active
	if bonus_dice_is_active and bonus_dice_configs.is_empty():
		bonus_dice_configs.append({ "count": 1, "sides": BONUS_DICE_TYPES["d4"] }) # По умолчанию +1d4
	_rebuild_bonus_dice_ui()

	# --- Tooltip ---
	tooltip_node = Label.new(); tooltip_node.name = "PointTooltip"
	var style_box = StyleBoxFlat.new(); style_box.bg_color = Color(0.1, 0.1, 0.15, 0.9)
	style_box.border_width_left = 1; style_box.border_width_top = 1; style_box.border_width_right = 1; style_box.border_width_bottom = 1
	style_box.border_color = Color(0.5, 0.5, 0.6, 0.9)
	style_box.content_margin_left = 8; style_box.content_margin_right = 8; style_box.content_margin_top = 5; style_box.content_margin_bottom = 5
	style_box.set_corner_radius_all(4)
	tooltip_node.add_theme_stylebox_override("panel", style_box)
	tooltip_node.add_theme_font_override("font", label_font)
	tooltip_node.add_theme_font_size_override("font_size", LABEL_FONT_SIZE - 2)
	tooltip_node.add_theme_color_override("font_color", TEXT_COLOR)
	tooltip_node.mouse_filter = MOUSE_FILTER_IGNORE; tooltip_node.visible = false; tooltip_node.z_index = 100
	add_child(tooltip_node)

	# --- Подключения сигналов ---
	# Общие
	if not modifier_spinbox.value_changed.is_connected(_on_modifier_changed):
		modifier_spinbox.value_changed.connect(_on_modifier_changed)
	# Преимущество/Помеха
	if not adv_dis_active_checkbox.toggled.is_connected(_on_adv_dis_active_toggled):
		adv_dis_active_checkbox.toggled.connect(_on_adv_dis_active_toggled)
	if not adv_dis_type_optionbutton.item_selected.is_connected(_on_adv_dis_type_selected):
		adv_dis_type_optionbutton.item_selected.connect(_on_adv_dis_type_selected)
	if not adv_dis_count_spinbox.value_changed.is_connected(_on_adv_dis_count_changed):
		adv_dis_count_spinbox.value_changed.connect(_on_adv_dis_count_changed)
	# Бонусные кубы
	if not bonus_dice_active_checkbox.toggled.is_connected(_on_bonus_dice_active_toggled):
		bonus_dice_active_checkbox.toggled.connect(_on_bonus_dice_active_toggled)
	if not add_bonus_die_button.pressed.is_connected(_on_add_bonus_die_button_pressed):
		add_bonus_die_button.pressed.connect(_on_add_bonus_die_button_pressed)
	# Остальные
	if not back_button.pressed.is_connected(_on_back_pressed):
		back_button.pressed.connect(_on_back_pressed)
	if not graph_container.resized.is_connected(_on_graph_resized):
		graph_container.resized.connect(_on_graph_resized)
	
	recalculate_and_redraw()

# --- Обработчики сигналов (Общие) ---
func _on_modifier_changed(_new_value: float) -> void: recalculate_and_redraw()
func _on_graph_resized() -> void: queue_redraw()
func _on_back_pressed() -> void: get_tree().change_scene_to_file("res://scenes/menu.tscn")

# --- Обработчики сигналов (Преимущество/Помеха) ---
func _on_adv_dis_active_toggled(button_pressed: bool) -> void:
	adv_dis_is_active = button_pressed
	adv_dis_settings_container.visible = adv_dis_is_active
	if adv_dis_is_active: # Обновить значения из UI при активации
		_on_adv_dis_type_selected(adv_dis_type_optionbutton.selected)
		_on_adv_dis_count_changed(adv_dis_count_spinbox.value)
	recalculate_and_redraw()

func _on_adv_dis_type_selected(index: int) -> void:
	adv_dis_is_advantage = (index == 0)
	if adv_dis_is_active: recalculate_and_redraw()

func _on_adv_dis_count_changed(new_value: float) -> void:
	adv_dis_roll_count = int(new_value)
	if adv_dis_is_active: recalculate_and_redraw()

# --- Обработчики сигналов (Бонусные кубы) ---
func _on_bonus_dice_active_toggled(button_pressed: bool) -> void:
	bonus_dice_is_active = button_pressed
	bonus_dice_settings_container.visible = bonus_dice_is_active
	if bonus_dice_is_active and bonus_dice_configs.is_empty():
		bonus_dice_configs.append({ "count": 1, "sides": BONUS_DICE_TYPES["d4"] }) # По умолчанию +1d4
		_rebuild_bonus_dice_ui()
	recalculate_and_redraw()

func _on_add_bonus_die_button_pressed() -> void:
	bonus_dice_configs.append({ "count": 1, "sides": BONUS_DICE_TYPES["d4"] }) 
	_rebuild_bonus_dice_ui()
	recalculate_and_redraw()

func _on_bonus_die_config_changed(value, index: int, field: String) -> void:
	if index < 0 or index >= bonus_dice_configs.size(): return
	if field == "count": bonus_dice_configs[index].count = int(value)
	elif field == "sides_idx":
		var type_name = BONUS_DICE_TYPE_NAMES[int(value)]
		bonus_dice_configs[index].sides = BONUS_DICE_TYPES[type_name]
	recalculate_and_redraw()

func _on_remove_bonus_die_button_pressed(index: int) -> void:
	if index < 0 or index >= bonus_dice_configs.size(): return
	bonus_dice_configs.remove_at(index)
	_rebuild_bonus_dice_ui()
	recalculate_and_redraw()
	
func _rebuild_bonus_dice_ui() -> void:
	for child in bonus_dice_rows_container.get_children(): child.queue_free()
	for i in range(bonus_dice_configs.size()):
		var config = bonus_dice_configs[i]
		var row_hbox = HBoxContainer.new(); row_hbox.alignment = BoxContainer.ALIGNMENT_CENTER 
		var count_spinbox = SpinBox.new(); count_spinbox.min_value = -10; count_spinbox.max_value = 10  
		count_spinbox.step = 1; count_spinbox.value = config.count; count_spinbox.custom_minimum_size.x = 60
		count_spinbox.value_changed.connect(Callable(self, "_on_bonus_die_config_changed").bind(i, "count"))
		row_hbox.add_child(count_spinbox)
		var type_optionbutton = OptionButton.new(); type_optionbutton.custom_minimum_size.x = 80
		var selected_idx = 0
		for j in range(BONUS_DICE_TYPE_NAMES.size()):
			var type_name = BONUS_DICE_TYPE_NAMES[j]
			type_optionbutton.add_item(type_name, j)
			if BONUS_DICE_TYPES[type_name] == config.sides: selected_idx = j
		type_optionbutton.select(selected_idx)
		type_optionbutton.item_selected.connect(Callable(self, "_on_bonus_die_config_changed").bind(i, "sides_idx"))
		row_hbox.add_child(type_optionbutton)
		var remove_button = Button.new(); remove_button.text = "X"
		remove_button.pressed.connect(Callable(self, "_on_remove_bonus_die_button_pressed").bind(i))
		row_hbox.add_child(remove_button)
		bonus_dice_rows_container.add_child(row_hbox)

# --- Логика расчета ---
func recalculate_and_redraw() -> void:
	calculate_probabilities(int(modifier_spinbox.value))
	graph_points_data.clear() 
	queue_redraw()

func _convolve_distributions(dist1: Dictionary, dist2: Dictionary) -> Dictionary:
	var result_dist: Dictionary = {}; if dist1.is_empty(): return dist2; if dist2.is_empty(): return dist1
	for v1_key in dist1:
		var v1 = float(v1_key); var p1 = dist1[v1_key]
		for v2_key in dist2:
			var v2 = float(v2_key); var p2 = dist2[v2_key]
			var sum_val = v1 + v2; var sum_prob = p1 * p2
			result_dist[sum_val] = result_dist.get(sum_val, 0.0) + sum_prob
	return result_dist

func get_bonus_dice_sum_distribution(configs: Array[Dictionary]) -> Dictionary:
	var overall_dist: Dictionary = {0.0: 1.0} 
	for entry in configs:
		var n_count = entry.count; var s_sides = entry.sides; if n_count == 0: continue
		var single_die_dist: Dictionary = {}; var die_value_sign = 1 if n_count > 0 else -1
		for i in range(1, s_sides + 1): single_die_dist[float(i * die_value_sign)] = 1.0 / float(s_sides)
		var num_to_convolve = abs(n_count); if num_to_convolve == 0: continue 
		var current_sum_for_this_type_dist: Dictionary = single_die_dist 
		for _i in range(1, num_to_convolve): current_sum_for_this_type_dist = _convolve_distributions(current_sum_for_this_type_dist, single_die_dist)
		overall_dist = _convolve_distributions(overall_dist, current_sum_for_this_type_dist)
	return overall_dist

func calculate_probabilities(flat_modifier: int) -> void:
	var num_dc_values = MAX_DC - MIN_DC + 1
	probabilities.resize(num_dc_values); probabilities.fill(0.0)

	var bonus_sum_dist: Dictionary
	if bonus_dice_is_active and not bonus_dice_configs.is_empty():
		bonus_sum_dist = get_bonus_dice_sum_distribution(bonus_dice_configs)
	else:
		bonus_sum_dist = {0.0: 1.0} # Нет бонусных кубов = бонус 0 с вероятностью 100%

	for dc_idx in range(num_dc_values):
		var current_dc = MIN_DC + dc_idx
		var chance_to_pass_current_dc_total = 0.0

		# Итерируем по всем возможным ИТОГОВЫМ значениям d20 (после преимущества/помехи)
		for effective_d20_roll in range(1, D20_SIDES + 1):
			var prob_of_this_effective_d20_roll: float

			if not adv_dis_is_active:
				# Стандартный бросок d20
				prob_of_this_effective_d20_roll = 1.0 / float(D20_SIDES)
			else:
				# Расчет вероятности для advantage/disadvantage
				var num_d20s_for_adv_dis = adv_dis_roll_count + 1
				if adv_dis_is_advantage:
					var prob_max_le_val = pow(float(effective_d20_roll) / D20_SIDES, num_d20s_for_adv_dis)
					var prob_max_le_val_minus_1 = 0.0
					if effective_d20_roll > 1:
						prob_max_le_val_minus_1 = pow(float(effective_d20_roll - 1) / D20_SIDES, num_d20s_for_adv_dis)
					prob_of_this_effective_d20_roll = prob_max_le_val - prob_max_le_val_minus_1
				else: # Помеха
					var prob_min_ge_val = pow(float(D20_SIDES - effective_d20_roll + 1) / D20_SIDES, num_d20s_for_adv_dis)
					var prob_min_ge_val_plus_1 = 0.0
					if effective_d20_roll < D20_SIDES:
						prob_min_ge_val_plus_1 = pow(float(D20_SIDES - (effective_d20_roll + 1) + 1) / D20_SIDES, num_d20s_for_adv_dis)
					prob_of_this_effective_d20_roll = prob_min_ge_val - prob_min_ge_val_plus_1
			
			if prob_of_this_effective_d20_roll == 0.0: # Оптимизация, если такое значение d20 невозможно
				continue

			# Обработка критического успеха/провала для effective_d20_roll
			if effective_d20_roll == CRIT_SUCCESS: 
				chance_to_pass_current_dc_total += prob_of_this_effective_d20_roll # Автоуспех
				continue 
			if effective_d20_roll == CRIT_FAIL: 
				# Автопровал, ничего не добавляем к шансу успеха
				continue 
			
			# Если не крит, применяем модификаторы и бонусные кубы
			var d20_plus_flat_mod = effective_d20_roll + flat_modifier
			var prob_success_with_bonus_for_this_d20 = 0.0
			for bonus_sum_val_key in bonus_sum_dist:
				var bonus_sum_val = float(bonus_sum_val_key)
				var prob_bonus_sum = bonus_sum_dist[bonus_sum_val_key]
				if d20_plus_flat_mod + bonus_sum_val >= current_dc:
					prob_success_with_bonus_for_this_d20 += prob_bonus_sum
			
			chance_to_pass_current_dc_total += prob_of_this_effective_d20_roll * prob_success_with_bonus_for_this_d20
		
		probabilities[dc_idx] = chance_to_pass_current_dc_total


# --- _process для Tooltip (без изменений) ---
func _process(_delta: float) -> void:
	if not is_instance_valid(graph_container) or not is_instance_valid(tooltip_node): return
	var mouse_pos_global = get_global_mouse_position()
	var found_hovered_point = false; var active_point_data: Dictionary = {}
	if graph_container.get_global_rect().has_point(mouse_pos_global):
		var local_mouse_pos_in_self = get_local_mouse_position()
		for point_data in graph_points_data:
			if local_mouse_pos_in_self.distance_squared_to(point_data.local_pos) < TOOLTIP_HOVER_RADIUS_SQUARED:
				active_point_data = point_data; found_hovered_point = true; break
	if found_hovered_point and not active_point_data.is_empty():
		tooltip_node.text = "Сложность: %d\nВероятность: %.1f%%" % [active_point_data.dc, active_point_data.probability * 100.0]
		tooltip_node.reset_size() 
		var final_tooltip_pos = mouse_pos_global + Vector2(15, 15); var viewport_rect = get_viewport_rect()
		if final_tooltip_pos.x + tooltip_node.size.x > viewport_rect.size.x - 5: final_tooltip_pos.x = mouse_pos_global.x - tooltip_node.size.x - 15 
		if final_tooltip_pos.x < 5: final_tooltip_pos.x = 5
		if final_tooltip_pos.y + tooltip_node.size.y > viewport_rect.size.y - 5: final_tooltip_pos.y = mouse_pos_global.y - tooltip_node.size.y - 10 
		if final_tooltip_pos.y < 5: final_tooltip_pos.y = 5
		tooltip_node.global_position = final_tooltip_pos; tooltip_node.visible = true
	else: tooltip_node.visible = false

# --- _draw для Графика ---
func _draw() -> void:
	if not is_instance_valid(graph_container) or not is_instance_valid(label_font): return
	var graph_area_offset_from_self = graph_container.get_global_position() - get_global_position()
	var current_graph_width = graph_container.size.x - GRAPH_MARGIN * 2
	var current_graph_height = graph_container.size.y - GRAPH_MARGIN * 2
	if current_graph_width <= 0 or current_graph_height <= 0 or probabilities.is_empty(): return
	draw_line(graph_area_offset_from_self + Vector2(GRAPH_MARGIN, graph_container.size.y - GRAPH_MARGIN),
			  graph_area_offset_from_self + Vector2(graph_container.size.x - GRAPH_MARGIN, graph_container.size.y - GRAPH_MARGIN), AXIS_COLOR, 2.0)
	draw_line(graph_area_offset_from_self + Vector2(GRAPH_MARGIN, GRAPH_MARGIN),
			  graph_area_offset_from_self + Vector2(GRAPH_MARGIN, graph_container.size.y - GRAPH_MARGIN), AXIS_COLOR, 2.0)
	var points_to_draw: Array[Vector2] = []; var dc_range_size = MAX_DC - MIN_DC
	if graph_points_data.size() != probabilities.size(): graph_points_data.clear()
	for i in range(probabilities.size()):
		var current_dc_value = MIN_DC + i; var probability_value = probabilities[i]
		var x_ratio = 0.5; if probabilities.size() > 1 : x_ratio = float(i) / float(probabilities.size() - 1)
		var x_in_graph_content = x_ratio * current_graph_width; var y_in_graph_content = probability_value * current_graph_height
		var x_rel_to_graph_container = GRAPH_MARGIN + x_in_graph_content
		var y_rel_to_graph_container = graph_container.size.y - GRAPH_MARGIN - y_in_graph_content
		var point_local_to_self = graph_area_offset_from_self + Vector2(x_rel_to_graph_container, y_rel_to_graph_container)
		points_to_draw.append(point_local_to_self)
		var point_meta_data = {"local_pos": point_local_to_self, "dc": current_dc_value, "probability": probability_value}
		if i >= graph_points_data.size(): graph_points_data.append(point_meta_data)
		else: graph_points_data[i] = point_meta_data
	if points_to_draw.size() > 1:
		for i in range(points_to_draw.size() - 1): draw_line(points_to_draw[i], points_to_draw[i + 1], GRAPH_COLOR, 2.0)
	for point_pos in points_to_draw: draw_circle(point_pos, 4.0, GRAPH_COLOR)
	
	var x_label_step = 2
	if dc_range_size < 6: # Это покрывает случаи < 1 и < 6
		x_label_step = 1
		
	if dc_range_size >= 0:
		for dc_offset in range(0, dc_range_size + 1, x_label_step):
			var dc_value_on_axis = MIN_DC + dc_offset; var relative_pos_x_axis = 0.5
			if dc_range_size > 0: relative_pos_x_axis = float(dc_offset) / float(dc_range_size)
			var x_label_in_graph_content = relative_pos_x_axis * current_graph_width
			var x_pos_label_rel_to_gc = GRAPH_MARGIN + x_label_in_graph_content
			var y_pos_label_rel_to_gc = graph_container.size.y - GRAPH_MARGIN + 20
			var text = str(dc_value_on_axis); var text_size = label_font.get_string_size(text, HORIZONTAL_ALIGNMENT_CENTER, -1, LABEL_FONT_SIZE)
			draw_string(label_font, graph_area_offset_from_self + Vector2(x_pos_label_rel_to_gc - text_size.x / 2.0, y_pos_label_rel_to_gc),
				text, HORIZONTAL_ALIGNMENT_LEFT, -1, LABEL_FONT_SIZE, TEXT_COLOR)
	var num_y_labels = 5
	for i in range(num_y_labels + 1):
		var prob_value_on_axis = float(i) / float(num_y_labels)
		var y_label_in_graph_content = prob_value_on_axis * current_graph_height
		var x_pos_label_rel_to_gc = GRAPH_MARGIN - 5
		var y_pos_label_rel_to_gc = graph_container.size.y - GRAPH_MARGIN - y_label_in_graph_content
		var text = str(snappedf(prob_value_on_axis * 100.0, 0)) + "%"
		var text_size = label_font.get_string_size(text, HORIZONTAL_ALIGNMENT_RIGHT, -1, LABEL_FONT_SIZE)
		draw_string(label_font, graph_area_offset_from_self + Vector2(x_pos_label_rel_to_gc - text_size.x, y_pos_label_rel_to_gc - text_size.y / 2.0 + (LABEL_FONT_SIZE / 4.0)),
			text, HORIZONTAL_ALIGNMENT_RIGHT, -1, LABEL_FONT_SIZE, TEXT_COLOR)
