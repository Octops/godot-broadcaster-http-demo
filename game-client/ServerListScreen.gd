extends Control

var selected_server = ""
var gameservers = {}
const url = "http://localhost:30000/api/gameservers"
signal join_server(server_ip, port)

func _on_Refresh_button_down() -> void:
	$HTTPRequest.request(url)


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print(response_code)
		return
	
	var b = JSON.parse(body.get_string_from_utf8()).result
	
	if not b.has("gameservers"):
		print("Body doesn't contain gameservers list")
		return
		
	if len(b.gameservers) == 0:
		print("No gameservers running")

	$Grid.clear()
	for gs in b.gameservers:
		var map = gs.labels.map
		var mode = gs.labels.mode
		var grid_item  = "Addr: %s" % gs.addr
		grid_item  += "      Port: %s" % gs.port
		grid_item  += "      Mode: %s" % gs.labels.mode
		grid_item  += "      Players: %s" % gs.players.count
		grid_item  += "      State: %s" % gs.state
		$Grid.add_item(grid_item)
		gameservers[grid_item] = gs


func _on_Join_button_down():
	if selected_server == "":
		return

	var ip = gameservers[selected_server]['addr']

	if OS.get_name() == "OSX":
		ip = "localhost"

	var port = gameservers[selected_server]['port']
	emit_signal("join_server", ip, port)
	self.visible = false


func _on_Grid_item_selected(index):
	selected_server = $Grid.get_item_text(index)


