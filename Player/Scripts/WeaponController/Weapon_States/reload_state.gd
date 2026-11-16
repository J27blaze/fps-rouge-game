extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value

func start() -> void:
	timer_reset() 

func process_frame(delta: float) -> void:
	if timer >= weaponc.cur_weapon.base_reload_length:
		weaponc.reload()
		change_state("nonshoot")
		return
