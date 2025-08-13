extends Node3D

@export var mesh_color: Color:
	set(value):
		mesh_color = value
		if is_node_ready():
			_apply_mesh()

@export var mesh_resource: Mesh:
	set(value):
		mesh_resource = value
		if is_node_ready():
			_apply_mesh()
		
func _ready() -> void:
	_apply_mesh()

func _apply_mesh():
	var holder: MeshInstance3D = $Fruit/MeshHolder
	if(mesh_color):
		var material = holder.get_active_material(0).duplicate()
		material.albedo_color = mesh_color
		holder.set_surface_override_material(0, material)

	if(mesh_resource):
		holder.mesh = mesh_resource


func _on_fruit_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if(event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		GameManager.fruit_click.emit(self)
