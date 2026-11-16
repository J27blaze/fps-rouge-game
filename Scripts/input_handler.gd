extends Node
var camera_controller_sensitivity = 0.07
var camera_mouse_sensitivity = 0.001

var buffered_inputs: Dictionary[String, float]

func _process(delta: float) -> void:
	#print(buffered_inputs)
	if !buffered_inputs.is_empty():
		for input in buffered_inputs:
			
			if buffered_inputs[input] > 0:
				buffered_inputs[input] -= delta*60

var debug_draw: bool = true
func _input(event: InputEvent) -> void:
	#if InputEvent is InputEventAction:
	
	#idk how else to program this to be scalable for menus and different buffer windows
	#but for now the buffered inputs are hard coded EW
	
	if Input.is_action_just_pressed("jump"):
		buffered_inputs["jump"] = 7
	if Input.is_action_just_pressed("shoot"):
		buffered_inputs["shoot"] = 20
	if Input.is_action_just_pressed("reload"):
		buffered_inputs["reload"] = 20
	
	if Input.is_action_just_pressed("ui_cancel") && event.is_action("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if Input.is_action_just_pressed("ui_focus_next") && event.is_action("ui_focus_next"):
		debug_draw = !debug_draw
		DebugDraw3D.set_debug_enabled(debug_draw)
		get_tree().debug_collisions_hint = not get_tree().debug_collisions_hint
	pass

#function can only work in process_phyisics, and not process_input
func is_action_buffered(input: String):
	if buffered_inputs.has(input):
		if buffered_inputs[input] > 0:
			#buffered_inputs[input] = 0
			return true
		else:
			return false
	else:
		return false

func clear_action_buffer(input: String):
	buffered_inputs[input] = 0

# camera
func get_raw_controller_camera_dir():
	return Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down")

func get_controller_camera_dir():
	return Input.get_vector("camera_left", "camera_right", "camera_up", "camera_down") * camera_controller_sensitivity

func get_raw_mouse_camera_dir(event: InputEventMouseMotion):
	return event.relative
	
func get_mouse_camera_dir(event: InputEventMouseMotion):
	return event.relative * camera_mouse_sensitivity
	
#running and stuff
func get_input_dir():
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	if input.length() > 0.8:
		if Vector2.UP.dot(input.normalized()) > 0.995:
			return Vector2.UP
		else:
			return input.normalized()
	else:
		return input
		
func get_raw_input_dir():
	return Input.get_vector("move_left", "move_right", "move_forward", "move_back")
