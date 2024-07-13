extends Node

@export var start_length: int
var direction = Vector2(1, 0)
var next_direction = Vector2(1, 0)

var start_position = Vector2(7 * 40 + 40, 11 * 40 + 40)

var snake: Array

func start_game():
	get_tree().paused = false
	get_tree().call_group("snake", "queue_free")
	$GameOver.hide()
	snake = [$Head]
	$Head.position = start_position
	generate_apple()

	for i in range(start_length - 1):
		new_segment(start_position + Vector2(-(start_length - 1 - i) * 40, 0))

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

func new_segment(pos):
	var body_segment = ColorRect.new();
	add_child(body_segment)

	body_segment.position = pos
	body_segment.size.x = 40
	body_segment.size.y = 40
	body_segment.color = $Head.color
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

	if new_head_position in snake_positions() or new_head_position.x < 40 or new_head_position.x > 840 or new_head_position.y < 40 or new_head_position.y > 840:
		$GameOver.show()
		$Timer.stop()
		get_tree().paused = true
		return

	new_segment($Head.position)
	$Head.position = new_head_position

	if new_head_position == $Apple.position + Vector2(-20, -20):
		generate_apple()
	else:
		snake.pop_at(1).queue_free()

	update_score()
	$Timer.start()

func _on_game_over_play_again():
	start_game()
