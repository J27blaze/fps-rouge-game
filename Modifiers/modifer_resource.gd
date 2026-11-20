@tool
extends Resource
class_name ModiferResource

@export var name: String = ""
@export var event_connectors: Array[Event.Type] = []
@export var mod_behaviour: GDScript
@export var ui_asset: Texture = preload("uid://ds1hskliq2suj")
