extends MeshInstance3D
class_name DamageNumb

var numb: float
@onready var sub_viewport : SubViewport = $sub_viewport
@onready var text: RichTextLabel = $sub_viewport/text
var tween_pos: Tween
var tween_scale: Tween

@export_range(0, 4, 0.05) var start_size: float = 1.3
@export_range(0, 2, 0.05) var length: float = 0.6
@export_range(0, 2, 0.05) var height: float = 0.6

func _ready() -> void:
	sub_viewport.set_update_mode(SubViewport.UPDATE_DISABLED)
	scale*=start_size

func instance() -> void:
	sub_viewport.set_update_mode(SubViewport.UPDATE_ONCE)
	text.text = String.num(numb, 0)
	
	reset_tween()
	
	tween_pos = create_tween()
	tween_pos.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween_pos.tween_property(
		self, "position", position+Vector3.UP*height, length/2
	)
	tween_pos.set_ease(Tween.EASE_IN)
	tween_pos.tween_property(
		self, "position", position, length/2
	)
	
	tween_scale = create_tween()
	tween_scale.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	tween_scale.tween_property(
		self, "scale", Vector3.ZERO, length
	)
	tween_scale.tween_callback(queue_free)

func reset_tween() -> void:
	if tween_pos:
		tween_pos.kill()
		tween_scale.kill()
	return
