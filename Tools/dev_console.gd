extends Control

@export var weapons: Array[Gun]
@export var player_weapon: Node

@onready var weapon_equip: MenuButton = $Panel/VBoxContainer/HBoxContainer/WeaponEquip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for w in weapons:
		weapon_equip.get_popup().add_icon_item(w.texture,w.name)
	
	weapon_equip.get_popup().id_pressed.connect(_on_popup_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_popup_pressed(id):
	print(id)
	if player_weapon: player_weapon.set_data(weapons[id])
