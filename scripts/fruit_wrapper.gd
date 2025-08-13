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
		_on_click()

func _on_click():
	var board_state = GameManager.get_board_state()
	var pressedItem: Node3D = board_state.pressedItem

	if not pressedItem: # no pressed object
		GameManager.update_board_state({'pressedItem': self})
		self.mesh_color = MeshesConst.ACTIVE_ITEM_COLOR
		return

	if pressedItem.get_instance_id() == self.get_instance_id(): # the same object
		self.mesh_color = MeshesConst.DEFAULT_ITEM_COLOR
		GameManager.update_board_state({'pressedItem': null})
		return

	_swap_item_positions(self, pressedItem)

	pressedItem.mesh_color = MeshesConst.DEFAULT_ITEM_COLOR
	GameManager.update_board_state({'pressedItem': null})

func _swap_item_positions(previous: Node3D, current: Node3D) -> void:
	var tween_new = create_tween()
	var tween_pressed = create_tween()

	var current_position = Vector3(current.position)
	var previous_position = Vector3(previous.position)
	current_position.y += 0.5
	previous_position.y -= 0.5

	tween_new.tween_property(current, "position", current_position, 0.2).set_delay(0)
	tween_pressed.tween_property(previous, "position", previous_position, 0.2).set_delay(0)

	var temp_y = previous_position.y
	previous_position.y = current_position.y
	current_position.y = temp_y

	tween_new.tween_property(current, "position", previous_position, 0.3).set_delay(0)
	tween_pressed.tween_property(previous, "position", current_position, 0.3).set_delay(0)

	current_position.y += 0.5
	previous_position.y -= 0.5
	
	tween_new.tween_property(current, "position", previous_position, 0.2).set_delay(0)
	tween_pressed.tween_property(previous, "position", current_position, 0.2).set_delay(0)
