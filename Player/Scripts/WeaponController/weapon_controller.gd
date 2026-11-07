extends Node3D
class_name WeaponController

@onready var player : Player = get_parent()
@onready var weapon_state_machine : StateMachine = $WeaponStateMachine

#get hit pos
var cur_shoot_pos_offset: Vector3 = Vector3(1, 1, 0)
var shoot_ray_pos: Vector3 = Vector3.ZERO
var cam_ray_pos: Vector3 = Vector3.ZERO
var cam_ray_point: Vector3 = Vector3.ZERO

var hit_pos: Vector3 = Vector3.ZERO # THE ONE TO USE

@export var weapons: Array[Weapon]
var weapon_index: int = 0

func _ready() -> void:
	weapon_state_machine.init()

func _process(delta: float) -> void:
	cam_mouse_move(delta)
	#get_hit_pos()
	
	weapon_state_machine.process_frame(delta)
	
	DebugDraw3D.draw_square(shoot_ray_pos, 0.1, Color.RED)
	DebugDraw3D.draw_line(shoot_ray_pos, hit_pos, Color.BLUE)
	DebugDraw3D.draw_square(cam_ray_point, 0.3, Color.YELLOW)
	#DebugDraw3D.draw_line(cam_ray_pos, cam_ray_point, Color.YELLOW)
	DebugDraw3D.draw_square(hit_pos, 0.2 ,Color.BLUE)
	
	weapon_state_machine.process_physics(delta)

func _physics_process(delta: float) -> void:
	#get_hit_pos()
	pass

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			mouse_dir = InputHandler.get_mouse_camera_dir(event)
	
	weapon_state_machine.process_input(event)

# camera movement stuff
@onready var cam_twist := $camera_twist
@onready var cam_pitch := $camera_twist/camera_pitch
@onready var cam_pos := $camera_twist/camera_pitch/camera_pos
var mouse_dir: Vector2 = Vector2.ZERO
var camera_input_dir: Vector2 = Vector2.ZERO
#----
var controller_cam_smooth: float = 0.9
var controller_cam_scaler: float = 100

var camera_dir: Vector3 # the one to use
var camera_basis: Basis # the one to use

var hor_camera_dir: Vector3 
func cam_mouse_move(delta: float) -> void:	
	camera_input_dir = lerp(camera_input_dir, InputHandler.get_controller_camera_dir() * delta * controller_cam_scaler, controller_cam_smooth)
	
	#camera controls
	cam_twist.rotate_y(-camera_input_dir.x - mouse_dir.x)
	cam_pitch.rotate_x(-camera_input_dir.y - mouse_dir.y)
	
	camera_dir = -cam_pos.global_basis.z
	camera_basis = cam_pos.global_basis
	hor_camera_dir = Vector3.FORWARD.rotated(Vector3.UP, cam_twist.rotation.y)
	
	#pitch clamp values
	cam_pitch.rotation.x = clamp(cam_pitch.rotation.x, -PI/2, PI/2)
	mouse_dir = Vector2.ZERO
	
func get_hit_pos() -> void:
	cam_ray_pos = cam_pos.global_position
	shoot_ray_pos = Vector3.UP + player.position
	var cam_ray_end = cam_ray_pos - cam_pos.global_transform.basis.z * 256
	
	var space = get_world_3d().direct_space_state
	var cam_query = PhysicsRayQueryParameters3D.create(cam_ray_pos, cam_ray_end)
	var cam_col = space.intersect_ray(cam_query)
	
	if !cam_col:
		cam_ray_point = cam_ray_end
		hit_pos = cam_ray_point
		print("null point")
		return
	else: 
		cam_ray_point = cam_col.position
		print(cam_col.position)
		
		var shoot_ray_end : Vector3 = cam_ray_point
		var shoot_query = PhysicsRayQueryParameters3D.create(shoot_ray_pos, shoot_ray_end)
		var shoot_col = space.intersect_ray(shoot_query)
		
		if shoot_col:
			hit_pos = shoot_col.position
		else:
			hit_pos = cam_ray_point
		
		return

func shoot() -> void:
	get_hit_pos()
	pass
