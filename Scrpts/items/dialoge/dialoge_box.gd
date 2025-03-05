extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $DispTimer

const max_width = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punc_time = 0.2


signal finish_displaying()

func display_text(text_to_display: String):
	text = text_to_display
	label.text = text_to_display
	
	await resized
	
	custom_minimum_size.x = min(size.x, max_width)
	
	if size.x > max_width:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y + 24
	
	print(global_position.x, global_position.y)
	
	label.text = ""
	
	_display_letter()
	

func _display_letter():
	if letter_index >= text.length():
		finish_displaying.emit()
		return
	
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finish_displaying.emit()
		return
	
	match text[letter_index]:
		".", "!", "?", ",", "-":
			timer.start(punc_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)
			

func _on_disp_timer_timeout():
	_display_letter()
