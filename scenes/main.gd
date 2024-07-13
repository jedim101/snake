extends Node

@export var start_length: int
var direction : Vector2
var next_direction : Vector2

var start_position = Vector2(7 * 40 + 60, 11 * 40 + 60)

var snake: Array

func start_game():
	direction = Vector2(1, 0)
	next_direction = Vector2(1, 0)

	get_tree().paused = false
	get_tree().call_group("snake", "queue_free")
	$GameOver.hide()
	snake = [$Head]
	$Head.position = start_position
	generate_apple()

	for i in range(start_length - 1):
		new_segment(start_position + Vector2(-(start_length - 1 - i) * 40, 0), false)

	$Timer.start()

func update_score():
	$Score.text = "Score: " + str(len(snake) - start_length)

func snake_positions():
	return snake.map(func(segment): return segment.position)

func generate_apple():
	var new_position = Vector2(randi_range(0, 20) * 40 + 60, randi_range(0, 20) * 40 + 60)
	
	if new_position in snake_positions():
		generate_apple()
	else:
		$Apple.position = new_position

func new_segment(pos, turn):
	var body_segment = Sprite2D.new();
	add_child(body_segment)

	body_segment.position = pos

	if turn:
		body_segment.set_texture(preload("res://assests/Turn.png"))

		var rotation: int
		if turn.x + turn.y == 0:
			rotation = turn.x * 90

		body_segment.rotation_degrees = ((turn.y + 1) + (turn.x + 1) / 2) * -90
	else:
		body_segment.set_texture(preload("res://assests/Body.png"))

	body_segment.add_to_group("snake")

	snake.append(body_segment)

func _ready():
	start_game()
	
func _process(_delta):
	var new_direction = next_direction
	if Input.is_action_pressed("move_right"):
		new_direction = Vector2(1, 0)
	elif Input.is_action_pressed("move_left"):
		new_direction = Vector2(-1, 0)
	elif Input.is_action_pressed("move_down"):
		new_direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		new_direction = Vector2(0, -1)
	
	# no turning around
	if new_direction + direction != Vector2(0, 0):
		next_direction = new_direction

	# $Head.position += direction * 40 * (delta / $Timer.wait_time)


func _on_Timer_timeout():
	direction = next_direction
	var new_head_position = $Head.position + direction * 40
	$Head.rotation_degrees = direction.x * 90 + direction.y * 90 + abs(direction.y) * 90

	if new_head_position in snake_positions() or new_head_position.x < 40 or new_head_position.x > 860 or new_head_position.y < 40 or new_head_position.y > 860:
		$GameOver.show()
		$Timer.stop()
		get_tree().paused = true
		return

	new_segment($Head.position, ((snake[-1].position + new_head_position)/2 - $Head.position) / 20)
	$Head.position = new_head_position

	if new_head_position == $Apple.position:
		generate_apple()
	else:
		snake.pop_at(1).queue_free()

	update_score()
	$Timer.start()

func _on_game_over_play_again():
	start_game()
