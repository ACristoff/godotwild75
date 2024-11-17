extends TileMapLayer

class_name ExplosionViewOverlay

var cell_offset = Vector2(1, 2)

func draw(cells: Array):
	clear()
	
	for cell in cells:
		set_cell(cell + cell_offset, 0, Vector2i(0,0))
