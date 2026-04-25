extends CharacterBody3D
class_name PlayerCharacter

## Basic 3D movement for a CharacterBody3D that uses a Sprite3D as the visual.
## Also applies a billboard-like effect so the sprite faces the active camera.

@export_category("Movement")
@export var move_speed: float = 6.0
@export var acceleration: float = 18.0
@export var deceleration: float = 22.0
@export var jump_velocity: float = 4.5
@export var use_camera_relative_movement: bool = true

@export_category("Input Actions")
@export var action_left: StringName = &"move_left"
@export var action_right: StringName = &"move_right"
@export var action_forward: StringName = &"move_forward"
@export var action_back: StringName = &"move_back"
@export var action_jump: StringName = &"jump"

@export_category("Visual")
@export var sprite_path: NodePath
@export var lock_billboard_to_yaw_only: bool = true
@export var sprite_yaw_offset_degrees: float = 180.0

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_apply_jump()
	_apply_movement(delta)
	move_and_slide()


func _process(_delta: float) -> void:
	_apply_sprite_billboard()


func _apply_gravity(delta: float) -> void:
	# Why: CharacterBody3D doesn't apply gravity automatically; we do it so the same
	# movement code works with any floor collision setup.
	if not is_on_floor():
		velocity.y -= _gravity * delta


func _apply_jump() -> void:
	# Why: Jump should be responsive and only trigger when grounded.
	if is_on_floor() and Input.is_action_just_pressed(action_jump):
		velocity.y = jump_velocity


func _apply_movement(delta: float) -> void:
	var input_2d := Input.get_vector(action_left, action_right, action_forward, action_back)

	var desired_dir := Vector3.ZERO
	if input_2d.length() > 0.0:
		desired_dir = _get_movement_basis() * Vector3(input_2d.x, 0.0, input_2d.y)
		desired_dir.y = 0.0
		desired_dir = desired_dir.normalized()

	var desired_velocity := desired_dir * move_speed

	# Why: Separate accel/decel gives tighter control and "game-feel" tuning.
	var rate := acceleration if desired_dir != Vector3.ZERO else deceleration
	velocity.x = move_toward(velocity.x, desired_velocity.x, rate * delta)
	velocity.z = move_toward(velocity.z, desired_velocity.z, rate * delta)


func _get_movement_basis() -> Basis:
	# Why: Camera-relative movement is typically more intuitive for 3D games,
	# but we fall back to world-relative if there's no active camera.
	if not use_camera_relative_movement:
		return Basis.IDENTITY

	var cam := get_viewport().get_camera_3d()
	if cam == null:
		return Basis.IDENTITY

	var forward := -cam.global_transform.basis.z
	forward.y = 0.0
	forward = forward.normalized()

	var right := cam.global_transform.basis.x
	right.y = 0.0
	right = right.normalized()

	# Columns are X (right), Y (up), Z (back). We want a yaw-only basis on XZ.
	return Basis(right, Vector3.UP, -forward)


func _apply_sprite_billboard() -> void:
	var sprite := get_node_or_null(sprite_path) as Node3D
	if sprite == null:
		return

	var cam := get_viewport().get_camera_3d()
	if cam == null:
		return

	# Why: We "look at" the camera so the Sprite3D always faces it.
	# Optionally yaw-only to avoid pitching/rolling with the camera.
	var target_pos := cam.global_transform.origin
	if lock_billboard_to_yaw_only:
		target_pos.y = sprite.global_transform.origin.y

	sprite.look_at(target_pos, Vector3.UP)

	if sprite_yaw_offset_degrees != 0.0:
		sprite.rotate_y(deg_to_rad(sprite_yaw_offset_degrees))

