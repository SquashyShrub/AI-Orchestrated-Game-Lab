extends CharacterBody3D
class_name BasicWASDMovement

@export var move_speed: float = 6.0

var _gravity: float = 2 #ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)


func _ready() -> void:
	# Why: `move_and_slide()` uses this vector to determine what "floor" means.
	up_direction = Vector3.UP


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_apply_wasd_movement()
	move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta


func _apply_wasd_movement() -> void:
	# Uses the standard "ui_*" actions. Make sure they're mapped to WASD in Input Map.
	# (By default they often include arrows; you can add W/A/S/D as additional bindings.)
	var input_2d := Input.get_vector(&"ui_left", &"ui_right", &"ui_up", &"ui_down")
	var dir := Vector3(input_2d.x, 0.0, input_2d.y)

	velocity.x = dir.x * move_speed
	velocity.z = dir.z * move_speed
