extends State

var weaponc: WeaponController:
	get: return parent as WeaponController
	set(value): weaponc = value
