extends Node3D

# === LED ===
@onready var led = $LED2/LED
@export var is_led_on = false
var color_index = 0
var led_colors = [
	Color(1,1,0,1),
	Color(1,0,0,1),
	Color(1,0,1,1),
	Color(0,0,1,1),
	Color(0,1,1,1),
]

# === API ===
var http: HTTPRequest
const API_URL = "http://localhost:5000/api/devices/led-001/read"  # à modifier
const POLLING_INTERVAL = 2.0
var current_state = null

# === Animation ===
@onready var anim_player = $Button2/AnimationPlayer

func _ready() -> void:
	# --- LED éteinte au départ
	led.get_active_material(0).albedo_color = Color(0,0,0, 1)
	
	# --- Crée et connecte le HTTPRequest
	http = HTTPRequest.new()
	add_child(http)
	http.request_completed.connect(_on_request_completed)

	# --- Lance la première requête immédiatement
	poll_api()

	# --- Lance un timer pour le polling régulier
	var timer = Timer.new()
	timer.wait_time = POLLING_INTERVAL
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(poll_api)
	add_child(timer)

func poll_api():
	var error = http.request(API_URL)
	if error != OK:
		push_error("Erreur lors de la requête HTTP : %s" % error)

func _on_request_completed(result, response_code, headers, body):
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		print(json)
		if json and json.has("value"):
			print("update")
			update_state(json["value"])
	else:
		print("Erreur API:", response_code)

func update_state(state):
	if state == current_state:
		return
	current_state = state
	print(state)
	match state:
		"on":
			is_led_on = true
			if anim_player:
				anim_player.play("press_on")
		"off":
			is_led_on = false
			if anim_player:
				anim_player.play_backwards("press_on")
		_:
			print("État inconnu :", state)

func _process(delta: float) -> void:
	if is_led_on:
		led.get_active_material(0).albedo_color = led_colors[color_index]
	else:
		led.get_active_material(0).albedo_color = Color(0,0,0,1)

func _on_timer_timeout() -> void:
	color_index = (color_index + 1) % led_colors.size()
