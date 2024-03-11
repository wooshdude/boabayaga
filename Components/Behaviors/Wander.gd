extends ActionLeaf

@onready var timer := Timer.new()

func _ready() -> void:
	timer.one_shot = true
	add_child(timer)


func tick(actor, blackboard):
	if timer.is_stopped():
		wander(actor)


func wander(actor):
	# get random direction
	var direction = randi_range(-1,1)
	# set random time
	var duration = randf_range(0,3)
	
	actor.velocity.x = direction * 10
	timer.start(duration)
