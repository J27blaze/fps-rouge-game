extends Control
class_name ModiferUI

var texture: TextureRect

var player_ui: PlayerUI
var modifier: Modifer

var is_mouse_hover: bool = false

var resource: ModiferResource

@onready var hover_ui := $hover_text

func load_resource() -> void:
	resource = modifier.resource
	
	texture = $TextureRect
	texture.texture = resource.ui_asset
	$hover_text/RichTextLabel.text = resource.hover_text

func _process(delta: float) -> void:
	if !resource:
		return
	else:
		#calc_is_mouse_hover()
		hover_ui.visible = is_mouse_hover
		if is_mouse_hover && Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			if Input.is_action_just_pressed("ui_click"):
				get_parent().drag_mod_ui(self)

func _on_texture_rect_mouse_entered() -> void:
	if modifier.active:
		is_mouse_hover = true
	else:
		is_mouse_hover = false
func _on_texture_rect_mouse_exited() -> void:
	is_mouse_hover = false
