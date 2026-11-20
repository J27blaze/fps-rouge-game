extends Control
class_name ModiferUI

var texture: TextureRect

var player_ui: PlayerUI
var modifier: Modifer

var is_mouse_hover: bool = false

var resource: ModiferResource

func load_resource() -> void:
	resource = modifier.resource
	
	texture = $TextureRect
	texture.texture = resource.ui_asset

func _process(delta: float) -> void:
	if !resource:
		return
	else:
		#calc_is_mouse_hover()
		if is_mouse_hover && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			print(resource.name)

func _on_texture_rect_mouse_entered() -> void:
	print("dd")
