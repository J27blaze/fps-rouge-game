extends Node
@onready var camera = get_viewport().get_camera_3d()
@onready var player: Player
@onready var stage = get_tree().current_scene # change later

func _ready() -> void:
	get_viewport().physics_object_picking = true

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(KEY_F1):
		Engine.set_time_scale(0.01)
