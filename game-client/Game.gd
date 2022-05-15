extends Node

func _ready():
	$Lobby.connect("join_server", self, "on_join_server")

func on_join_server(server_ip : String, port : int) -> void:
	get_node("Chat").connect_to_server(server_ip, port)
