extends PanelContainer

func set_up(skill_name : String, description : String, cost : int, count : int):
	$body/caption/name.text = skill_name
	$body/description/label.text = description
	if cost == 0:
		$body/caption/cost.text = "➦"
	elif cost == -1:
		$body/caption/cost.text = "➦/❱"
	elif cost != -2:
		for i in range(cost):
			$body/caption/cost.text += "❱"
	if count:
		$body/caption/counter.show()
		$body/caption/counter.max_value = count
		$body/caption/counter.value = count
