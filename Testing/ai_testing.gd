extends Node2D

@onready var player: CharacterBody2D = $Player


func _process(delta: float) -> void:
	player.global_position = get_global_mouse_position()
