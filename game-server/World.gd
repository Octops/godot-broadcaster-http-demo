extends Node
var peer = null
var default_port = 7778
var max_allowed_peers = 10

var peers : Array
var allocated = false

func _ready():
	AgonesSDK.start()
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('network_peer_connected', self, '_on_player_connected')
	var port = yield(AgonesSDK.get_ports(), "completed")
	if port == -1:
		get_tree().quit()
	host_server(port, max_allowed_peers)

func time_now() -> String:
	var time = OS.get_datetime()
	var date = "%s-%s-%sT%s:%s:%s" % [time.day, time["month"], time["year"], time["hour"], time["minute"], time["second"]]
	return date

func host_server(port : int, max_peers : int) -> void:
	peer = NetworkedMultiplayerENet.new()
	var err = peer.create_server(port, max_peers)
	if err != OK:
		AgonesSDK.shutdown()
		get_tree().quit(1)
		
	get_tree().set_network_peer(peer)
	print("Server started on port %s" % [port])
	AgonesSDK.ready()

remote func peer_send_message(message : String) -> void:
	var sender = get_tree().get_rpc_sender_id()
	var formatted_message = "[%d] at %s sent: %s" % [sender,time_now(), message]
	rpc("receive_message", formatted_message)

remote func leave() -> void:
	var sender = get_tree().get_rpc_sender_id()



func _on_player_disconnected(id : int) -> void:
	AgonesSDK.player_disconnect(str(id))
	var disconnect_message = "[%s] %s left the room" % [time_now(), str(id)]
	var position = peers.find(id)
	if position != -1:
		peers.remove(position)
	for peer in peers:
		if peer != id:
			rpc_id(peer, "receive_message", disconnect_message)

	if peers.size() == 0:
		AgonesSDK.shutdown()

func _on_player_connected(id):
	print("%d player connected!" % [id])
	peers.append(id)
	if not allocated:
		allocated = true
		AgonesSDK.allocate()
	AgonesSDK.player_connect(str(id))

	var peer_joined_message = "[%s] %s joined the room" % [time_now(), str(id)]
	for p_id in peers:
		if p_id != id:
			rpc_id(p_id, "receive_message", peer_joined_message)

func _on_Health_timeout():
	if peer:
		AgonesSDK.health()
