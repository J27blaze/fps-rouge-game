extends TextureRect
class_name WeaponUI

var player_ui: PlayerUI
var weapon: Weapon

func load_resource() -> void:
	texture = weapon.resource.ui_asset
	#do the modifer code in here
