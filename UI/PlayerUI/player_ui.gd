extends Control
class_name PlayerUI

@export var player: Player
@export var weaponc: WeaponController
@export var weapon_ui: PackedScene

#anchors
@onready var centre: Control = $centre
@onready var left_bottom: Control = $left_bottom
@onready var weapon_anim: AnimationPlayer = $Weapon_anim

@onready var pos_cur : Control = $left_bottom/Pos_cur
@onready var pos_second : Control = $left_bottom/Pos_second
@export var reload: RichTextLabel

var weapon_uis: Array[WeaponUI]

func _ready() -> void:
	load_weapon_uis()

func _process(delta: float) -> void:
	if weapon_uis.size() > 0:
		var index: int = 0
		for weapon in weapon_uis:
			if index == 0: weapon.position = pos_cur.position
			elif index == 1: weapon.position = pos_second.position
			index += 1
func swap_anim() -> void:
	weapon_anim.play("swap")
func change_weapon_resource() -> void:
	var temp1: WeaponUI = weapon_uis[0] # hard code
	var temp2: WeaponUI = weapon_uis[1] 
	
	weapon_uis[0] = temp2
	weapon_uis[1] = temp1
	
	weapon_uis[0].z_index = 0
	weapon_uis[1].z_index = -1
	
	#update_reload_text()
	#weapon_uis[0].load_resource()
#	weapon_uis[1].load_resource()
	
func load_weapon_uis() -> void:
	weapon_uis.clear()
	
	var index: int = 0
	for weapon in weaponc.weapons:
		var instance: WeaponUI = weapon_ui.instantiate()
		
		instance.position = Vector2.ZERO
		instance.player_ui = self
		instance.weapon = weapon
		
		instance.load_resource()
		instance.load_modifers()
		
		instance.z_index = -index
		
		weapon_uis.append(instance)
		
		left_bottom.add_child(instance)
		print(weapon.resource.name)
		
		index += 1
	#update_reload_text()

func update_reload_text() -> void:
	reload.text = str(int(weaponc.cur_weapon.cur_mag_size)) + "/" + str(int(weaponc.cur_weapon.resource.base_mag_size))
