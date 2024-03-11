extends SequenceComposite

@export var entity: CharacterBody2D
@onready var player = GameManager.get_player()

@onready var check_for_player: Node = $InverterDecorator/CheckForPlayer
@onready var wander_action = $WanderAction



func _ready() -> void:
	check_for_player.entity = entity
	check_for_player.player = player
	wander_action.entity = entity
	wander_action.player = player



func distance_to_player():
	return entity.global_position.distance_to(player.global_position)
