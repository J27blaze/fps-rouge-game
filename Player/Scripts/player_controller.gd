extends CharacterBody3D
class_name Player

#state machines
@onready var movement_state_machine: StateMachine = $MovementStateMachine

#camera
@onready var cam_twist := $camera_twist
@onready var cam_pitch := $camera_twist/camera_pitch
@onready var cam_pos := $camera_twist/camera_pitch/camera_pos
var mouse_dir: Vector2
var camera_dir: Vector2
var cam_smooth: float = 0.5

#movement
var input_dir: Vector2 = Vector2.ZERO
var direction: Vector3 = Vector3.ZERO
var hor_velocity: Vector3 = Vector3.ZERO
var speed: float = 0.0

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

func _ready():
	movement_state_machine.init()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			mouse_dir = InputHandler.get_mouse_camera_dir(event)
	camera_dir = lerp(camera_dir, InputHandler.get_controller_camera_dir(), cam_smooth)

func _process(delta: float) -> void:
	#camera controls
	cam_twist.rotate_y(-camera_dir.x - mouse_dir.x)
	cam_pitch.rotate_x(-camera_dir.y - mouse_dir.y)
	#pitch clamp values
	cam_pitch.rotation.x = clamp(cam_pitch.rotation.x, -PI/2, PI/2)
	mouse_dir = Vector2.ZERO
	
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

# --------------------------------------------------------------------------------------------------------------------------- #



#movement functions
func vel_move_toward(target_vector: Vector3, accel: float, delta: float):
	velocity.x = velocity.move_toward(target_vector, accel * delta).x
	velocity.z = velocity.move_toward(target_vector, accel * delta).z

#state change functions
func state_check_jump() -> bool:
	if InputHandler.is_action_buffered("jump") && is_on_floor():
		movement_state_machine.change_state("jump")
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
