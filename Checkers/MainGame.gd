extends Node2D

@onready var currentPlayer = $RedPlayer
@export var piece:PackedScene
var currentPieceInPlayerHand = null
var previousPosition = null

var GridSize = 8
var BoardDictionary = {}
enum {LEFT = -1, RIGHT = 1}
enum {UP = -1, DOWN = 1}

var itemsKilledThisTurn: Array[Vector2i] = []

func _ready():
	generateBoard()
	intializePlayerPieces()
	$TileMap.updateBoard(BoardDictionary)
	currentPlayer.currentTurn = true
	print("Go ", currentPlayer.color)


var pickingUp = false
func _input(event):
	
	var tilePosition = $TileMap.getLocal( get_global_mouse_position())
	var mouseEvent = event as InputEventMouseButton
	
	#place
	if mouseEvent and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !mouseEvent.pressed:
		if BoardDictionary.has(str(tilePosition)) and currentPieceInPlayerHand != null:
			var tileItem = BoardDictionary[str(tilePosition)]
			var d = tilePosition - previousPosition
			var previousKillCount = itemsKilledThisTurn.size()
			if d == Vector2i.ZERO and not pickingUp: #return to previous position
				tileItem["piece"] = currentPieceInPlayerHand
				print("returning :", tilePosition)
				currentPieceInPlayerHand = null
				currentPlayer.showPieceInHand = false
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
			elif previousPosition and (isValidPosition(tileItem,tilePosition, previousPosition, currentPieceInPlayerHand)): #  or d == Vector2i.ZERO)
				var killsThisTurn = itemsKilledThisTurn.size() -previousKillCount
				updateBoardFromKills()
				tileItem["piece"] = currentPieceInPlayerHand
				print("placing :", tilePosition)
				currentPieceInPlayerHand = null
				currentPlayer.showPieceInHand = false
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoard(BoardDictionary)
				if killsThisTurn == 0 or not canMoveAgain(tilePosition, tileItem["piece"]):
					changeCurrentPlayer()
			pickingUp = false		
	#pickup
	elif mouseEvent and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
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
	elif event.is_action_pressed("end_turn"):
		changeCurrentPlayer()

func canMoveAgain(tilePosition, currentPieceInPlayerHand):
	
	if BoardDictionary[str(tilePosition)]["color"] != "black":
		return
	var canGoUp 
	var canGoDown
	var delta = tilePosition - previousPosition
	if currentPieceInPlayerHand.color == "red":
		canGoDown = true
		canGoUp =  currentPieceInPlayerHand.kinged
	else:
		canGoDown =  currentPieceInPlayerHand.kinged
		canGoUp = true
	if canGoUp:
		#Check next two Tiles, because next move HAS to be a jump to be valid
		var leftTile = BoardDictionary[str(tilePosition + Vector2i(LEFT,UP))]
		var left2Tile = BoardDictionary[str(tilePosition + 2*Vector2i(LEFT,UP))]
		
		var rightTile = BoardDictionary[str(tilePosition + Vector2i(RIGHT,UP))]
		var right2Tile =BoardDictionary[str(tilePosition + 2*Vector2i(RIGHT,UP))]
		
		if checkJump(left2Tile, leftTile) or checkJump(right2Tile, rightTile):
			return true
	if canGoDown:
		#Check next two Tiles, because next move HAS to be a jump to be valid
		var leftTile = BoardDictionary[str(tilePosition + Vector2i(LEFT,DOWN))]
		var left2Tile = BoardDictionary[str(tilePosition + 2*Vector2i(LEFT,DOWN))]
		
		var rightTile = BoardDictionary[str(tilePosition + Vector2i(RIGHT,DOWN))]
		var right2Tile =BoardDictionary[str(tilePosition + 2*Vector2i(RIGHT,DOWN))]
		
		if checkJump(left2Tile, leftTile) or checkJump(right2Tile, rightTile):
			return true
	return false
func checkJump(targetTile, inBetweenTile):
	
	if targetTile["piece"] == null and inBetweenTile["piece"] and inBetweenTile["piece"].color != currentPieceInPlayerHand.color:
		return true
	return false
func isValidPosition(tile,tilePosition, previousPosition,  piece):
	var itemsToKill = []
	if tile["color"] != "black":
		return
	var canGoUp 
	var canGoDown
	var delta = tilePosition - previousPosition
	if piece.color == "red":
		canGoDown = true
		canGoUp =  piece.kinged
	else:
		canGoDown =  piece.kinged
		canGoUp = true
	print ("Delta : ", delta)
	print ("Delta/1 : ", delta/Vector2i.ONE)
	if abs(delta.x) == abs(delta.y): #we have a linear vector
		var yDirection =0 #this should be a number between -1 UP and 1 DDOWN representing the y of the delta
		var xDirection = 0#this should be a number between -1 LEFT and 1 RIGHT representing the x of the delta
		if delta.y > 0:
			yDirection = DOWN
		elif delta.y < 0:
			yDirection = UP
		if delta.x > 0:
			xDirection = RIGHT
		elif delta.x < 0:
			xDirection = LEFT
				
		print("direction x", xDirection, "direction y", yDirection)
		print("LENGTH ", delta.y)
		#we need to iterate over LENGHT in the vector to ensure if oppisite color, space, repeat
		if(yDirection == DOWN and canGoDown):
			for i in abs(delta.y):
				var iteration = i+1
				var postitionToCheck:Vector2i = Vector2i(previousPosition.x +  xDirection * iteration, previousPosition.y + yDirection * iteration) ## tthis is wrong, bring the intial position pback into this function
				var tileToCheck = BoardDictionary[str(postitionToCheck)]
				if i == 0 and abs(delta) == Vector2i.ONE and itemsKilledThisTurn.size() == 0: #we can only move one position if its not a jump
					if tileToCheck["piece"] != null:
						return false
				elif iteration % 2 == 0:
					if tileToCheck["piece"] != null:
						print("needs to be blank")
						return false
				else:
					if tileToCheck["piece"] == null:
						print("needs to have ennemy")
						return false
					itemsKilledThisTurn.append(postitionToCheck)
					print("Killing ", postitionToCheck)
		elif  (yDirection == UP and canGoUp):
			for i in abs(delta.y):
				var iteration = i+1
				var postitionToCheck:Vector2i = Vector2i(previousPosition.x +  xDirection * iteration, previousPosition.y + yDirection * iteration) ## tthis is wrong, bring the intial position pback into this function
				var tileToCheck = BoardDictionary[str(postitionToCheck)]
				if i == 0 and abs(delta) == Vector2i.ONE:
					if tileToCheck["piece"] != null:
						return false
				elif iteration % 2 == 0:
					if tileToCheck["piece"] != null:
						print("needs to be blank")
						return false
				else:
					if tileToCheck["piece"] == null:
						print("needs to have ennemy")
						return false
					itemsToKill.append(postitionToCheck)
					print("Killing ", postitionToCheck)
		else:
			return false
	itemsKilledThisTurn.append_array(itemsToKill)
	return true

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
	itemsKilledThisTurn = []
	currentPlayer.showPieceInHand = false
	currentPlayer.currentTurn = false
	if currentPlayer == $RedPlayer:
		currentPlayer = $BlackPlayer
	else:
		currentPlayer = $RedPlayer
	currentPlayer.currentTurn = true
	print("Go ", currentPlayer.color)


func updateBoardFromKills():
	for kill in itemsKilledThisTurn:
		var tile = BoardDictionary[str(kill)]
		
		var piece:Piece = tile["piece"]
		if piece: #maybe deleted on the last move
			if piece.color == currentPlayer.color:
				print ("WTFFFFF")
			else:
				BoardDictionary[str(kill)]["piece"] = null
