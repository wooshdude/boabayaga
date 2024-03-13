extends ActionLeaf


func tick(actor, blackboard):
	var direction = actor.global_position.direction_to(GameManager.get_player().global_position).x
	actor.velocity.x = direction * 10
	actor.sprite.flip_h = bool(not clamp(direction,0,1))
	actor.animation_player.play("RUN")
	return SUCCESS
