extends Resource
class_name Weapon

@export var name: String = "test_weapon"
@export var model_scene: PackedScene = preload("res://Player/Scripts/Weapons/TestWeapon/test_weapon.tscn")
@export_range(1, 100, 1) var base_damage: float = 0 #ideally dmg numbers are ints
@export_range(1, 100, 1) var base_mag_size: float = 0
@export_range(0, 5, 0.01) var base_reload_length: float = 0
