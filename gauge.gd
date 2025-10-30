extends Node3D

@export var rotation_min := -180.0      # angle minimum
@export var rotation_max := 0.0         # angle maximum
@export var mqtt_topic := "test/gauge"  # topic MQTT à écouter

var needle: Node3D

# MQTT
var MQTT_instance: Node = null

# Valeur actuelle de la gauge, mise à jour par MQTT
var current_y := 0.0

func _ready():
	needle = $Gauge/Nidle
	if needle == null:
		push_error("Aiguille non trouvée sous Gauge !")
		return

	# Créer l'instance MQTT
	MQTT_instance = preload("res://addons/mqtt/mqtt.gd").new()
	add_child(MQTT_instance)
	
	# Connecter aux signaux MQTT
	MQTT_instance.broker_connected.connect(_on_mqtt_connected)
	MQTT_instance.broker_connection_failed.connect(_on_mqtt_failed)
	MQTT_instance.received_message.connect(_on_mqtt_message)
	
	# Connexion au broker
	MQTT_instance.connect_to_broker("tcp://test.mosquitto.org:1883/")

func _on_mqtt_connected():
	print("✅ Connecté au broker MQTT")
	MQTT_instance.subscribe(mqtt_topic)
	print("Souscrit au topic:", mqtt_topic)

func _on_mqtt_failed():
	print("❌ Échec de connexion au broker MQTT")

func _on_mqtt_message(topic, message):
	# Convertir le message en float et limiter à rotation_min/rotation_max
	var value = float(message)
	value = clamp(value, rotation_min, rotation_max)
	current_y = value
	# Mettre à jour la rotation immédiatement
	if needle != null:
		needle.rotation_degrees.y = current_y

func _process(delta):
	if needle == null:
		return
	# La rotation est maintenant directement contrôlée par current_y reçu via MQTT
	needle.rotation_degrees.y = current_y
