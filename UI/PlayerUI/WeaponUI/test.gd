extends Area2D

func _ready() -> void:
	input_pickable = true
	monitoring = true
	get_viewport().physics_object_picking = true
	mouse_entered.connect(func(): print("SUCCESS: Area2D mouse_entered fired!"))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("--- CLICK DIAGNOSTIC ---")
		print("1. Blocking Control: ", get_viewport().gui_get_hovered_control())
		print("2. Area2D Global Pos: ", global_position, " | Mouse Global Pos: ", get_global_mouse_position())
		
		# Manually query the 2D physics server right under the mouse
		var space := get_world_2d().direct_space_state
		var query := PhysicsPointQueryParameters2D.new()
		query.position = get_global_mouse_position()
		query.collide_with_areas = true
		query.collide_with_bodies = false
		print("3. Physics Areas under mouse: ", space.intersect_point(query))
