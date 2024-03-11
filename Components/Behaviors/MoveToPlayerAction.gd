extends ActionLeaf


func tick(actor, blackboard):
	actor.velocity.x = actor.global_position.direction_to(GameManager.get_player().global_position).x * 10
	return SUCCESS
