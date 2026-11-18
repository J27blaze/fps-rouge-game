extends Node
class_name Weapon

var resource: WeaponResource

func _init(weapon_resource: WeaponResource = preload("uid://xenwrkxc7ylc")) -> void:
	resource = weapon_resource
	#EventHandler.connect_event(self, Event.PLAYER_SHOOT)

var cur_mag_size: int = 0
var modifers: Array[Modifer] = []



func load_projectile(from: Vector3, direction: Vector3, damage: float, speed: float) -> void:
	var bullet_instance : BulletProjectile = resource.bullet_projectile.instantiate()
	bullet_instance.dir = direction
	bullet_instance.speed = speed
	bullet_instance.position = from
	bullet_instance.damage = damage
	
	GameManager.stage.add_child(bullet_instance)
