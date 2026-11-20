extends CharacterBody3D
class_name Enemy

#Create a like enemy blank scene when done

@export_group("Physics Process")
var physics_frame: int = 0
@export_range(1, 60) var navigation_querys_per_second: int = 3
@onready var navi_mod: int = Engine.get_physics_ticks_per_second()/navigation_querys_per_second
@onready var navigate: Custom_Navigate = $navigate
@onready var player: Player = GameManager.player
var target_navi_dir: Vector3 = Vector3.ZERO
var cur_navi_dir: Vector3 = Vector3.ZERO

@export_group("Enemy Paramters")
@export var health : float = 100
@export_range(0, 30, 0.05) var chase_speed: float = 10
@export_range(0, 5, 0.01) var fall_speed: float = 9.8

func on_hit(damage: float, hit_position: Vector3):
	health -= damage

func process_physics(delta: float) -> void:
	move_and_slide()
	if health <= 0:
		EventHandler.call_event(Event.Type.ENEMY_DIED)
		queue_free()
		return
	
	if physics_frame % navi_mod == 0:
		navigate.target_position = player.position
		#print(player.position)
		target_navi_dir = navigate.get_navigate_dir()*chase_speed
	
	cur_navi_dir = lerp(cur_navi_dir, target_navi_dir, 5 * delta)
	velocity.x = cur_navi_dir.x #SUPER TEMP CODE
	velocity.z = cur_navi_dir.z
	
	if !is_on_floor(): velocity.y -= fall_speed 
	else: velocity.y = 0
	
	physics_frame += 1

func _physics_process(delta: float) -> void:
	process_physics(delta)
