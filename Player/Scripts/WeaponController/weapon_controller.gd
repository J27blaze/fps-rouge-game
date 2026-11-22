extends Node3D
class_name WeaponController

@export var player : Player
@export var player_ui : PlayerUI
@onready var weapon_state_machine : StateMachine = $WeaponStateMachine

# camera movement stuff
@onready var cam_twist := $camera_twist
@onready var cam_pitch := $camera_twist/camera_pitch
@onready var cam_pos := $camera_twist/camera_pitch/camera_pos
var cam_phy_inter: Physics_Interolate = Physics_Interolate.new()
@onready var gun := $ModelTwist/gun
@onready var tip := $ModelTwist/gun/tip

var mouse_dir: Vector2 = Vector2.ZERO
var camera_input_dir: Vector2 = Vector2.ZERO

var controller_cam_smooth: float = 0.9
var controller_cam_scaler: float = 100

var camera_dir: Vector3 # the one to use
var camera_basis: Basis # the one to use

var hor_camera_dir: Vector3 

#get hit pos
var cur_shoot_pos_offset: Vector3 = Vector3(1, 1, 0)
var shoot_ray_pos: Vector3 = Vector3.ZERO
var cam_ray_pos: Vector3 = Vector3.ZERO
var cam_ray_point: Vector3 = Vector3.ZERO

#important hit collider stuff
var hit_pos: Vector3 = Vector3.ZERO # THE ONE TO USE
var hit_dir: Vector3 = Vector3.ZERO # THE ONE TO USE

var hit_object: Node = null

var weapons: Array[Weapon]
var weapon_index: int = 0
var cur_weapon: Weapon

func _ready() -> void:
	
	weapons.resize(2)
	weapons[0] = Weapon.new() #hard code set the weapons
	weapons[1] = Weapon.new(preload("uid://w1lfj3wujfvx")) #hard code set the weapons
	cur_weapon = weapons[0]
	
	weapon_state_machine.init()
	cam_phy_inter.init(player.position)
	
	#reset weapon w hard code
	reload()
	change_weapon(1)
	cur_weapon.load_resource()
	cur_weapon.add_modifer()
	reload()
	change_weapon(-1)
	cur_weapon.load_resource()
	
	#weapons[weapon_index].model_scene
	
func _process(delta: float) -> void:
	cam_mouse_move(delta)
	weapon_state_machine.process_frame(delta)
	
	cam_twist.position = cam_phy_inter.inter_pos
	
	DebugDraw3D.draw_square(shoot_ray_pos, 0.1, Color.RED)
	DebugDraw3D.draw_line(shoot_ray_pos, hit_pos, Color.BLUE)
	DebugDraw3D.draw_square(hit_pos, 0.3 ,Color.YELLOW)
	DebugDraw3D.draw_square(cam_ray_point, 0.2, Color.BLUE)
	#DebugDraw3D.draw_line(cam_ray_pos, cam_ray_point, Color.YELLOW)
	#print(cam_phy_inter.cur_pos)

func _physics_process(delta: float) -> void:
	cam_phy_inter.process_phy(player.position)
	
	weapon_state_machine.process_physics(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			mouse_dir = InputHandler.get_mouse_camera_dir(event)
	
	weapon_state_machine.process_input(event)

var current_recoil: Vector2 = Vector2.ZERO
var target_recoil: Vector2 = Vector2.ZERO
var spray_index: float = 0

func cam_mouse_move(delta: float) -> void:
	cam_phy_inter.process_frame()
	
	camera_input_dir = lerp(camera_input_dir, InputHandler.get_controller_camera_dir() * delta * controller_cam_scaler, controller_cam_smooth)
	
	#camera controls
	cam_twist.rotate_y(-camera_input_dir.x - mouse_dir.x)
	cam_pitch.rotate_x(-camera_input_dir.y - mouse_dir.y)
	
	camera_dir = -cam_pos.global_basis.z
	camera_basis = cam_pos.global_basis
	hor_camera_dir = Vector3.FORWARD.rotated(Vector3.UP, cam_twist.rotation.y)
	
	current_recoil = lerp(current_recoil, target_recoil, 0.95) #hard code i know
	target_recoil = lerp(target_recoil, Vector2.ZERO, cur_weapon.resource.recoil_smoothing * delta)
	cam_twist.rotation.y += current_recoil.x * delta
	cam_pitch.rotation.x += current_recoil.y * delta
	
	#pitch clamp values
	cam_pitch.rotation.x = clamp(cam_pitch.rotation.x, -PI/2, PI/2)
	mouse_dir = Vector2.ZERO
	
func ray_cast_pos() -> void:
	#bit1 = 1
	#bit2 = 0
	#bit3 = 0
	#bit4 = 1
	var collision_mask = 9
	
	cam_ray_pos = cam_pos.global_position
	shoot_ray_pos = tip.global_position
	var cam_ray_end : Vector3 = cam_ray_pos - cam_pos.global_transform.basis.z * 256
	var space = get_world_3d().direct_space_state
	var cam_query = PhysicsRayQueryParameters3D.create(cam_ray_pos, cam_ray_end, collision_mask)
	cam_query.set_collide_with_areas(true)
	var cam_col = space.intersect_ray(cam_query)
	
	if !cam_col:
		cam_ray_point = cam_ray_end
		hit_pos = cam_ray_point
		#print("null point")
		hit_object = null
	else: 
		cam_ray_point = cam_col.position
	#print(cam_col.position)
	
	var shoot_ray_end : Vector3 = cam_ray_point
	
	# Get direction towards target
	var shoot_direction = (shoot_ray_end - shoot_ray_pos).normalized()

	# Generate random spray
	var spray_amount: float = cur_weapon.resource.spray_degree_by_bullet.sample(spray_index)*cur_weapon.resource.spray_degree
	var spray_x = deg_to_rad(randf_range(-spray_amount, spray_amount))
	var spray_y = deg_to_rad(randf_range(-spray_amount, spray_amount))

	# Rotate direction
	shoot_direction = shoot_direction.rotated(Vector3.RIGHT, spray_x)
	shoot_direction = shoot_direction.rotated(Vector3.UP, spray_y)

	# Calculate new endpoint
	shoot_ray_end = shoot_ray_pos + shoot_direction * 256
	
	var shoot_query = PhysicsRayQueryParameters3D.create(shoot_ray_pos, shoot_ray_end, collision_mask)
	shoot_query.set_collide_with_areas(true)
	var shoot_col = space.intersect_ray(shoot_query)
	
	if shoot_col:
		hit_pos = shoot_col.position
		
		hit_object = shoot_col.collider
	else:
		hit_pos = cam_ray_point
		
	#print(hit_object)
	hit_dir = shoot_ray_pos.direction_to(hit_pos)

func ray_cast_damage():
	if !hit_object:
		return
	else:
		if hit_object is Shootable:
			hit_object.on_hit(cur_weapon.calc_damage(), hit_pos)
		return
	# put this in the future BulletHitscan Class

func shoot() -> void:
	if cur_weapon.cur_mag_size <= 0:
		return
	else:
		ray_cast_pos()
		
		cur_weapon.cur_mag_size -= 1
		#camera code
		target_recoil = (cur_weapon.resource.recoil + Vector2((randf()*2-1) * cur_weapon.resource.recoil_variance.x, (randf()*2-1) * cur_weapon.resource.recoil_variance.y))/10
		spray_index += 1/cur_weapon.resource.base_mag_size
		
		if cur_weapon.resource.is_projectile:
			cur_weapon.load_projectile(
				shoot_ray_pos, hit_dir, 
				cur_weapon.calc_damage(), 
				cur_weapon.resource.bullet_projectile_base_speed
			)
		else:
			ray_cast_damage()
		player_ui.update_reload_text()

func reload() -> void:
	cur_weapon.cur_mag_size = int(cur_weapon.resource.base_mag_size)
	spray_index = 0
	player_ui.update_reload_text()

func change_weapon(index: int = 1) -> void:
	cur_weapon.set_modifers_listening(false)
	if weapon_index + index >= weapons.size():
		weapon_index = 0
		cur_weapon = weapons[weapon_index]
		player_ui.update_reload_text()
		#print(cur_weapon.resource.name)
		#return
	elif weapon_index + index <= -1:
		weapon_index = weapons.size()-1
		cur_weapon = weapons[weapon_index]
		#print(cur_weapon.resource.name)
		player_ui.update_reload_text()
		#return
	else:
		weapon_index += index
	cur_weapon = weapons[weapon_index]
	
	cur_weapon.set_modifers_listening(true)
	if gun.get_child_count() >= 2:
		gun.get_child(1).queue_free()
	gun.add_child(cur_weapon.resource.model.instantiate())
	
	#print(cur_weapon.resource.name)
	player_ui.update_reload_text()
	return
