extends Resource
class_name Gun

@export_category("Gun")
@export var texture: Texture2D
@export_range(0,1000,1) var rpm: float
@export_range(0,10,1) var bullets: int
@export_range(0,1,0.1) var spread: float
@export_range(0,1,0.1) var life_time: float
@export var ammo: int

@export_group("Recoil")
@export_range(0,10,0.1) var recoil: float
@export_enum("Set", "Add", "Multi") var recoil_type: String = "Set"
@export var velocity_cap := Vector2(200,200)

@export_group("Behavior")
@export var throwable: bool
@export var break_on_contact: bool

@export_group("Camera")
@export_range(0,10,0.1) var follow_strength: float
@export_range(0,10,0.1) var shake_strength: float

@export_group("Enemy Values")
@export var burst: int
