extends Control

var server_addr = "localhost"
var server_port : int = 7778

var connection : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
const interpolation_offset : int = 30

func _ready():
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		connection.close_connection()
		get_tree().change_scene("res://Game.tscn")

func connect_to_server(server_ip : String , port : int) -> void:
	if server_ip != "" and str(port) != "":
		server_addr = server_ip
		server_port = port

	var err = connection.create_client(server_addr, server_port)
	if err != OK:
		print("Error connecting to the server")
		get_tree().quit()
		return
	get_tree().set_network_peer(connection)
	set_network_master(1)
	
func _on_connected_to_server() -> void:
	print("Connected to the server!")

puppet func receive_message(message : String) -> void:
	$Chat.add_item(message)

func send_message(message : String) -> void:
	rpc_id(1, "peer_send_message", message)

func _on_Send_button_down():
	send_message($MessageBox.text)
	$MessageBox.text = ""
