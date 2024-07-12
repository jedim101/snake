extends Node

@export var length: int
var direction = Vector2(1, 0)
var new_direction = Vector2(1, 0)
# var board = []

func _ready():
	# for r in range(15):
	# 	for c in range(20):
	# 		board[r][c] = 0
	
	# board[8][10] = length

	$Timer.start()

func _process(delta):
	if Input.is_action_pressed("move_right"):
		new_direction = Vector2(1, 0)
	elif Input.is_action_pressed("move_left"):
		new_direction = Vector2(-1, 0)
	elif Input.is_action_pressed("move_down"):
		new_direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		new_direction = Vector2(0, -1)

	$Head.position += direction * 40 * (delta / $Timer.wait_time)


func _on_Timer_timeout():
	direction = new_direction

	var body_segment = ColorRect.new();
	add_child(body_segment)

	body_segment.position = $Head.position
	body_segment.name = str(length - 1)

	body_segment.size.x = 40
	body_segment.size.y = 40
	body_segment.color = "#13ac56"

	for i in range(length):
		var segment = get_node(str(i))
		if segment:
			segment.name = str(i - 1)
	
	var end_segment = get_node("-1")
	if end_segment:
		end_segment.queue_free()
	$Timer.start()