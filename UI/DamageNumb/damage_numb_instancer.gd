extends Node
class_name DamageNumbInstancer

@onready var delay : Timer = $delay
@onready var damage_numb: PackedScene = preload("res://UI/DamageNumb/damage_numb.tscn")
@onready var world = get_tree().current_scene
var cur_numb: float = 0.0

var damage_numb_scenes: Array[DamageNumb] = []
var damage_numb_index: int = 0
const max_amount_damage_numb: int = 4

func _ready():
	damage_numb_scenes.resize(max_amount_damage_numb)
	damage_numb_scenes.fill(null)

func display_numb(damage: float, hit_pos: Vector3):
	var display: DamageNumb
	if !damage_numb_scenes[damage_numb_index]:
		display = damage_numb.instantiate()
		damage_numb_scenes[damage_numb_index] = display
		world.add_child(display)
	else:
		display = damage_numb_scenes[damage_numb_index]
	display.position = hit_pos
	cur_numb += damage
	display.numb = cur_numb
	
	display.instance()
	print(damage_numb_scenes)
	delay.start()
	
	if damage_numb_index + 1 == max_amount_damage_numb: damage_numb_index = 0
	else: damage_numb_index += 1 #this system assumes numbers a displayed for a fixed length

func _on_delay_timeout() -> void:
	cur_numb = 0
