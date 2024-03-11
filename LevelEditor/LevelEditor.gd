@tool
extends TileMap
class_name LevelEditor

@export var objects: Array[ObjectData] = []

const OBJECT_LAYER: int = 0


# Called when the node and it's children enters the scene tree for the first time.
func _ready():
	# Runs in the editor
	if Engine.is_editor_hint():
		print("Created New Level")
		self.tile_set = load("res://LevelEditor/level_editor.tres")
		self.set_layer_name(0, "Level")
	
	if Engine.is_editor_hint(): return
	# Runs during the game
	
	# Extracts entity data from tiles
	for cell in self.get_used_cells(OBJECT_LAYER):  # Returns contents of layer 1
		for object in objects:
			if object.cell == self.get_cell_atlas_coords(OBJECT_LAYER, cell):
				var new_entity: CharacterBody2D = object.scene.instantiate()
				new_entity.global_position = Vector2(cell.x * 16 + 8, cell.y * 16 + 8)
				#if new_entity.get_node("Gun"):
					#if object.weapon:
						#new_entity.get_node("Gun").data = object.weapon

				self.erase_cell(OBJECT_LAYER, cell)
				self.add_child(new_entity)
