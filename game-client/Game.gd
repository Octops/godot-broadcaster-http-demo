extends Node

var world : PackedScene = load("res://World.tscn")

func _ready():
	get_tree().connect("server_disconnected", self, "on_server_disconnected")
	get_tree().connect("connected_to_server", self, "on_connected_to_server")
	$Lobby.connect("join_server", self, "on_join_server")
	var w = get_node_or_null("World")
	if w != null:
		w.queue_free()
		
	

func spawn_world(visible : bool) -> void:
	var world_instance = world.instance()
	world_instance.name = "World"
	world_instance.visible = visible
	add_child(world_instance)

func on_server_disconnected() -> void:
	get_node("World").queue_free()
	$Lobby.visible = true

func on_connected_to_server() -> void:
	$Lobby.visible = false
	get_node("World").visible = true


func _on_Leave_button_down() -> void:
	get_node("World").queue_free()
	$Lobby.visible = true
	

func on_join_server(server_ip : String, port : int) -> void:
	spawn_world(false)
	get_node("World").connect_to_server(server_ip, port)
