extends Sprite2D


var p = -1

func setRed():
	p = 0
	
func setBlack():
	p = 1

func setKinged():
	if p > -1:
		p += 2
		
func updateSprite():
	if p > -1:
		self.frame = p
