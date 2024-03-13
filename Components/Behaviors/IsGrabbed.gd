extends ConditionLeaf

func tick(actor, blackboard):
	if actor.hurtbox.grabbed:
		return SUCCESS
	return FAILURE
