extends Node2D
@export var currentTurn:bool = false

func _ready():
	if color == "red":
		$Sprite2D.frame = 0
	else:
		$Sprite2D.frame = 1
@export var color = "": set =  setColor
func setColor(value):	
	value = value.to_lower()
	if value != "red" or value != "black":
		color = ""
	color = value

@export var totalPieces = 12

var showPieceInHand:bool = false

func _process(delta):
	
	if showPieceInHand and currentTurn:
		
		$Sprite2D.visible = true
		$Sprite2D.position =  get_global_mouse_position()
	else: 
		$Sprite2D.visible = false
		#$Sprite2D.transform.position = Vector2.ZERO
	
