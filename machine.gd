extends Node3D

func _ready() -> void:
	pass
	
func _on_static_body_vert_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("green")
		$modelTest4/AnimationPlayer.play("All Animations")


func _on_static_body_red_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("red")
		$modelTest4/AnimationPlayer.stop()
