function generateWorld() {
	var worldTilesId = layer_get_id("WorldTiles");
	var tilemapId = layer_tilemap_get_id(worldTilesId);
	
	for (var yy = 0; yy < tilemap_get_height(tilemapId); yy++) {
		for (var xx = 0; xx < tilemap_get_width(tilemapId); xx++) {
			var tileIndex = irandom_range(1, 5);
			tilemap_set(tilemapId, tileIndex, xx, yy);
		}
	}
}
