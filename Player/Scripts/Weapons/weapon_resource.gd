@tool
extends Resource
class_name Weapon

var cur_mag_size: int = 0

@export var name: String = "test_weapon"
@export var model_scene: PackedScene = preload("res://Player/Scripts/Weapons/TestWeapon/test_weapon.tscn")
@export_group("Gun Paramaters")

@export var is_projectile: bool = false:
	set(value):
		is_projectile = value
		notify_property_list_changed()
@export var bullet_projectile: PackedScene
@export_range(0, 1000, 0.5) var bullet_projectile_base_speed: float = 100.0

@export_range(1, 100, 1) var base_damage: float = 0 # Make this Custom Damage Type
@export_range(1, 100, 1) var base_mag_size: float = 0
@export_range(0, 5, 0.01) var base_fire_rate: float = 0

@export var is_automatic: bool = true

@export var is_burst_fire: bool = false:
	set(value):
		is_burst_fire = value
		notify_property_list_changed()
@export_range(1, 10, 1) var base_burst_fire_amount: float = 3
@export_range(0, 5, 0.01) var base_burst_fire_interval: float = 0.2

@export_range(0, 5, 0.01) var base_reload_length: float = 0

@export var reocoil: Vector2 = Vector2.ZERO
@export var recoil_variance: Vector2 = Vector2.ZERO
@export_range(0, 15, 0.01) var recoil_smoothing: float = 15.0

@export var spray_degree_by_bullet: Curve
@export_range(0, 360, 0.05) var spray_degree: float

#Project / Reload Current Project
func _validate_property(property: Dictionary) -> void:
	# List all properties you want to hide when the bool is false
	if property.name in ["base_burst_fire_amount", "base_burst_fire_interval"]:
		if not is_burst_fire:
			# Removes the property from the Inspector while still saving its value
			property.usage &= ~PROPERTY_USAGE_EDITOR
			
	if property.name in ["bullet_projectile", "bullet_projectile_base_speed"]:
		if not is_projectile:
			# Removes the property from the Inspector while still saving its value
			property.usage &= ~PROPERTY_USAGE_EDITOR
