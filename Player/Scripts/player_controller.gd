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

func _ready():
	movement_state_machine.init()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			mouse_dir = InputHandler.get_mouse_camera_dir(event)
	camera_dir = lerp(camera_dir, InputHandler.get_controller_camera_dir(), cam_smooth)

func _process(delta: float) -> void:
	cam_twist.rotate_y(-camera_dir.x - mouse_dir.x)
	cam_pitch.rotate_x(-camera_dir.y - mouse_dir.y)
	#pitch clamp values
	cam_pitch.rotation.x = clamp(cam_pitch.rotation.x, -PI/2, PI/2)
	
	mouse_dir = Vector2.ZERO

func _physics_process(delta: float) -> void:
	#print(InputHandler.get_input_dir())
	pass
