extends Node

@export var input_type = KBM


enum {
	KBM,
	CONTROLLER
}

var mouse_modes = [Input.MOUSE_MODE_VISIBLE, Input.MOUSE_MODE_CAPTURED]
var mouse_toggled = false

func _ready() -> void:
	Input.mouse_mode = self.mouse_modes[int(self.mouse_toggled)]


func _input(event):
	if(event is InputEventKey):
		input_type = KBM
	elif(event is InputEventJoypadButton):
		input_type = CONTROLLER
	elif(event is InputEventMouseButton):
		input_type = KBM
	
	#if Input.is_action_just_pressed("fullscreen"):
		#VideoManager.swap_fullscreen_mode()
	
	if Input.is_action_just_pressed('ui_cancel'):
		print(mouse_toggled)
		mouse_toggled = not mouse_toggled
		Input.mouse_mode = self.mouse_modes[int(self.mouse_toggled)]


func hide_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func show_mouse():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
