extends MeshInstance3D

@export var speed: float = 0.5

func _process(delta: float) -> void:
	mesh.surface_get_material(0).uv1_offset.y += delta * speed
