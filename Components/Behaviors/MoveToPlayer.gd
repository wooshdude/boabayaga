extends ActionLeaf

@onready var timer := Timer.new()

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)


func tick(actor, blackboard):
	if actor.global_position.distance_to(GameManager.get_player().global_position) <= 10 and timer.is_stopped():
		attack(actor)
		return RUNNING
	else:
		return FAILURE


func attack(actor):
	actor.animation_player.play("ATTACK")
	print("attacking %s" % actor.name)
	actor.velocity.x = 0
	timer.start(1)
