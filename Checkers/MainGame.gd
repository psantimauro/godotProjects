extends Node2D

@onready var currentPlayer = $RedPlayer
@export var piece:PackedScene
var currentPieceInPlayerHand:Piece = null
var previousPosition = null

var GridSize = 8
var BoardDictionary = {}
enum {LEFT = -1, RIGHT = 1}
enum {UP = -1, DOWN = 1}

var itemsKilledThisTurn: Array[Vector2i] = []
var promoteToKing = false

func _ready():
	generateBoard()
	intializePlayerPieces()
	$TileMap.updateBoard(BoardDictionary)
	currentPlayer.currentTurn = true
	print("Go ", currentPlayer.color)

func _input(event):
	
	var tilePosition = $TileMap.getLocal( get_global_mouse_position())
	var mouseEvent = event as InputEventMouseButton
	
	#place
	if mouseEvent and !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and !mouseEvent.pressed:
		if BoardDictionary.has(str(tilePosition)) and currentPieceInPlayerHand != null:
			var tileItem = BoardDictionary[str(tilePosition)]
			var d = tilePosition - previousPosition
			var previousKillCount = itemsKilledThisTurn.size()
			if d == Vector2i.ZERO : #return to previous position
				tileItem["piece"] = currentPieceInPlayerHand
				print("returning :", tilePosition)
				currentPieceInPlayerHand = null
				currentPlayer.showPieceInHand = false
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoardCell(tileItem,tilePosition.x, tilePosition.y)
			elif previousPosition and (isValidMove(tileItem,tilePosition, previousPosition, currentPieceInPlayerHand)): #  or d == Vector2i.ZERO)
				var killsThisTurn = itemsKilledThisTurn.size() -previousKillCount #populated by isValidMove above
				updateBoardDictionaryFromKills()
				if promoteToKing:
					currentPieceInPlayerHand.kinged = true
					promoteToKing = false
				tileItem["piece"] = currentPieceInPlayerHand
				print("placing :", tilePosition)
				currentPlayer.showPieceInHand = false
				BoardDictionary[str(tilePosition)] = tileItem
				$TileMap.updateBoard(BoardDictionary)
				if killsThisTurn == 0 or not canMoveAgain(tilePosition, tileItem["piece"]):
					changeCurrentPlayer()
				currentPieceInPlayerHand = null
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
		if checkJump(tilePosition + 2*Vector2i(LEFT,UP), tilePosition + Vector2i(LEFT,UP)) or checkJump(tilePosition + 2*Vector2i(RIGHT,UP), tilePosition + Vector2i(RIGHT,UP)):
			return true
	if canGoDown:
		#Check next two Tiles, because next move HAS to be a jump to be valid		
		if checkJump(tilePosition + 2*Vector2i(LEFT,DOWN), tilePosition + Vector2i(LEFT,DOWN)) or checkJump(tilePosition + 2*Vector2i(RIGHT,DOWN), tilePosition + Vector2i(RIGHT,DOWN)):
			return true
	return false
func checkJump(targetTilePosition, inBetweenTilePosition):
	if !isVectorInGrid(targetTilePosition) or !isVectorInGrid(inBetweenTilePosition):
		return false
		
	var targetTile = BoardDictionary[str(targetTilePosition)]
	var inBetweenTile = BoardDictionary[str(inBetweenTilePosition)]
	var inBetweenPiece:Piece = inBetweenTile["piece"]
	if targetTile["piece"] == null and inBetweenPiece and inBetweenPiece.color != currentPieceInPlayerHand.color:
		return true
	return false
	
func isVectorInGrid(vector:Vector2i):
	if vector.x < 0 or vector.y < 0:
		return false
	if vector.x >= GridSize or vector.y >= GridSize:
		return false
	return true
func isValidMove(tile,targetPosition, originalPosition,  piece):
	var itemsToKill = []
	var delta = targetPosition - originalPosition
	if tile["color"] != "black":
		return false
	if abs(delta.x) != abs(delta.y): 
		return false
	var canGoUp 
	var canGoDown
	if piece.color == "red":
		canGoDown = true
		canGoUp =  piece.kinged
	else:
		canGoDown =  piece.kinged
		canGoUp = true
	
	var yDirection = 0 #this should be a number between -1 UP and 1 DDOWN representing the y of the delta
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
		var iteration = 0
		for i in abs(delta.y):
			iteration = i+1
			var postitionToCheck:Vector2i = Vector2i(originalPosition.x +  xDirection * iteration, originalPosition.y + yDirection * iteration) ## tthis is wrong, bring the intial position pback into this function
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
				itemsToKill.append(postitionToCheck)
				print("Killing ", postitionToCheck)
		#check if we should be kinged
		if originalPosition.y + iteration * yDirection == GridSize -1:
			print("King Me- Red")
			promoteToKing = true
	elif  (yDirection == UP and canGoUp):
		var iteration
		for i in abs(delta.y):
			iteration = i+1
			var postitionToCheck:Vector2i = Vector2i(originalPosition.x +  xDirection * iteration, originalPosition.y + yDirection * iteration) ## tthis is wrong, bring the intial position pback into this function
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
					#check if we should be kinged
		if  originalPosition.y + iteration * yDirection == 0 :
			print("King Me- Black")
			promoteToKing = true
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
					var p:Piece = piece.instantiate()
					if  y < 3: # add red
						p.color = "red"
						add_child(p)
						boardItem["piece"] = p
					if y > 4:
						p.color = "black"
						add_child(p)
						boardItem["piece"] = p
					BoardDictionary[str(gridLocation)] = boardItem	

func changeCurrentPlayer():
	promoteToKing = false
	itemsKilledThisTurn = []
	currentPlayer.showPieceInHand = false
	currentPlayer.currentTurn = false
	if currentPlayer == $RedPlayer:
		currentPlayer = $BlackPlayer
	else:
		currentPlayer = $RedPlayer
	currentPlayer.currentTurn = true
	print("Go ", currentPlayer.color)


func updateBoardDictionaryFromKills():
	for kill in itemsKilledThisTurn:
		var tile = BoardDictionary[str(kill)]
		
		var piece:Piece = tile["piece"]
		if piece: #maybe deleted on the last move
			if piece.color == currentPlayer.color:
				print ("WTFFFFF")
			else:
				BoardDictionary[str(kill)]["piece"] = null
