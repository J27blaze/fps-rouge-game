extends Node3D
class_name HitscanBullet

func draw(a: Vector3, b: Vector3, thickness: float, color: Color) -> void:
	var direction := b - a
	var distance := direction.length()

	var cylinder := CylinderMesh.new()
	cylinder.height = distance
	cylinder.top_radius = thickness * 0.5
	cylinder.bottom_radius = thickness * 0.5
	cylinder.radial_segments = 8

	var material := StandardMaterial3D.new()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	cylinder.material = material

	var mesh := MeshInstance3D.new()
	mesh.mesh = cylinder
	mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	mesh.position = (a + b) * 0.5
	mesh.quaternion = Quaternion(Vector3.UP, direction.normalized())

	GameManager.stage.add_child(mesh)
	
	GameManager.stage.get_tree().create_timer(0.15).timeout.connect(mesh.queue_free)
