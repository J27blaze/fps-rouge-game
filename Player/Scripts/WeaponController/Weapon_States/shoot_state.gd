extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value

var burst_fired: int = 1

func start():
	burst_fired = 1
	timer_reset()
	weaponc.shoot()

func process_physics(delta: float) -> void:
	if burst_fired < weaponc.cur_weapon.base_burst_fire_amount && weaponc.cur_weapon.is_burst_fire:
		if timer >= weaponc.cur_weapon.base_burst_fire_interval:
			weaponc.shoot()
			burst_fired += 1
			timer_reset()
	else:
		if timer >= weaponc.cur_weapon.base_fire_rate:
			change_state("nonshoot")
