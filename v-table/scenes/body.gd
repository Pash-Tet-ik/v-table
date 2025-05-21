extends HBoxContainer


func set_up(selected_dises, ids):
	for i in range(len(selected_dises)):
		var roulette = load("res://scenes/roulette.tscn").instantiate()
		roulette.name = "rulette_" + str(ids[i])
		roulette.set_up(selected_dises[i], 50, 2.2 + randf_range(-1, 1))
		add_child(roulette)
