extends PanelContainer


func set_up(spells : Dictionary, lvl : String, slots : int, mag_mod : int):
	if lvl == "0":
		$body/caption/name.text = "заговоры"
		$body/caption/counter.hide()
	else:
		$body/caption/name.text = "спелы " + lvl + " круга"
		$body/caption/counter.max_value = slots
		$body/caption/counter.value = slots
	for spell_name in spells.keys():
		var spell = load("res://scenes/character_list/skill_bloks/spell.tscn").instantiate()
		spell.set_up(
			spell_name,
			spells[spell_name]["cost"],
			lvl,
			mag_mod
		)
		$body/description.add_child(spell)

	$body/description.move_child($body/description/filler2, -1)
