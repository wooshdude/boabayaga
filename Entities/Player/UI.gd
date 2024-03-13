extends CanvasLayer

const WHITE_CIRCLE = preload("res://Assets/Sprites/white_circle.png")

# Primary Weapon Hud
@onready var primary_icon = $Control/VBoxContainer/Primary/TextureRect
@onready var primary_count = $Control/VBoxContainer/Primary/Label

# Secondary Weapon Hud
@onready var secondary_icon = $Control/VBoxContainer/Secondary/TextureRect
@onready var secondary_count = $Control/VBoxContainer/Secondary/Label

@onready var primary_weapon = $"../Weapon"
@onready var secondary_weapon = $"../Secondary Weapon"


func _process(_delta):
	# Primary Weapon
	if primary_weapon.data:
		primary_icon.texture = primary_weapon.data.texture
		if primary_weapon.data.ammo > 0:
			primary_count.text = "%s/%s" % [str(primary_weapon.data.ammo),str(primary_weapon.data.mag_size)]
		else:
			primary_count.text = "THROW IT!"
	else:
		primary_icon.texture = WHITE_CIRCLE
		primary_count.text = ''
	

