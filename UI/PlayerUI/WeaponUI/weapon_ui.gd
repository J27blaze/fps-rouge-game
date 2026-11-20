extends TextureRect
class_name WeaponUI

var player_ui: PlayerUI
var weapon: Weapon
@export var modifer_ui: PackedScene

@export var initial_mod_pos: Vector2 = Vector2.ZERO
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func load_resource() -> void:
	texture = weapon.resource.ui_asset
	#do the modifer code in here

func load_modifers() -> void:
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
