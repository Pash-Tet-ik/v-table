extends HBoxContainer

var lvl : String
var mag_mod : int

func set_up(spell_name : String, cost : int, lvl : String, mag_mod : int) -> void:
	$name.text = spell_name
	if cost == 0:
		$cost.text = "➦"
	elif cost == -1:
		$cost.text = "➦/❱"
	elif cost != -2:
		for i in range(cost):
			$cost.text += "❱"
	self.lvl = lvl
	self.mag_mod = mag_mod

func _on_name_pressed() -> void:
	var spell_description = load("res://scenes/character_list/skill_bloks/spell_description.tscn").instantiate()
	spell_description.set_up(
		$name.text,
		lvl,
		mag_mod
	)
	G.user.get_node("ui/info_box").add_child(spell_description)
