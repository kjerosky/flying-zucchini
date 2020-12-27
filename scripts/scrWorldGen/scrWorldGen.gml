function generateWorld() {
	var worldTilesId = layer_get_id("WorldTiles");
	var worldTilemapId = layer_tilemap_get_id(worldTilesId);
	
	var collisionTilesId = layer_get_id("CollisionTiles");
	var collisionTilemapId = layer_tilemap_get_id(collisionTilesId);
	
	var horizontalTileCount = tilemap_get_width(worldTilemapId);
	var verticalTileCount = tilemap_get_height(worldTilemapId);
	for (var yy = 0; yy < verticalTileCount; yy++) {
		for (var xx = 0; xx < horizontalTileCount; xx++) {
			var worldTileIndex = irandom_range(1, 5);
			tilemap_set(worldTilemapId, worldTileIndex, xx, yy);
			
			
			// Setup collisions on trees and treasure chests only.
			var collisionTileIndex = 0;
			if (worldTileIndex == 3 || worldTileIndex == 5) {
				collisionTileIndex = 1;
			}
			tilemap_set(collisionTilemapId, collisionTileIndex, xx, yy);
		}
	}
}
