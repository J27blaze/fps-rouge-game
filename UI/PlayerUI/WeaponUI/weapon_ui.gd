extends TextureRect
class_name WeaponUI

var player_ui: PlayerUI
var weapon: Weapon
@export var modifer_ui: PackedScene

@onready var initial_mod_pos: Vector2 = $initial_mod_pos.position

func load_resource() -> void:
	texture = weapon.resource.ui_asset
	#do the modifer code in here
	for modifer in weapon.modifers:
		if !modifer:
			return
		else:
			var instance: ModiferUI = modifer_ui.instantiate()
			
			instance.position = initial_mod_pos
			instance.player_ui = player_ui
			instance.modifier = modifer
			instance.load_resource()
			print(modifer.resource.name)
			
			add_child(instance)
