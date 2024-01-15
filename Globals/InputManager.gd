extends Node

@export var input_type = KBM


enum {
	KBM,
	CONTROLLER
}


func _input(event):
	if(event is InputEventKey):
		input_type = KBM
	elif(event is InputEventJoypadButton):
		input_type = CONTROLLER
	elif(event is InputEventMouseButton):
		input_type = KBM
	
	#if Input.is_action_just_pressed("fullscreen"):
		#VideoManager.swap_fullscreen_mode()


