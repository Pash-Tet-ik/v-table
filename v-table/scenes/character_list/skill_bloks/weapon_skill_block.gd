extends PanelContainer

func set_up(wpn_name : String, data : Dictionary):
	$body/caption/name.text = wpn_name
	$body/description/HBoxContainer/mod.text = data["mod"]
	$body/description/HBoxContainer/dmg.text = data["dmg"]

	if data["cost"] == 0:
		$body/caption/cost.text = "➦"
	elif data["cost"] == -1:
		$body/caption/cost.text = "➦/❱"
	elif data["cost"] != -2:
		for i in range(data["cost"]):
			$body/caption/cost.text += "❱"

	if "count" in data.keys():
		$body/caption/counter.show()
		$body/caption/counter.max_value = data["count"]
		$body/caption/counter.value = data["count"]
	if "description" in data.keys():
		$body/description/cont.show()
		$body/description/cont/text.text = data["description"]
