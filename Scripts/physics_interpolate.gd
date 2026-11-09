extends Object
class_name Physics_Interolate

var cur_pos: Vector3
var prev_pos: Vector3

var cur_rot: Vector3
var prev_rot: Vector3

var inter_pos: Vector3 = Vector3.ZERO
var inter_rot: Vector3 = Vector3.ZERO
# Add scale

func init(pos: Vector3, rot: Vector3 = Vector3.ZERO) -> void:
	cur_pos = pos
	prev_pos = pos
	
	cur_rot = rot
	prev_rot = rot

func process_phy(pos: Vector3, rot: Vector3 = Vector3.ZERO):
	prev_pos = cur_pos
	cur_pos = pos
	
	cur_rot = prev_rot
	cur_rot = rot

func process_frame():
	var frame_fraction : float = Engine.get_physics_interpolation_fraction()
	
	inter_pos = lerp(prev_pos, cur_pos, frame_fraction)
	
	inter_rot.x = lerp_angle(prev_rot.x, cur_rot.x, frame_fraction)
	inter_rot.y = lerp_angle(prev_rot.y, cur_rot.y, frame_fraction)
	inter_rot.z = lerp_angle(prev_rot.z, cur_rot.z, frame_fraction)
