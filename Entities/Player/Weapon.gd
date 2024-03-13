extends Node2D
class_name PlayerWeapon

@export var player: CharacterBody2D
@export var data: Gun : set = set_data
@export var inventory: Array[Gun]
var selection: int = 0
@export var ui: CanvasLayer

@export var cursor: Node2D
@onready var sprite = $Sprite2D
@onready var bullet = preload("res://Entities/Bullet.tscn")
@onready var muzzle_flash = preload("res://Assets/Effects/MuzzleFlash.tscn")
@onready var rpm_timer = $RPMTimer
@onready var muzzle = $Muzzle

@export var camera: Camera2DPlus
@export var sound_component: SoundComponent

@onready var tween = get_tree().create_tween()
var can_shoot = true

signal equiped_weapon(weapon:Gun)
signal picked_up_weapon(weapon:Gun)
signal has_scrolled(amount:int)
signal dropped_weapon(index:int)


# Called when the node enters the scene tree for the first time.
func _ready():
	if data:
		set_data(data)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not data: 
		sprite.texture = null
		#ui.texture_rect.texture = null
		#ui.label.text = ''
		return
		
	sprite.texture = data.texture
	#ui.texture_rect.texture = data.texture
	#ui.label.text = str(ammo) + "/" + str(data.ammo)
	
	var direction: Vector2
	if InputManager.input_type == InputManager.CONTROLLER:
		var joy_dir = Vector2(Input.get_joy_axis(0,JOY_AXIS_LEFT_X), Input.get_joy_axis(0,JOY_AXIS_LEFT_Y))
		print(joy_dir.length())
		if abs(joy_dir.length()) >= 0.2:
			direction = joy_dir.normalized()
		else: direction = direction
	elif InputManager.input_type == InputManager.KBM:
		direction = player.global_position.direction_to(cursor.get_cursor_position())
	direction = direction.normalized()
	var rot = atan2(direction.y, direction.x)
	
	self.rotation_degrees = rad_to_deg(rot)
	
	if self.rotation_degrees > 360 or self.rotation_degrees < -360:
		self.rotation_degrees = 0
	
	if abs(self.rotation_degrees) > 90 and abs(self.rotation_degrees) < 270:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
	
	if Input.is_action_pressed("shoot") and rpm_timer.time_left == 0 and can_shoot:
		shoot()
	
	if Input.is_action_just_pressed("scroll_up"):
		scroll(1)
	
	if Input.is_action_just_pressed("scroll_down"):
		scroll(-1)
		
	if Input.is_action_just_released("shoot"):
		can_shoot = true


func shoot():
	if data.rpm == 0: return
	
	var direction: Vector2
	if InputManager.input_type == InputManager.CONTROLLER:
		var joy_dir = Vector2(Input.get_joy_axis(0,JOY_AXIS_LEFT_X), Input.get_joy_axis(0,JOY_AXIS_LEFT_Y))
		print(joy_dir.length())
		if abs(joy_dir.length()) >= 0.2:
			direction = joy_dir.normalized()
	elif InputManager.input_type == InputManager.KBM:
		direction = cursor.get_cursor_position() - self.global_position
	direction = -direction.normalized()
	
	camera.set_shake(data.shake_strength)
	
	if data.throwable and data.ammo <= 0:
		if Input.is_action_just_pressed("shoot"):
			can_shoot = false
			if data.ammo == 0: throw(direction.normalized())
		return
	
	rpm_timer.stop()
	rpm_timer.start(60/data.rpm)
	
	for i in range(data.bullets):
		var new_bullet = bullet.instantiate()
		new_bullet.top_level = true
		new_bullet.life_time = data.life_time
		new_bullet.global_position = muzzle.global_position
		new_bullet.velocity += self.get_parent().velocity
		new_bullet.direction = spread_vector(direction, data.spread)
		muzzle.add_child(new_bullet)
	
	var new_flash = muzzle_flash.instantiate()
	new_flash.position.x += 10
	self.add_child(new_flash)

	direction *= 75
	match data.recoil_type:
		"Set":
			player.velocity = Vector2(direction.x*data.recoil*0.75, direction.y*data.recoil)
		"Add":
			player.velocity += Vector2(direction.x*data.recoil*0.75, direction.y*data.recoil)
		"Multi":
			player.velocity *= Vector2(direction.x*data.recoil*0.75, direction.y*data.recoil)
	player.velocity.x = clamp(player.velocity.x, -data.velocity_cap.x, data.velocity_cap.x)
	player.velocity.y = clamp(player.velocity.y, -data.velocity_cap.y, data.velocity_cap.y)
	#print(player.velocity)
	if player.is_on_wall():
		player.velocity.x += player.get_wall_normal().x
	
	data.ammo -= 1
	#if not data.throwable and data.ammo <=0: set_data()


func throw(direction):
	print('thrown')
	var new_bullet = bullet.instantiate()
	new_bullet.top_level = true
	new_bullet.life_time = data.life_time
	new_bullet.global_position = muzzle.global_position
	new_bullet.velocity += self.get_parent().velocity
	new_bullet.direction = spread_vector(direction, data.spread)
	new_bullet.throw_data = data
	muzzle.add_child(new_bullet)
	
	set_data()
	scroll(0)


func spread_vector(vector: Vector2, spread: float):
	var angle_rad = deg_to_rad(randf_range(-spread, spread)*20)
	var new_vector = Vector2(
		vector.x * cos(angle_rad) - vector.y * sin(angle_rad),
		vector.x * sin(angle_rad) + vector.y * cos(angle_rad)
	)
	return new_vector.normalized()


func set_data(new_data = null):
	data = new_data
	sound_component.play("Equip")
	
	if new_data:
		if sprite:
			sprite.texture = new_data.texture
		#new_data.ammo = new_data.mag_size
		#ammo = 500
	else:
		if len(inventory) > 0:
			scroll(0)
		sprite.texture = null
		inventory.pop_at(selection)
		emit_signal("dropped_weapon",selection)
	
	emit_signal("equiped_weapon", new_data)


func pickup_data(new_data = null):
	can_shoot = true
	var dup_data = new_data.duplicate()
	dup_data.ammo = dup_data.mag_size
	inventory.append(dup_data)
	if not data:
		set_data(dup_data)
		selection = 0
	emit_signal("picked_up_weapon", dup_data)
	sound_component.play("Equip")


func scroll(amount:int = 0):
	rpm_timer.stop()
	selection -= amount
	if selection > len(inventory)-1:
		selection = 0
	elif selection < 0:
		selection = len(inventory)-1
	if len(inventory) > 0:
		set_data(inventory[selection])
	else:
		set_data()
	emit_signal("has_scrolled", selection)











