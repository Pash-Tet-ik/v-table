extends PanelContainer

func set_up(spell_name : String, lvl : String, mag_mod : int):
	var load_file = FileAccess.open("res://db/spellbook/spells_" + lvl + ".json" , FileAccess.READ)
	var spells = JSON.parse_string(load_file.get_as_text())
	load_file.close()

	if spell_name in spells.keys():
		$body/caption/name.text = spell_name
		$body/description/text.text = spells[spell_name]["description"].replace("MAG_MOD", str(mag_mod))
		if "distance" in spells[spell_name]:
			$body/description/distance.text += "дистанция : " + str(spells[spell_name]["distance"])
			$body/description/distance.show()


func _on_button_pressed() -> void:
	queue_free()
