if (oInput.swapLevelPressed) {
	room_goto(room == rmMain ? rmWorld : rmMain);
} else if (oInput.generateWorldPressed) {
	generateWorld();
}

var xInput = oInput.moveX;
var yInput = oInput.moveY;

var xSpeed = xInput * PLAYER_SPEED;
var ySpeed = yInput * PLAYER_SPEED;

var collisionLayerId = layer_get_id("CollisionTiles");
var collisionTileMap = layer_tilemap_get_id(collisionLayerId);

var xCollision = false;
var yCollision = false;

if (tilemap_get_at_pixel(collisionTileMap, x + xSpeed, y)) {
	xCollision = true;
}

if (tilemap_get_at_pixel(collisionTileMap, x, y + ySpeed)) {
	yCollision = true;
}

// The above collision detection cases for the individual axes won't detect a collision that
// occurs diagonally, so we check for that if those other cases don't detect a collision.
if (!xCollision && !yCollision &&
	xSpeed != 0 && ySpeed != 0 &&
	tilemap_get_at_pixel(collisionTileMap, x + xSpeed, y + ySpeed)
) {
	// Let's choose to "slide along" the x-axis if a diagonal collision occurred,
	// because it's the longer dimension on the screen.
	yCollision = true;
}

if (xCollision) {
	x -= x mod TILE_LENGTH;
	if (sign(xSpeed) == 1) {
		x += TILE_LENGTH - 1;
	}
	xSpeed = 0;
}

if (yCollision) {
	y -= y mod TILE_LENGTH;
	if (sign(ySpeed) == 1) {
		y += TILE_LENGTH - 1;
	}
	ySpeed = 0;
}

x += xSpeed;
y += ySpeed;
