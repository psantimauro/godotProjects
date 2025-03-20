Location: Board\TileScense\BuildingTiles\, TileSet's scense

Passively provides some output, or value.

Have a cost to build including [[Resources]] and [[Time]]

The first building to be available is  [[Tent]]
A second building is currently a [[LogCabin]]

Root node should be a Node2d linked to buildingbase.gd
![[Building Node Tree.png]]
Buildings have the following child nodes:
 - Sprite2d/Icon Image
 - [[Research]] Container
	 - UI for Available Research
 - [[ResearchController]]
	 - holds the running techs
 - [[Work]] Container
	 - UI for Available Jobs
 - [[JobsController]]
	 - holds the running jobs
 - [[ClickableProgressBar]]
	 - tracks the progress of the assigned item and shows and icon to the player to show what it is working on


