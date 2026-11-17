extends Node3D
class_name BulletProjectile

var damage: float = 10.0
var dir: Vector3 = Vector3.FORWARD
var speed: float = 10.0
@onready var model: Node3D = $model
const lifetime : float = 3.5

var bullet_phy_inter: Physics_Interolate = Physics_Interolate.new()

func _ready() -> void:
	
	dir = dir.normalized()  #fail safe
	
	bullet_phy_inter.init(position)
	model.position = position
	model.look_at(dir + position, Vector3.UP)
	
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += dir * speed * delta
	bullet_phy_inter.process_phy(position)

func _process(delta: float) -> void:
	bullet_phy_inter.process_frame()
	model.position = bullet_phy_inter.inter_pos
	
# change later
func _on_area_3d_area_entered(area: Node) -> void:
	if area is Shootable:
		area.on_hit(damage, position)
	queue_free()
func _on_area_3d_body_entered(body: Node3D) -> void:
	queue_free()
