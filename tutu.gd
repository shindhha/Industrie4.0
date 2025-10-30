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


func post_api(url: String, body: Dictionary) -> void:
	var http := HTTPRequest.new()
	add_child(http)

	# Connecter le signal pour récupérer la réponse
	http.request_completed.connect(func(result, response_code, headers, response_body):
		print("POST vers", url)
		print("→ Code:", response_code)
		print("→ Réponse:", response_body.get_string_from_utf8())
		http.queue_free()  # Nettoyer après usage
	)

	# Config POST
	var headers = ["Content-Type: application/json"]
	var json_body = JSON.stringify(body)

	var err = http.request(url, headers, HTTPClient.METHOD_POST, json_body)
	if err != OK:
		push_error("Erreur d'envoi POST : %s" % err)
func _on_off_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# if (is_on):
			print("off")
			is_on = false
			post_api("http://127.0.0.1:5000/api/devices/led-001/write", {"state": "off"})
			emit_signal("button_toggled", true)
	

func _on_on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			print("on")
			is_on = false
			emit_signal("button_toggled", false)
			post_api("http://127.0.0.1:5000/api/devices/led-001/write", {"state": "on"})


func _on_button_toggled(new_state: bool) -> void:
	is_on = new_state
	_update_state()

func _update_state():
	print("update:", is_on)
	if is_on:
		button.rotation_degrees = Vector3(10, 0, 0)   # bouton ON → tourné à 90°
	else:
		button.rotation_degrees = Vector3(-10, 0, 0)    # bouton OFF → rotation neutre
