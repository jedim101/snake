extends Area2D

var screen_size # Size of the game window.
var direction = Vector2(0, -1)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.start()
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("move_right"):
		direction = Vector2(1, 0)
	elif Input.is_action_pressed("move_left"):
		direction = Vector2(-1, 0)
	elif Input.is_action_pressed("move_down"):
		direction = Vector2(0, 1)
	elif Input.is_action_pressed("move_up"):
		direction = Vector2(0, -1)

func _on_Timer_timeout():
	position += direction * 50
	position = position.clamp(Vector2.ZERO, screen_size)

	$Timer.start()
