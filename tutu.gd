extends Node3D

signal button_toggled(is_on: bool)

@export var is_on: bool = false
@onready var button = $Button2/Button

@onready var body_on = $On
@onready var body_off = $Off
@onready var http_request = HTTPRequest.new()

func _ready():
	print("ok")
	# Connexion des input_events
	body_on.input_event.connect(_on_on_input_event)
	body_off.input_event.connect(_on_off_input_event)
	
	# Connexion du signal au handler local
	connect("button_toggled", Callable(self, "_on_button_toggled"))
	
	# Initialisation visuelle
	_update_state()

func _on_off_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# if (is_on):
			print("off")
			is_on = false
			emit_signal("button_toggled", true)
			var url = "http://127.0.0.1:5000/api/devices/led-001/write"
			var headers = ["Content-Type: application/json"]
			var body = JSON.stringify({"state": "off"})
			var response = await HTTPRequest.new().request_async(url, headers, HTTPClient.METHOD_POST, body)
			print("Réponse :", response.body.get_string_from_utf8())
	

func _on_on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("on")
			is_on = false
			emit_signal("button_toggled", false)
			var url = "http://127.0.0.1:5000/api/devices/led-001/write"
			var headers = ["Content-Type: application/json"]
			var body = JSON.stringify({"state": "on"})
			var response = await HTTPRequest.new().request_async(url, headers, HTTPClient.METHOD_POST, body)
			print("Réponse :", response.body.get_string_from_utf8())

func _on_button_toggled(new_state: bool) -> void:
	is_on = new_state
	_update_state()

func _update_state():
	print("update:", is_on)
	if is_on:
		button.rotation_degrees = Vector3(10, 0, 0)   # bouton ON → tourné à 90°
	else:
		button.rotation_degrees = Vector3(-10, 0, 0)    # bouton OFF → rotation neutre
