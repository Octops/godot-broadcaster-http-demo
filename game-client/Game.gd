extends Node

func _ready():
	get_tree().connect("server_disconnected", self, "on_server_disconnected")
	get_tree().connect("connected_to_server", self, "on_connected_to_server")
	$Lobby.connect("join_server", self, "on_join_server")

func on_join_server(server_ip : String, port : int) -> void:
	get_node("Chat").connect_to_server(server_ip, port)
