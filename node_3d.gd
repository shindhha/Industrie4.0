extends Node

# Instance du plugin MQTT
var MQTT_instance : Node

@onready var topic_input = $Control/topic
@onready var message_input = $Control/message
@onready var print_box = $Control/logbox
@onready var send_button = $Control/Send

func _ready():
	# Créer et ajouter l'instance MQTT
	MQTT_instance = preload("res://addons/mqtt/mqtt.gd").new()
	add_child(MQTT_instance)
	
	# Connexion aux signaux
	MQTT_instance.broker_connected.connect(_on_connected)
	MQTT_instance.broker_connection_failed.connect(_on_failed)
	MQTT_instance.received_message.connect(_on_message)
	
	# Connecter au broker public
	print("Connexion au broker MQTT...")
	MQTT_instance.connect_to_broker("tcp://test.mosquitto.org:1883/")
	
	# Connexion du bouton "Envoyer"
	send_button.pressed.connect(_on_send_pressed)

func _on_connected():
	print("✅ Connecté au broker !")
	# Souscrire à un topic par défaut
	MQTT_instance.subscribe("godot/#")
	print("Souscription à godot/#")

func _on_failed():
	print("❌ Échec de connexion au broker MQTT")

func _on_message(topic, message):
	pass

func _on_send_pressed():
	var topic = topic_input.text.strip_edges()
	var msg = message_input.text.strip_edges()
	
	if topic == "" or msg == "":
		print("⚠️ Remplis le topic et le message avant d'envoyer.")
		return
	
	MQTT_instance.publish(topic, msg)

func print(text: String):
	print_box.text += text + "\n"
	print_box.scroll_vertical = print_box.get_line_count()
