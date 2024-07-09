extends Node

@export var snake_scene : PackedScene

var score: int

var snake_pos: Array

var start_pos = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	generate_snake()
	pass # Replace with function body.

func generate_snake():
	snake_pos[0] += 1
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
