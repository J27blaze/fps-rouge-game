extends Camera3D
@export var player: Player
var target_player: bool = true

#var phy_inter: Physics_Interolate = Physics_Interolate.new()

func _ready():
	if target_player:
		position = player.weapon_controller.target_cam_pos
		rotation = player.cam_pos.global_rotation
	
func _process(delta: float) -> void:
	if target_player:
		position = player.weapon_controller.target_cam_pos
		rotation = player.cam_pos.global_rotation
