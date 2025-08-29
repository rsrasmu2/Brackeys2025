extends MeshInstance3D

@export var speed: float = 0.1

func _process(delta: float) -> void:
	mesh.surface_get_material(0).uv1_offset += Vector3.ONE * (delta * speed)
