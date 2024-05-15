extends TileMap

var GridSize = 8
var BoardDictionary = {}
enum  {RED = 0, BLACK = 2}


var RED_TILE = Vector2i(0,0)
var BLACK_TILE =  Vector2i(2,0)

var RED_PIECE  = Vector2i(0,0)
var BLACK_PIECE = Vector2i(1,0)
var RED_PIECE_KINGED  = Vector2i(0,1)
var BLACK_PIECE_KINGED = Vector2i(1,1)

func updateBoardCell(item, x, y):
	var location = Vector2(x,y)
	var idx = str(location)
	var tileColor = item["color"]
	var piece = item["piece"]
			
	var tile
	if tileColor == "red":
			tile = RED_TILE
	if tileColor == "black":
			tile = BLACK_TILE
	set_cell(0,location,0,tile,0)
	
	erase_cell(1,location)
	if piece != null: 
		var pieceLocation = null
		if piece == "red":
			pieceLocation = RED_PIECE
		if piece == "red_kinged":
			pieceLocation = RED_PIECE_KINGED
		if piece == "black":
			pieceLocation = BLACK_PIECE
		if piece == "black_kinged":
			pieceLocation = BLACK_PIECE_KINGED
		if pieceLocation != null:
			set_cell(1,location,1,pieceLocation,0)
			
func updateBoard(boardDict):
	for x in GridSize:
		for y in GridSize:
			var location = Vector2(x,y)
			var idx = str(location)
			var item = boardDict[idx]
			updateBoardCell(item,x,y)

func getLocal(position):
	return local_to_map(position)		
