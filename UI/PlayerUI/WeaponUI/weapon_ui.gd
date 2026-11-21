extends Control
class_name WeaponUI

var player_ui: PlayerUI
var weapon: Weapon
@export var modifer_ui: PackedScene
var modifer_uis: Array[ModiferUI]

@export var initial_mod_pos: Vector2 = Vector2.ZERO
@export var mod_pos_offset: Vector2 = Vector2.ZERO
@export var anim_player: AnimationPlayer
@export var texture: TextureRect

@export var pos_offset: Vector2

func load_resource() -> void:
	texture.texture = weapon.resource.ui_asset
	#do the modifer code in here

func load_modifers() -> void:
	var index: int = 0
	modifer_uis.clear()
	for modifer in weapon.modifers:
		if !modifer:
			return
		else:
			var instance: ModiferUI = modifer_ui.instantiate()
			
			instance.position = initial_mod_pos + index*(mod_pos_offset)
			instance.player_ui = player_ui
			instance.modifier = modifer
			
			print(modifer.resource.name)
			
			add_child(instance)
			
			instance.load_resource()
			modifer_uis.append(instance)
			index += 1

func drag_mod_ui(mod_ui: ModiferUI) -> void:
	mod_ui.global_position = get_viewport().get_mouse_position() + Vector2.ONE*-43
func recalc_mod_ui() -> void:
	for modifer in modifer_uis:
		if !modifer:
			return
		else:
			pass
