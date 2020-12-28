if (oInput.swapLevelPressed) {
	room_goto(room == rmMain ? rmWorld : rmMain);
} else if (oInput.generateWorldPressed) {
	generateWorld();
}

var xInput = oInput.moveX;
var yInput = oInput.moveY;

var inputDirection = point_direction(0, 0, xInput, yInput);
var xSpeed = xInput != 0 ? lengthdir_x(PLAYER_SPEED, inputDirection) : 0;
var ySpeed = yInput != 0 ? lengthdir_y(PLAYER_SPEED, inputDirection) : 0;

var collisionLayerId = layer_get_id("CollisionTiles");
var collisionTileMap = layer_tilemap_get_id(collisionLayerId);

// If we don't use floor/ceiling when checking collisions along an axis,
// the sprite might be drawn overlapping a collision region.
//
// Example:
//
//   x = 399, xSpeed = 0.7 xWithMovement = x + xSpeed = 399.7
//
//   The value of xWithMovement will not have a collision detected on
//   pixel 400, but the sprite will be rendered at pixel 400 instead of
//   to the left of it (due to rendering rounding up 399.7 to 400).
var xWithMovement = x + xSpeed;
if (xSpeed < 0) {
	xWithMovement = floor(xWithMovement);
} else if (xSpeed > 0) {
	xWithMovement = ceil(xWithMovement);
}

var yWithMovement = y + ySpeed;
if (ySpeed < 0) {
	yWithMovement = floor(yWithMovement);
} else if (ySpeed > 0) {
	yWithMovement = ceil(yWithMovement);
}

var xHadCollision = false;
var yHadCollision = false;

if (tilemap_get_at_pixel(collisionTileMap, xWithMovement, y)) {
	xHadCollision = true;
}

if (tilemap_get_at_pixel(collisionTileMap, x, yWithMovement)) {
	yHadCollision = true;
}

// The above collision detection cases for the individual axes won't detect a collision that
// occurs diagonally, so we check for that if those other cases don't detect a collision.
if (!xHadCollision && !yHadCollision &&
	xSpeed != 0 && ySpeed != 0 &&
	tilemap_get_at_pixel(collisionTileMap, xWithMovement, yWithMovement)
) {
	// Let's choose to "slide along" the x-axis if a diagonal-only collision occurred,
	// because it's the longer dimension on the screen.
	yHadCollision = true;
}

if (xHadCollision) {
	x -= x mod TILE_LENGTH;
	if (sign(xSpeed) == 1) {
		x += TILE_LENGTH - 1;
	}
	xSpeed = 0;
}

if (yHadCollision) {
	y -= y mod TILE_LENGTH;
	if (sign(ySpeed) == 1) {
		y += TILE_LENGTH - 1;
	}
	ySpeed = 0;
}

x += xSpeed;
y += ySpeed;
