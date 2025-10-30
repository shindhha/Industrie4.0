extends Node3D

@onready var rouge = $rouge
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rouge.rotation_degrees.y(delta)
	pass
