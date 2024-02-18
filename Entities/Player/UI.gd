extends CanvasLayer

const WHITE_CIRCLE = preload("res://Assets/Sprites/white_circle.png")

# Primary Weapon Hud
@onready var primary_icon = $Control/VBoxContainer/Primary/TextureRect
@onready var primary_count = $Control/VBoxContainer/Primary/Label

# Secondary Weapon Hud
@onready var secondary_icon = $Control/VBoxContainer/Secondary/TextureRect
@onready var secondary_count = $Control/VBoxContainer/Secondary/Label

@onready var primary_weapon = $"../PrimaryWeapon"
@onready var secondary_weapon = $"../Secondary Weapon"


func _process(_delta):
	# Primary Weapon
	if primary_weapon.data:
		primary_icon.texture = primary_weapon.data.texture
		primary_count.text = "%s/%s" % [str(primary_weapon.ammo),str(primary_weapon.data.ammo)]
	else:
		primary_icon.texture = WHITE_CIRCLE
		primary_count.text = ''
	
	if secondary_weapon.data:
		secondary_icon.texture = secondary_weapon.data.texture
		secondary_count.text = "%s/%s" % [str(secondary_weapon.ammo),str(secondary_weapon.data.ammo)]
	else:
		secondary_icon.texture = WHITE_CIRCLE
		secondary_count.text = ''
