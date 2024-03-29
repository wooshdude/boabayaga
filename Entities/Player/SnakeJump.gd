extends Node
class_name SnakeMovement

@export var controller: bool
@export var player: CharacterBody2D
@export var cursor: Node2D
@export var area: Area2D
@export_range(1,10, 0.1) var strength: float  # Jump strength
@export var health_component: HealthComponent
@onready var weapon = $"../Weapon"
@onready var buffer_jump_timer = $BufferJumpTimer
@export var sound_component: SoundComponent


var grabbing:bool = false
var grab_target: HurtboxComponent
var wall_jumps:int = 1
var buffer_jump:bool = false
var just_landed = false

const WALK_SPEED:int = 15
const SPEED_CAP:float = 400


func _ready():
	if not area: area = Area2D.new()
	area.connect("area_entered", on_area_entered)


func _physics_process(_delta):
	#print(player.velocity)
	
	if not player.is_on_floor_only() and not player.is_on_wall():
		player.velocity.y += 20  # Gravity
	elif player.is_on_wall_only():
		player.velocity.y = lerp(player.velocity.y, 30.0, 0.1)  # Slowly slide down wall (does work)
		player.velocity.x = -player.get_wall_normal().x
	else:
		player.velocity.x = lerp(player.velocity.x, 0.0, 0.2)  # Floor friction
		
	#if is_just_landed():
	#	sound_component.play("Land")
		
	if not health_component.is_alive(): return
	
	if Input.is_action_just_pressed("jump") and (player.is_on_floor() or grabbing or (player.is_on_wall() and wall_jumps > 0)):
		jump()
			
	elif Input.is_action_just_released("jump") and not player.is_on_floor() and player.velocity.y < 0:
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(player, "velocity", Vector2(player.velocity.x, 0.0), 0.05).set_trans(Tween.TRANS_SINE)
	
	elif Input.is_action_just_pressed("jump") and not player.is_on_floor() and not player.is_on_wall():
		buffer_jump = true
		buffer_jump_timer.start()
	
	if (player.is_on_floor() or player.is_on_wall()) and buffer_jump and not buffer_jump_timer.time_left== 0:
		buffer_jump = false
		jump()
	
	player.velocity = player.velocity.limit_length(SPEED_CAP)
	
	player.move_and_slide()
	
	if grabbing and grab_target:
		grab_target.grabbed = true
		player.global_position = grab_target.global_position


func on_area_entered(area):
	if area.is_in_group("Enemy"):
		print('Enemy')
		grabbing = true
		grab_target = area
	if area.is_in_group("Weapon"):
		print('weapon')


func jump():
	var direction: Vector2
	if InputManager.input_type == InputManager.CONTROLLER:
		direction = Vector2(Input.get_joy_axis(0,JOY_AXIS_LEFT_X), Input.get_joy_axis(0,JOY_AXIS_LEFT_Y)).normalized()
		print(direction)
		#direction = offsetDirectionUpwards(direction, 0.01).normalized()
	elif InputManager.input_type == InputManager.KBM:
		direction = player.global_position.direction_to(cursor.get_cursor_position()).normalized()
		direction = offsetDirectionUpwards(direction).normalized()
	
	print(direction)
	
	if player.is_on_wall():
		sound_component.play("Jump")
	else:
		sound_component.play('Land')
	
	if not player.is_on_wall_only():
		player.velocity = direction * strength * 60  # Launches snake towards direction of cursor
	elif player.is_on_wall_only():
		var dir = player.get_wall_normal().normalized()
		if direction.y > 0:
			dir.y = 0
		elif direction.y < 0:
			dir.y = 1
		
		direction.y = clamp(direction.y, -0.5, 0)
		
		player.velocity = Vector2(0.5 * dir.x,direction.y*1.5) * strength * 70  # Launches snake towards direction of cursor
	
	if grabbing and grab_target:
		grab_target.hit(-1)
		#Engine.physics_ticks_per_second = 0
		#await get_tree().create_timer(0.1).timeout
		#Engine.physics_ticks_per_second = 0
		grabbing = false
		grab_target = null


func is_just_landed():
	#print(just_landed)
	if player.is_on_floor() and not just_landed:
		just_landed = true
		return true
	elif not player.is_on_floor():
		just_landed = false
		return false


func offsetDirectionUpwards(original_vector: Vector2, offset_amount: float = 0.25) -> Vector2:
	# Offset the Y component of the original vector
	var offset_vector = original_vector + Vector2(0, -offset_amount)
	
	return offset_vector.normalized()  # Normalize the vector to maintain its length



