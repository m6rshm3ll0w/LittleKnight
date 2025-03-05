extends Area2D

@export var dialoge_key = ""
@export_file("*.json") var scene_text_file: String

var area_active = false
var text_lines: Array
	
func _input(event):	
	if area_active and event.is_action_pressed("advance_dialog"):
		text_lines = _load_array(dialoge_key)
		var text_position = position
		text_position.y -= 10
		
		DialogeManager.start_dialog(text_position, text_lines)
	
	
func _load_array(key: String) -> Array:
	if scene_text_file.is_empty():
		return ["No file selected!"]
	
	var file = FileAccess.open(scene_text_file, FileAccess.READ)
	if not file:
		return ["Failed to open file!"]

	var content = file.get_as_text()
	file.close()

	var json_data = JSON.parse_string(content)
	if json_data == null:
		return ["Invalid JSON format!"]
		
	return json_data[key]
	


func _on_body_entered(body: CharacterBody2D):
	area_active = true
	


func _on_body_exited(body: CharacterBody2D):
	area_active = false
