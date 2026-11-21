
extends Resource
class_name ModiferResource

@export var name: String = ""
@export_multiline var hover_text: String
@export var event_connectors: Array[Event.Type] = [Event.Type.PLAYER_SWAP_WEAPON]
@export var mod_behaviour: GDScript
@export var ui_asset: Texture = preload("uid://ds1hskliq2suj")
