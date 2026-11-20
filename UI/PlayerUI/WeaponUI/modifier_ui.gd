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

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
	print("Clicked inside Area2D!")

func _process(delta: float) -> void:
	if !resource:
		return
	else:
		if is_mouse_hover && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			print(resource.name)
