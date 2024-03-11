extends ConditionLeaf

@export var distance:float


func tick(actor, blackboard):
	if actor.global_position.distance_to(GameManager.get_player().global_position) <= distance:
		return SUCCESS
	else:
		return FAILURE
