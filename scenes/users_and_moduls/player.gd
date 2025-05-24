extends "res://scenes/users_and_moduls/user.gd"

var character : Dictionary

func _ready() -> void:
	super._ready()
	$ui/add_roulette.table = table
	$ui/add_roulette.user = self
	$ui/CharacterSelection.user = self


func set_up_charachter(character : Dictionary):
	self.character = character
	$ui/CharacterBlock/main/character_list.set_up(character)
	$ui/CharacterBlock.show()
	$ui/CharacterBlock.set_pressed()
	$ui/CharacterBlock/main/character_list.show()
	$ui/add_roulette.show()
