extends Node
class_name MovementComponent

@export var entity: CharacterBody2D


func _physics_process(delta: float) -> void:
	entity.velocity.y += 20
	
	entity.move_and_slide()
