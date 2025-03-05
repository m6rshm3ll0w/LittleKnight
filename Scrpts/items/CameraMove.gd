extends Area2D

signal camera_right()
signal camera_left()
signal camera_up()
signal canera_down()

@export var direction = ""



func _on_body_entered(body):
	pass


func _on_body_exited(body):
	if direction == "up":
		camera_up.emit()
	elif direction == "down":
		canera_down.emit()
	elif direction ==
