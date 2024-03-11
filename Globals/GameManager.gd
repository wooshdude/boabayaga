extends Node

@onready var player: CharacterBody2D = get_tree().get_first_node_in_group("Player"): get = get_player

func get_player():
	return player
