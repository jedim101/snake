extends Node

@export var start_length: int
var direction = Vector2(1, 0)
var new_direction = Vector2(1, 0)

var start_position = Vector2(7 * 40 + 40, 11 * 40 + 40)

var snake: Array

func _ready():
	snake = [$Head]
	$Head.position = start_position
	generate_apple()

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
	
	# no turning around
	if new_direction + direction == Vector2(0, 0):
		new_direction = direction

	# $Head.position += direction * 40 * (delta / $Timer.wait_time)

func update_score():
	$Score.text = "Score: " + str(len(snake) - start_length)

func snake_positions():
	return snake.map(func(segment): return segment.position)

func generate_apple():
	var new_position = Vector2(randi_range(0, 20) * 40 + 40, randi_range(0, 20) * 40 + 40)
	
	if new_position in snake_positions():
		generate_apple()
	else:
		$Apple.position = new_position

func _on_Timer_timeout():
	direction = new_direction
	var new_head_position = $Head.position + direction * 40

	if new_head_position in snake_positions() or new_head_position.x < 40 or new_head_position.x > 840 or new_head_position.y < 40 or new_head_position.y > 840:
		$Timer.stop()
		return

	new_segment($Head.position)
	$Head.position = new_head_position

	if new_head_position == $Apple.position:
		generate_apple()
	else:
		snake.pop_at(1).queue_free()

	update_score()
	$Timer.start()

func new_segment(pos):
	var body_segment = ColorRect.new();
	add_child(body_segment)

	body_segment.position = pos
	body_segment.size.x = 40
	body_segment.size.y = 40
	body_segment.color = $Head.color

	snake.append(body_segment)