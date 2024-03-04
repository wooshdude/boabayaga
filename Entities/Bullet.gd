extends CharacterBody2D

@onready var sprite_2d = $Sprite2D
@onready var muzzle_flash = preload("res://Assets/Effects/hit_particles.tscn")
@onready var snake_component = $SnakeComponent

@export var throw_data: Gun

var direction = Vector2.LEFT
var life_time: float = 1
var hit_something = false

@onready var tween = get_tree().create_tween()


func _ready():
	#print(direction)
	velocity = -direction * 400
	$SoundComponent.play("Gunshot", true, -5)
	
	if throw_data:
		sprite_2d.show()
		sprite_2d.texture = throw_data.texture
		
		tween.tween_property(sprite_2d, "rotation_degrees", 360, 0.5)
		tween.set_loops()
	
	if life_time > 0:
		await get_tree().create_timer(life_time).timeout
		self.queue_free()
	

func _physics_process(_delta):
	move_and_slide()
	
	if is_on_wall() and not hit_something:
		hit_something = true
		tween.stop()
		velocity = Vector2.ZERO
		if not throw_data.can_be_picked_up:
			$Area2D.monitorable = false
			$Area2D.monitoring = false
		var new_flash = muzzle_flash.instantiate()
		new_flash.look_at(get_wall_normal())
		new_flash.emitting = true
		self.add_child(new_flash)
		snake_component.queue_free()
		
		if throw_data:
			if throw_data.break_on_contact:
				sprite_2d.hide()
				await get_tree().create_timer(1).timeout
				queue_free()
			else:
				var rot = rad_to_deg(get_angle_to(direction.normalized()))
				print(rot)
				sprite_2d.look_at(global_position + get_wall_normal())
				sprite_2d.rotation_degrees += 45

func _on_area_2d_area_entered(area):
	if area.is_in_group("Enemy") and not self.is_in_group("Enemy"):
		area.hit(-1)
		self.queue_free()
	elif area.is_in_group("Player") and self.is_in_group("Enemy"):
		area.hit(-1)


func _on_area_2d_body_exited(body: Node2D) -> void:
	print(body)
	if not throw_data: return
	if body.is_in_group("Player") and hit_something:
		print('penis')
		body.get_node("PrimaryWeapon").data = throw_data
		queue_free()
