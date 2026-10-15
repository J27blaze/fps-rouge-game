extends Camera3D
@export var player: Player
var target_player: bool = true

func _physics_process(delta: float) -> void:
	if target_player:
		position = player.cam_pos.global_position
		rotation = player.cam_pos.global_rotation
