@tool
extends Node2D

@export_range(1,100,0.1) var radius: float = 25

@onready var cursor:Sprite2D = $Sprite
@export_range(0, 10, 0.1) var sensitivity: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	
	if Engine.is_editor_hint(): return
	
	# Get mouse movement
	var mouse_movement = Input.get_last_mouse_velocity()

	# Update cursor offset based on mouse movement
	cursor.position += mouse_movement * delta * sensitivity  # Adjust the factor for sensitivity
	
	cursor.position = cursor.position.limit_length(radius)


func _draw() -> void:
	draw_arc(Vector2.ZERO, self.radius, 0, 2*PI, 45, Color.WHITE,1,false)
