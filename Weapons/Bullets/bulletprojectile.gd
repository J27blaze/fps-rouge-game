extends Node3D
class_name BulletProjectile

var damage: float = 10.0
var dir: Vector3 = Vector3.FORWARD
var speed: float = 10.0
@onready var model: Node3D = $model
const lifetime : float = 3.5

@export_range(0, 2, 0.05) var bullet_size: float = 0.4
@export var physics_custom_inter: int = 0

var bullet_phy_inter: Physics_Interolate = Physics_Interolate.new()
var areas: Array[Area3D] = []
	
func _ready() -> void:
	
	dir = dir.normalized()  #fail safe
	
	bullet_phy_inter.init(position)
	model.position = position
	model.look_at(dir + position, Vector3.UP)
	
	areas.resize(physics_custom_inter+1)
	areas.fill(null)
	for i in physics_custom_inter+1:
		
		areas[i] = Area3D.new()
		
		var pos_offset: Vector3 = dir * speed * float(i)/Engine.get_physics_ticks_per_second() * 0.9
		
		areas[i].position = Vector3.ZERO + pos_offset
		areas[i].collision_layer = 0
		areas[i].collision_mask = 9
		
		var col_shape := CollisionShape3D.new()
		var shape := SphereShape3D.new()
		shape.radius = bullet_size
		col_shape.shape = shape
		
		areas[i].add_child(col_shape)
		add_child(areas[i])
		
		areas[i].area_entered.connect(_on_area_entered)
		areas[i].body_entered.connect(_on_body_entered)
	
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += speed*dir*delta
	bullet_phy_inter.process_phy(position)

func _process(delta: float) -> void:
	bullet_phy_inter.process_frame()
	model.position = bullet_phy_inter.inter_pos
	
# change later
func _on_area_entered(area: Node) -> void:
	if area is Shootable:
		area.on_hit(damage, position)
	queue_free()
	
func _on_body_entered(body: Node3D) -> void:
	queue_free()
