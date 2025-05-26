extends "res://scenes/users_and_moduls/user.gd"

var character : Dictionary


func set_up_charachter(new_character : Dictionary):
	character = new_character
	$ui/CharacterBlock/main/character_list.set_up(character)
	$ui/CharacterBlock.show()
	$ui/CharacterBlock.set_pressed()
	$ui/CharacterBlock/main/character_list.show()
	$ui/add_roulette.show()
