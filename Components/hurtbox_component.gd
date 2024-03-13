extends Area2D
class_name HurtboxComponent

@export var entity: CharacterBody2D
@export var health_component: HealthComponent
@export var animation_player: AnimationPlayer

var fling_strength: int = 10
var grabbed:bool = false : 
	set(value):
		grabbed = value
		monitorable = not value
		monitoring = not value
	get:
		return grabbed


func hit(damage: int = 0) -> void:
	if health_component:
		health_component.set_health(damage)


