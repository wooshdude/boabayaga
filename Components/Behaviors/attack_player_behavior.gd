extends SequenceComposite

func distance_to_player():
	return entity.global_position.distance_to(player.global_position)
