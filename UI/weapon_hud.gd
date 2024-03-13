extends Control

@export var weapon: PlayerWeapon
@onready var weapon_ui = preload("res://UI/weapon_ui.tscn")
@onready var v_box_container: VBoxContainer = $VBoxContainer


func _ready() -> void:
	weapon.picked_up_weapon.connect(_picked_up_weapon)
	weapon.has_scrolled.connect(_has_scrolled)
	weapon.dropped_weapon.connect(_dropped_weapon)


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("scroll_up"):
		scroll(1)
	if Input.is_action_just_pressed("scroll_down"):
		scroll(-1)


func add_new_weapon(data:Gun):
	var new_ui = weapon_ui.instantiate()
	new_ui.data = data
	
	v_box_container.add_child(new_ui)


func scroll(amount):
	v_box_container.position.y = -amount * 18

func _picked_up_weapon(data):
	add_new_weapon(data)

func _has_scrolled(amount):
	print(amount)
	scroll(amount)

func _dropped_weapon(index:int):
	var weapon_ui = v_box_container.get_child(index)
	v_box_container.remove_child(weapon_ui)
