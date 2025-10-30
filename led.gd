extends Node3D

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
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	led.get_active_material(0).albedo_color = Color(0,0,0, 1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_led_on:
		led.get_active_material(0).albedo_color = led_colors[color_index]
	else :
		led.get_active_material(0).albedo_color = Color(0,0,0,1)


func _on_timer_timeout() -> void:
	color_index = color_index + 1
	if color_index >= len(led_colors):
		color_index = 0
