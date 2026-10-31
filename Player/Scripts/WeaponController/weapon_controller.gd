extends Node3D
class_name WeaponController

@onready var player : Player = get_parent()
@onready var weapon_state_machine : StateMachine = $WeaponStateMachine

#get hit pos
var cur_shoot_pos_offset: Vector3 = Vector3(1, 1, 0)
var shoot_pos: Vector3 
@export var cam_ray: RayCast3D 
@onready var shoot_ray: RayCast3D = $ShootRay
var cam_pos: Vector3 = Vector3.ZERO
var hit_pos: Vector3 = Vector3.ZERO # THE ONE TO USE

@export var weapons: Array[Weapon]
var weapon_index: int = 0

func _ready() -> void:
	weapon_state_machine.init()

func _process(delta: float) -> void:
	
	weapon_state_machine.process_frame(delta)
	
	DebugDraw3D.draw_square(shoot_pos, 0.1, Color.RED)
	DebugDraw3D.draw_line(shoot_pos, hit_pos, Color.BLUE)
	DebugDraw3D.draw_square(cam_pos, 0.1, Color.YELLOW)
	DebugDraw3D.draw_square(hit_pos, 0.2 ,Color.BLUE)
	
	shoot_pos = Vector3.UP + player.position
	get_hit_pos()
	
	weapon_state_machine.process_physics(delta)

func _physics_process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	weapon_state_machine.process_input(event)

func get_hit_pos() -> void:
	cam_ray.force_raycast_update()
	shoot_ray.force_raycast_update()
	shoot_ray.position = shoot_pos
	var shoot_ray_pos: Vector3 = (cam_pos - shoot_pos).normalized() * ((cam_pos - shoot_pos).length()+5)
	shoot_ray.target_position = shoot_ray_pos
	if cam_ray.is_colliding():
		cam_pos = cam_ray.get_collision_point()
	else: 
		cam_pos = shoot_pos + player.camera_dir*256
	
	if shoot_ray.is_colliding():
		hit_pos = shoot_ray.get_collision_point()
	else:
		hit_pos = cam_pos

func shoot() -> void:
	#DebugDraw3D.draw_line()
	pass
