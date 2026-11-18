extends Node
class_name Weapon

var resource: WeaponResource
var modifers: Array[Modifer] = []

func _init(weapon_resource: WeaponResource = preload("uid://xenwrkxc7ylc")) -> void:
	resource = weapon_resource
	
	modifers.resize(6)
	modifers[0] = Modifer.new()
	modifers[0].connect_events()
	#modifers[1] = Modifer.new()
	#EventHandler.connect_event(self, Event.PLAYER_SHOOT)

func load_resource() -> void:
	cur_mag_size = resource.base_mag_size
	damage = resource.base_damage

#everythign bro 
var cur_mag_size: int = 0
var damage: float = 0
func calc_damage() -> float: #hard code modifer behaviour
	damage = resource.base_damage
	for modifer in modifers:
		if modifer:
			damage += modifer.mod_behaviour.damage_flat_increase
			damage *= clampf(modifer.mod_behaviour.damage_x_increase, 0, INF)
	return damage

func load_projectile(from: Vector3, direction: Vector3, in_damage: float, speed: float) -> void:
	var bullet_instance : BulletProjectile = resource.bullet_projectile.instantiate()
	bullet_instance.dir = direction
	bullet_instance.speed = speed
	bullet_instance.position = from
	bullet_instance.damage = in_damage
	
	GameManager.stage.add_child(bullet_instance)
