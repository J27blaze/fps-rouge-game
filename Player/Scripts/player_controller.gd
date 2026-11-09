extends CharacterBody3D
class_name Player

#state machines
@onready var movement_state_machine: StateMachine = $MovementStateMachine
@onready var weapon_controller: WeaponController = $WeaponController

#camera
@onready var cam_twist := weapon_controller.cam_twist
@onready var cam_pitch := weapon_controller.cam_pitch
@onready var cam_pos := weapon_controller.cam_pos
var mouse_dir: Vector2

#movement
var input_dir: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO
var hor_velocity: Vector3 = Vector3.ZERO
var speed: float = 0.0
var target_speed: float = 0.0

#gun

#param
@export_category("Movement")
@export_group("Run")
@export_range(0, 30, 0.05) var run_speed: float = 5.
@export_range(0, 75, 0.05) var run_accel: float = 5.
@export_range(0, 75, 0.05) var run_deccel: float = 5.

@export_group("Jump")
@export_range(0, 30, 0.05) var jump_pulse: float = 5.
@export_range(0, 30, 0.05) var jump_gravity: float = 5.
@export var air_strafe_angle_speed: Curve # the main one
@export_range(0, 10, 0.001) var air_strafe_speed_mult: float = 0.3
@export var air_strafe_speed_scaler: Curve # the on ethat limits it
@export_range(0, 10, 0.01) var air_strafe_max_angle: float = 0.4
@export var air_strafe_max_angle_increaser: Curve


@export_category("Weapon Handler")

func _ready():
	movement_state_machine.init()
	
func _input(event: InputEvent) -> void:
	movement_state_machine.process_input(event)

func _process(delta: float) -> void:
	input_dir = InputHandler.get_input_dir()
	direction = (Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, cam_twist.rotation.y))
	DebugDraw3D.draw_line(position, position + direction*5, Color.PURPLE)
	DebugDraw3D.draw_line(position, position + hor_velocity, Color.YELLOW)
	
	movement_state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	movement_state_machine.process_physics(delta)
	if !is_on_floor(): velocity.y -= jump_gravity*delta
	move_and_slide()
	
	hor_velocity = Vector3(velocity.x, 0, velocity.z)
	speed = hor_velocity.length()

	DebugDraw2D.set_text("Speed", snapped(speed, 0.01))
	DebugDraw2D.set_text("Target_Speed", snapped(target_speed, 0.01))
	
	DebugDraw2D.set_text("FPS", snapped(Engine.get_frames_per_second(), 0.1))
	DebugDraw2D.set_text("PPS", snapped(Engine.get_physics_interpolation_fraction(), 0.00000001))
# --------------------------------------------------------------------------------------------------------------------------- #



#movement functions
func vel_move_toward(target_vector: Vector3, accel: float, delta: float) -> void:
	velocity.x = velocity.move_toward(target_vector, accel * delta).x
	velocity.z = velocity.move_toward(target_vector, accel * delta).z

func vel_air_strafe(vel: Vector3, dir: Vector3, delta: float) -> Vector3:
	vel.y = 0 # fail safe
	dir.y = 0
	
	var dot: float
	if dir != Vector3.ZERO:
		dot = vel.normalized().dot(dir.normalized())
	else:
		dot = 1
	
	var new_speed: float = vel.length() + (air_strafe_speed_mult * air_strafe_angle_speed.sample(dot) * air_strafe_speed_scaler.sample(speed) * delta)
	
	var angle_diff: float = rad_to_deg(vel.signed_angle_to(dir, Vector3.UP))
	var max_angle_change: float = air_strafe_max_angle*air_strafe_max_angle_increaser.sample(dot)
	var angle_change: float = deg_to_rad(clampf(angle_diff, -max_angle_change, max_angle_change))
	
	var new_vel: Vector3
	
	new_vel = vel.normalized().rotated(Vector3.UP, angle_change) * new_speed
	
	#print(angle_diff)
	
	return new_vel

#state change functions
func state_check_jump() -> bool:
	if InputHandler.is_action_buffered("jump") && is_on_floor():
		movement_state_machine.change_state("jump")
		InputHandler.clear_action_buffer("jump")
		return true
	return false

func state_check_land() -> bool:
	if is_on_floor():
		if direction != Vector3.ZERO:
			movement_state_machine.change_state("run")
		else:
			movement_state_machine.change_state("idle")
		return true
	return false
