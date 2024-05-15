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
	currentPlayer.currentTurn = true
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
				currentPlayer.showPieceInHand = false
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
		#	elif tileItem["piece"] != null:
		#		pickingUp = false
		#		previousPosition = tilePosition
				#erase_cell(1,tilePosition)
		#		print("removing ", str(tilePosition))
		#		currentPieceInPlayerHand = tileItem["piece"]
		#		tileItem["piece"] = null
		#		BoardDictionary[str(tilePosition)] = tileItem
		#		$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
			elif previousPosition and (isValidPosition(tileItem,d, currentPieceInPlayerHand)): #  or d == Vector2i.ZERO)
				
				#set_cell(1,tilePosition,1, Vector2(currentPiece/2,0), 0)
				tileItem["piece"] = currentPieceInPlayerHand
				print("placing :", tilePosition)
				currentPieceInPlayerHand = null
				currentPlayer.showPieceInHand = false
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
				changeCurrentPlayer()
			pickingUp = false		
	#pickup
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		mouse_click_positions = tilePosition
		if BoardDictionary.has(str(tilePosition)) and currentPieceInPlayerHand == null:
			var tileItem = BoardDictionary[str(tilePosition)]
			if tileItem["piece"] and  tileItem["piece"].color == currentPlayer.color:
				currentPieceInPlayerHand = tileItem["piece"]
				tileItem["piece"] = null
				BoardDictionary[str(tilePosition)] = tileItem
				previousPosition = tilePosition
				print("picking ", tilePosition)
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
				pickingUp = true
				currentPlayer.showPieceInHand = true

func isValidPosition(item, delta, piece):
	var isKinged = piece.kinged
	if item["color"] != "black":
		return
	var canGoUp 
	var canGoDown
	if piece.color == "red":
		canGoDown = true
		canGoUp = isKinged
	else:
		canGoDown = isKinged
		canGoUp = true
	print ("Delta : ", delta)
	print ("Delta/1 : ", delta/Vector2i.ONE)
	var direction =0 #this should be a number between -1 UP and 1 DDOWN representing the y of the delta
	if abs(delta.x) == abs(delta.y): #we have a linear vector
		if delta.y > 0:
			direction = 1
		if delta.y < 0:
			direction = -1		
		print("direction ", direction)
		print("LENGTH ", delta.y)
		#we need to iterate over LENGHT in the vector to ensure if oppisite color, space, repeat
		if isKinged or (direction < 0 and canGoUp) or direction > 0 and canGoDown:
			for iteration in delta.y:
				var postitionToCheck:Vector2i = Vector2i(delta.x + iteration, delta.y + iteration) ## tthis is wrong, bring the intial position pback into this function
				if iteration % 2 == 0:
					print("needs to be blank")
				else:
					print("needs to have ennemy")
				print(iteration)
				print(postitionToCheck)
		
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
				"piece" : null
			}
func intializePlayerPieces():
	for y in GridSize:
		if y < 3 or y > 4:
			for x in GridSize:	
				var gridLocation = Vector2(x,y)		
				var boardItem = BoardDictionary[str(gridLocation)]
				if boardItem["color"] == "black": #only black tiles are valid
					if  y < 3: # add red
						var redPiece:Piece = piece.instantiate()
						redPiece.color = "red"
						add_child(redPiece)
						boardItem["piece"] = redPiece
					if y > 4:
						var blackPiece:Piece = piece.instantiate()
						blackPiece.color = "black"
						add_child(blackPiece)
						boardItem["piece"] = blackPiece
					BoardDictionary[str(gridLocation)] = boardItem	

func changeCurrentPlayer():
	currentPlayer.showPieceInHand = false
	currentPlayer.currentTurn = false
	if currentPlayer == $RedPlayer:
		currentPlayer = $BlackPlayer
	else:
		currentPlayer = $RedPlayer
	currentPlayer.currentTurn = true
	print("Go ", currentPlayer.color)
