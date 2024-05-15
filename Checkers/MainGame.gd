extends Node2D

@onready var currentPlayer = $RedPlayer
@export var piece:PackedScene
var currentPieceInPlayerHand = null
var mouse_click_positions
var previousPosition = null

var GridSize = 8
var BoardDictionary = {}


func _ready():
	generateBoard()
	intializePlayerPieces()
	$TileMap.updateBoard(BoardDictionary)
	print("Go ", currentPlayer.color)


var pickingUp = false
func _process(delta):
	
	var tilePosition = $TileMap.getLocal( get_global_mouse_position())

	#place
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		tilePosition = mouse_click_positions
		mouse_click_positions = null
		if BoardDictionary.has(str(tilePosition)) and currentPieceInPlayerHand != null:
			var tileItem = BoardDictionary[str(tilePosition)]
			var d = tilePosition - previousPosition
			if d == Vector2i.ZERO and not pickingUp:
				tileItem["piece"] = currentPieceInPlayerHand
				print("returning :", tilePosition)
				currentPieceInPlayerHand = null
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
			elif tileItem["piece"] != "":
				pickingUp = false
				previousPosition = tilePosition
				#erase_cell(1,tilePosition)
				print("removing ", str(tilePosition))
				currentPieceInPlayerHand = tileItem["piece"]
				tileItem["piece"] = ""
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
			elif previousPosition and (isValidPosition(tileItem,d, currentPieceInPlayerHand,false)): #  or d == Vector2i.ZERO)
				
				#set_cell(1,tilePosition,1, Vector2(currentPiece/2,0), 0)
				tileItem["piece"] = currentPieceInPlayerHand
				print("placing :", tilePosition)
				currentPieceInPlayerHand = null
				
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
				changeCurrentPlayer()
			pickingUp = false		
	#pickup
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_click_positions = tilePosition
		if BoardDictionary.has(str(tilePosition)) and currentPieceInPlayerHand == null:
			var tileItem = BoardDictionary[str(tilePosition)]
			if tileItem["piece"] and  tileItem["piece"] == currentPlayer.color:
				currentPieceInPlayerHand = tileItem["piece"]
				tileItem["piece"] = ""
				BoardDictionary[str(tilePosition)] = tileItem
				previousPosition = tilePosition
				print("picking ", tilePosition)
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
				pickingUp = true

func isValidPosition(item, delta, color, isKinged):
	if item["color"] != "black":
		return
	var canGoUp 
	var canGoDown
	if color == "red":
		canGoDown = true
		canGoUp = isKinged
	else:
		canGoDown = isKinged
		canGoUp = true
	print ("Delta : ", delta)
	if delta.y == 1 and canGoDown and abs(delta.x) == 1:
		return true
	if delta.y == -1 and canGoUp and abs(delta.x) == 1:
		return true
	return false

func generateBoard():
	for x in GridSize:
		for y in GridSize:
			var gridLocation = Vector2(x,y)
			var tileColor = "red"
			if y%2 == 0: 
				if x%2> 0:
					tileColor = "black"
			elif x%2 == 0:
					tileColor = "black"
			
			BoardDictionary[str(gridLocation)] = {
				"color" : tileColor,
				"piece" : ""
			}
func intializePlayerPieces():
	for y in GridSize:
		if y < 3 or y > 4:
			for x in GridSize:	
				var gridLocation = Vector2(x,y)		
				var boardItem = BoardDictionary[str(gridLocation)]
				if boardItem["color"] == "black":
					if  y < 3: # add red
						#set_cell(1,gridLocation,1,Vector2i(0,0),0)
						var redPiece:Piece = piece.instantiate()
						redPiece.color = "red"
						add_child(redPiece)
						boardItem["piece"] = "red"
					if y > 4:
						#set_cell(1,gridLocation,1,Vector2i(1,0),0)
						var blackPiece:Piece = piece.instantiate()
						blackPiece.color = "red"
						add_child(blackPiece)
						boardItem["piece"] = "black"
					BoardDictionary[str(gridLocation)] = boardItem	

func changeCurrentPlayer():
	if currentPlayer == $RedPlayer:
		currentPlayer = $BlackPlayer
	else:
		currentPlayer = $RedPlayer
	print("Go ", currentPlayer.color)