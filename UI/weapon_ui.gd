extends Control

@export var data: Gun
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func _process(delta: float) -> void:
	texture_rect.texture = data.texture
	if data.ammo > 0:
		label.text = "%s/%s" % [data.ammo,data.mag_size]
	else:
		label.text = "THROW IT!"
		
