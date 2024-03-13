extends ActionLeaf


func tick(actor, blackboard):
	actor.animation_player.play("GRABBED")
