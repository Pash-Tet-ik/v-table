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
var add_stats_template : Dictionary

func _ready() -> void:
	$VBoxContainer/main/TabContainer.set_tab_title(0, "статы")
	$VBoxContainer/main/TabContainer.set_tab_title(1, "скилы")
	$VBoxContainer/main/TabContainer.set_tab_title(2, "спелы")


func set_up(character : Dictionary):
	var mod = 0
	var add_mod = 0
	$VBoxContainer/header/PanelContainer/main_block/header/name.text = character["name"]
	$VBoxContainer/header/PanelContainer/main_block/main/hp_box/hp.max_value = character["max_hp"]
	$VBoxContainer/header/PanelContainer/main_block/main/hp_box/hp.value = character["max_hp"]
	G.data["hp"] = int(character["max_hp"])
	$VBoxContainer/header/PanelContainer/main_block/main/cd_box/cd.value = character["cd"]

	add_stats_template = all_stats_zero.duplicate()
	for add_stat in character["add_stats"].keys():
		add_stats_template[add_stat] += character["add_stats"][add_stat]

	$VBoxContainer/main/TabContainer/stats/v_box/str_block/body/main/var.text = "(" + str(int(character["main_stats"]["str"]))  + ")"
	mod = int(character["main_stats"]["str"] / 2) - 5
	$VBoxContainer/main/TabContainer/stats/v_box/str_block/body/main/mod.text = "+" + str(mod) if mod > 0 else str(mod)
	add_mod = mod + int(add_stats_template["athletics"])
	$VBoxContainer/main/TabContainer/stats/v_box/str_block/body/additional/athletics/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)

	$VBoxContainer/main/TabContainer/stats/v_box/dex_block/body/main/var.text = "(" + str(int(character["main_stats"]["dex"]))  + ")"
	mod = int(character["main_stats"]["dex"] / 2) - 5
	$VBoxContainer/main/TabContainer/stats/v_box/dex_block/body/main/mod.text = "+" + str(mod) if mod > 0 else str(mod)
	add_mod = mod + int(add_stats_template["acrobatics"])
	$VBoxContainer/main/TabContainer/stats/v_box/dex_block/body/additional/acrobatics/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["sleight_of_hand"])
	$VBoxContainer/main/TabContainer/stats/v_box/dex_block/body/additional/sleight_of_hand/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["stealth"])
	$VBoxContainer/main/TabContainer/stats/v_box/dex_block/body/additional/stealth/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)

	$VBoxContainer/main/TabContainer/stats/v_box/con_block/body/main/var.text = "(" + str(int(character["main_stats"]["con"]))  + ")"
	mod = int(character["main_stats"]["con"] / 2) - 5
	$VBoxContainer/main/TabContainer/stats/v_box/con_block/body/main/mod.text = "+" + str(mod) if mod > 0 else str(mod)

	$VBoxContainer/main/TabContainer/stats/v_box/int_block/body/main/var.text = "(" + str(int(character["main_stats"]["int"]))  + ")"
	mod = int(character["main_stats"]["int"] / 2) - 5
	$VBoxContainer/main/TabContainer/stats/v_box/int_block/body/main/mod.text = "+" + str(mod) if mod > 0 else str(mod)
	add_mod = mod + int(add_stats_template["investigation"])
	$VBoxContainer/main/TabContainer/stats/v_box/int_block/body/additional/investigation/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["history"])
	$VBoxContainer/main/TabContainer/stats/v_box/int_block/body/additional/history/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["arcana"])
	$VBoxContainer/main/TabContainer/stats/v_box/int_block/body/additional/arcana/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["nature"])
	$VBoxContainer/main/TabContainer/stats/v_box/int_block/body/additional/nature/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["religion"])
	$VBoxContainer/main/TabContainer/stats/v_box/int_block/body/additional/religion/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)

	$VBoxContainer/main/TabContainer/stats/v_box/wis_block/body/main/var.text = "(" + str(int(character["main_stats"]["wis"]))  + ")"
	mod = int(character["main_stats"]["wis"] / 2) - 5
	$VBoxContainer/main/TabContainer/stats/v_box/wis_block/body/main/mod.text = "+" + str(mod) if mod > 0 else str(mod)
	add_mod = mod + int(add_stats_template["perception"])
	$VBoxContainer/main/TabContainer/stats/v_box/wis_block/body/additional/perception/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["survival"])
	$VBoxContainer/main/TabContainer/stats/v_box/wis_block/body/additional/survival/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["medicine"])
	$VBoxContainer/main/TabContainer/stats/v_box/wis_block/body/additional/medicine/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["insight"])
	$VBoxContainer/main/TabContainer/stats/v_box/wis_block/body/additional/insight/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["animal_handling"])
	$VBoxContainer/main/TabContainer/stats/v_box/wis_block/body/additional/animal_handling/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)

	$VBoxContainer/main/TabContainer/stats/v_box/cha_block/body/main/var.text = "(" + str(int(character["main_stats"]["cha"]))  + ")"
	mod = int((character["main_stats"]["cha"] - 10) / 2) 
	$VBoxContainer/main/TabContainer/stats/v_box/cha_block/body/main/mod.text = "+" + str(mod) if mod > 0 else str(mod)
	add_mod = mod + int(add_stats_template["performance"])
	$VBoxContainer/main/TabContainer/stats/v_box/cha_block/body/additional/performance/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["intimidation"])
	$VBoxContainer/main/TabContainer/stats/v_box/cha_block/body/additional/intimidation/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["deception"])
	$VBoxContainer/main/TabContainer/stats/v_box/cha_block/body/additional/deception/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)
	add_mod = mod + int(add_stats_template["persuasion"])
	$VBoxContainer/main/TabContainer/stats/v_box/cha_block/body/additional/persuasion/mod.text = ("+" if add_mod > 0 else "") + str(add_mod)

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
