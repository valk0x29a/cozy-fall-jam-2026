class_name CollisionComponent
extends Node

@export_group("Detection Settings")
@export var collision_offset_pixels: float = 2.0


func get_physical_collision_data(character_body: CharacterBody2D, tile_map_layer: TileMapLayer) -> PhysicalCollisionData:
	var physical_collision_data: PhysicalCollisionData = PhysicalCollisionData.new()

	if not character_body or not tile_map_layer:
		return physical_collision_data

	for collision_index in character_body.get_slide_collision_count():
		var kinematic_collision: KinematicCollision2D = character_body.get_slide_collision(collision_index)
		var collided_layer: Object = kinematic_collision.get_collider() as TileMapLayer
		if collided_layer != tile_map_layer:
			continue

		var collision_point: Vector2 = kinematic_collision.get_position() - (kinematic_collision.get_normal() * collision_offset_pixels)
		var local_position: Vector2 = tile_map_layer.to_local(collision_point)
		var map_cell: Vector2i = tile_map_layer.local_to_map(local_position)
		var tile_data: TileData = tile_map_layer.get_cell_tile_data(map_cell)

		if tile_data:
			physical_collision_data.is_hazard = physical_collision_data.is_hazard or bool(tile_data.get_custom_data("is_hazard"))
			physical_collision_data.is_win = physical_collision_data.is_win or bool(tile_data.get_custom_data("is_win"))

	return physical_collision_data


func get_logical_collision_data(character_body: CharacterBody2D, tile_map_layer: TileMapLayer) -> LogicalCollisionData:
	var logical_collision_data: LogicalCollisionData = LogicalCollisionData.new()

	if not character_body or not tile_map_layer:
		return logical_collision_data

	var collision_shape_node: CollisionShape2D = _find_collision_shape(character_body)
	if not collision_shape_node:
		return logical_collision_data

	var logical_tiles_list: Array[TileData] = _get_tiles_under_shape(tile_map_layer, collision_shape_node)
	for tile_data in logical_tiles_list:
		if tile_data.get_custom_data("is_water"):
			logical_collision_data.is_water = true

		var gust_direction_data: Variant = tile_data.get_custom_data("gust_direction")
		if gust_direction_data is Vector2:
			logical_collision_data.gust_direction += gust_direction_data

		var waterfall_direction_data: Variant = tile_data.get_custom_data("waterfall_direction")
		if waterfall_direction_data is Vector2:
			logical_collision_data.waterfall_direction += waterfall_direction_data

	return logical_collision_data


func _get_tiles_under_shape(target_tile_map: TileMapLayer, shape_node: CollisionShape2D) -> Array[TileData]:
	var tiles_list: Array[TileData] = []
	if not shape_node or not shape_node.shape:
		return tiles_list

	var shape_rectangle: Rect2 = shape_node.shape.get_rect()
	var global_position_offset: Vector2 = shape_node.global_position

	var top_left_global: Vector2 = global_position_offset + shape_rectangle.position
	var bottom_right_global: Vector2 = global_position_offset + shape_rectangle.end

	var top_left_cell: Vector2i = target_tile_map.local_to_map(target_tile_map.to_local(top_left_global))
	var bottom_right_cell: Vector2i = target_tile_map.local_to_map(target_tile_map.to_local(bottom_right_global))

	var minimum_x_index: int = mini(top_left_cell.x, bottom_right_cell.x)
	var maximum_x_index: int = maxi(top_left_cell.x, bottom_right_cell.x)
	var minimum_y_index: int = mini(top_left_cell.y, bottom_right_cell.y)
	var maximum_y_index: int = maxi(top_left_cell.y, bottom_right_cell.y)

	for x_coordinate in range(minimum_x_index, maximum_x_index + 1):
		for y_coordinate in range(minimum_y_index, maximum_y_index + 1):
			var cell_position := Vector2i(x_coordinate, y_coordinate)
			var tile_data: TileData = target_tile_map.get_cell_tile_data(cell_position)
			if tile_data:
				tiles_list.append(tile_data)

	return tiles_list


func _find_collision_shape(parent_node: Node) -> CollisionShape2D:
	for child_node in parent_node.get_children():
		if child_node is CollisionShape2D:
			return child_node
	return null
