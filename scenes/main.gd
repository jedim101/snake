extends Node

var screen_size # Size of the game window.
var direction = Vector2(1, 0)

func _ready():
	$Timer.start()
	# screen_size = get_viewport_rect().size

func _process(_delta):
	if Input.is_action_pressed("move_right"):
		direction = Vector2(1, 0)
	elif Input.is_action_pressed("move_left"):
		direction = Vector2(-1, 0)
	elif Input.is_action_pressed("move_down"):
		direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		direction = Vector2(0, -1)

func _on_Timer_timeout():
	var body_segment = ColorRect.new();
	add_child(body_segment)

	body_segment.position = $Head.position
	body_segment.color = "#13ac56"
	body_segment.size.x = 40
	body_segment.size.y = 40


	$Head.position += direction * 40

	$Timer.start()
