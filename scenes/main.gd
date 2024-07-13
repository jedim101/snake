extends Node

@export var start_length: int
var direction = Vector2(1, 0)
var new_direction = Vector2(1, 0)

var start_position = Vector2(400, 400)

var snake: Array

func _ready():
	snake = [$Head]
	$Head.position = start_position

	for i in range(start_length - 1):
		new_segment(start_position + Vector2(-(start_length - 1 - i) * 40, 0))

	$Timer.start()

func _process(_delta):
	if Input.is_action_pressed("move_right"):
		new_direction = Vector2(1, 0)
	elif Input.is_action_pressed("move_left"):
		new_direction = Vector2(-1, 0)
	elif Input.is_action_pressed("move_down"):
		new_direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		new_direction = Vector2(0, -1)

	# $Head.position += direction * 40 * (delta / $Timer.wait_time)


func _on_Timer_timeout():
	direction = new_direction
	var new_head_position = $Head.position + direction * 40

	if new_head_position in snake.map(func(segment): return segment.position):
		$Timer.stop()
		$Head.color = "#000000"
		return

	new_segment($Head.position)
	snake.pop_at(1).queue_free()
	
	$Head.position = new_head_position

	$Timer.start()

func new_segment(pos):
	var body_segment = ColorRect.new();
	add_child(body_segment)

	body_segment.position = pos
	body_segment.size.x = 40
	body_segment.size.y = 40
	body_segment.color = "#13ac56"

	snake.append(body_segment)
