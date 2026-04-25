extends CharacterBody3D
class_name BasicWASDMovement

@export_category("Movement")
@export var walk_speed: float = 6.0
@export var sprint_speed: float = 10.0

@export_category("Input Actions")
@export var action_left: StringName = &"move_left"
@export var action_right: StringName = &"move_right"
@export var action_forward: StringName = &"move_forward"
@export var action_back: StringName = &"move_back"
@export var action_sprint: StringName = &"sprint"

@export_category("Visual")
@export var sprite_path: NodePath
@export var flip_deadzone: float = 0.05

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity", 9.8)
var _last_move_x: float = 0.0


func _ready() -> void:
	# Why: `move_and_slide()` uses this vector to determine what "floor" means.
	up_direction = Vector3.UP


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_apply_wasd_movement_and_sprint()
	move_and_slide()
	_apply_sprite_flip()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * delta


func _apply_wasd_movement_and_sprint() -> void:
	# Why: Using explicit actions avoids relying on the built-in `ui_*` mappings,
	# which are often not bound to WASD by default.
	var input_2d := Input.get_vector(action_left, action_right, action_forward, action_back)
	var dir := Vector3(input_2d.x, 0.0, input_2d.y)

	var speed := walk_speed
	if Input.is_action_pressed(action_sprint):
		speed = sprint_speed

	velocity.x = dir.x * speed
	velocity.z = dir.z * speed

	if absf(dir.x) > flip_deadzone:
		_last_move_x = dir.x


func _apply_sprite_flip() -> void:
	var sprite := get_node_or_null(sprite_path) as Sprite3D
	if sprite == null:
		return

	# Why: Only flip when we have a meaningful left/right intent.
	if _last_move_x > flip_deadzone:
		sprite.flip_h = false
	elif _last_move_x < -flip_deadzone:
		sprite.flip_h = true
