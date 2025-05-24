extends PanelContainer


var all_stats_zero = {
	"athletics" : 0,
	"acrobatics" : 0,
	"sleight_of_hand" : 0,
	"stealth" : 0,
	"investigation" : 0,
	"history" : 0,
	"arcana" : 0,
	"nature" : 0,
	"religion" : 0,
	"perception" : 0,
	"survival" : 0,
	"medicine" : 0,
	"insight" : 0,
	"animal_handling" : 0,
	"performance" : 0,
	"intimidation" : 0,
	"deception" : 0,
	"persuasion" : 0
}
var stats = {
	"str" : ["athletics"],
	"dex" : ["acrobatics", "sleight_of_hand", "stealth"],
	"con" : [],
	"int" : ["investigation", "history", "arcana", "nature", "religion"],
	"wis" : ["perception", "survival", "medicine", "insight", "animal_handling"],
	"cha" : ["performance","intimidation","deception","persuasion"]
}
var add_stats_template : Dictionary


func _ready() -> void: 
	var titles = ["статы", "скилы", "спелы"]
	for i in 3:
		$VBoxContainer/main/TabContainer.set_tab_title(i, titles[i])


func set_up(character : Dictionary):
	var mod = 0
	var add_mod = 0
	$VBoxContainer/header/PanelContainer/main_block/header/name.text = character["name"]
	$VBoxContainer/header/PanelContainer/main_block/main/hp_box/hp.max_value = character["max_hp"]
	$VBoxContainer/header/PanelContainer/main_block/main/hp_box/hp.value = character["max_hp"]
	$VBoxContainer/header/PanelContainer/main_block/main/cd_box/cd.value = character["cd"]

	add_stats_template = all_stats_zero.duplicate()
	for add_stat in character["add_stats"].keys():
		add_stats_template[add_stat] += character["add_stats"][add_stat]

	var path
	for main_stat in stats:
		path = "VBoxContainer/main/TabContainer/stats/v_box/" + main_stat + "_block/body/"
		mod = int(character["main_stats"][main_stat] / 2) - 5
		get_node(path + "main/var").text = "(" + str(int(character["main_stats"][main_stat]))  + ")"
		get_node(path + "main/mod").text = "+" + str(mod) if mod > 0 else str(mod)
		for additional_stat in stats[main_stat]:
			add_mod = mod + int(add_stats_template[additional_stat])
			get_node(path + "additional/" + additional_stat + "/mod").text = ("+" if add_mod > 0 else "") + str(add_mod)

	for child in $VBoxContainer/main/TabContainer/moves/v_box.get_children():
		child.queue_free()
	$VBoxContainer/main/TabContainer/moves/v_box.add_child(Control.new())
	for weapon in character["skills"]["weapons"].keys():
		var skill = load("res://scenes/character_list/skill_bloks/weapon_skill_block.tscn").instantiate()
		skill.set_up(
			weapon,
			character["skills"]["weapons"][weapon]
		)
		$VBoxContainer/main/TabContainer/moves/v_box.add_child(skill)
	$VBoxContainer/main/TabContainer/moves/v_box.add_child(Control.new())

	for text in character["skills"]["texts"].keys():
		var skill = load("res://scenes/character_list/skill_bloks/text_skill_block.tscn").instantiate()
		skill.set_up(
			text,
			character["skills"]["texts"][text]["description"],
			character["skills"]["texts"][text]["cost"] if "cost" in character["skills"]["texts"][text].keys() else -2,
			character["skills"]["texts"][text]["count"] if "count" in character["skills"]["texts"][text].keys() else 0,
		)
		$VBoxContainer/main/TabContainer/moves/v_box.add_child(skill)

	$VBoxContainer/main/TabContainer/moves/v_box.add_child(Control.new())

	for child in $VBoxContainer/main/TabContainer/spells/v_box.get_children():
		child.queue_free()
	for spells_lvl in character["skills"]["magic"].keys():
		var skill = load("res://scenes/character_list/skill_bloks/spells_skill_block.tscn").instantiate()
		skill.set_up(
			character["skills"]["magic"][spells_lvl]["spells"],
			spells_lvl,
			character["skills"]["magic"][spells_lvl]["slots"],
			int((character["main_stats"][character["mag_stat"]] - 10) / 2)
		)
		$VBoxContainer/main/TabContainer/spells/v_box.add_child(skill)


func _on_resized() -> void:
	var w_size_y = get_window().size.y
	if w_size_y >= 1080:
		theme.set_font_size("font_size", "Label", 24)
	else:
		theme.set_font_size("font_size", "Label", 22)
