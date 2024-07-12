extends Node

@export var length: int
var direction = Vector2(1, 0)
var new_direction = Vector2(1, 0)

var start_position = Vector2(400, 400)

var snake = [$Head]

func _ready():
	$Head.position = start_position

	for i in range(5):
		new_segment(start_position + Vector2(-(5 - i) * 40, 0))

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

	new_segment($Head.position)
	snake.pop_at(1).queue_free()
	
	$Head.position += direction * 40

	$Timer.start()

func new_segment(pos):
	var body_segment = ColorRect.new();
	add_child(body_segment)

	body_segment.position = pos
	body_segment.name = str(length - 1)

	body_segment.size.x = 40
	body_segment.size.y = 40
	body_segment.color = "#13ac56"

	snake.append(body_segment)