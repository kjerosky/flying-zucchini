if (oInput.swapLevelPressed) {
	room_goto(room == rmMain ? rmWorld : rmMain);
} else if (oInput.generateWorldPressed) {
	generateWorld();
}

var xInput = oInput.moveX;
var yInput = oInput.moveY;
var inputMagnitude = point_distance(0, 0, xInput, yInput);

var xSpeed = WALK_SPEED * xInput;
var ySpeed = WALK_SPEED * yInput;

var roomLeftX = floor(x / SECTOR_WIDTH) * SECTOR_WIDTH;
var roomRightX = roomLeftX + SECTOR_WIDTH;
var roomTopY = floor(y / SECTOR_HEIGHT) * SECTOR_HEIGHT;
var roomBottomY = roomTopY + SECTOR_HEIGHT;

var isNearLeftSectorEdge = x < roomLeftX + TILE_LENGTH / 2;
var isNearRightSectorEdge = x > roomRightX - TILE_LENGTH / 2;
var isNearTopSectorEdge = y < roomTopY + TILE_LENGTH;
var isNearBottomSectorEdge = y > roomBottomY - TILE_LENGTH / 8;
var isNearSectorEdge =
	isNearLeftSectorEdge ||
	isNearRightSectorEdge ||
	isNearTopSectorEdge ||
	isNearBottomSectorEdge;

if (state == PlayerState.IDLE && inputMagnitude != 0) {
	state = PlayerState.WALKING;
} else if (state == PlayerState.WALKING && inputMagnitude == 0) {
	state = PlayerState.IDLE;
} else if ((state == PlayerState.IDLE || state == PlayerState.WALKING) && isNearSectorEdge) {
	state = PlayerState.MOVING_TO_NEXT_ROOM;

	if (isNearLeftSectorEdge) {
		nextRoomMoveAmountX = -TILE_LENGTH * 1.5 / oCamera.SLIDE_TOTAL_FRAMES;
		nextRoomMoveAmountY = 0;
		nextRoomMoveFramesRemaining = oCamera.SLIDE_TOTAL_FRAMES + (x - roomLeftX) / (-nextRoomMoveAmountX);
		middleOctant = 4;
	} else if (isNearRightSectorEdge) {
		nextRoomMoveAmountX = TILE_LENGTH * 1.5 / oCamera.SLIDE_TOTAL_FRAMES;
		nextRoomMoveAmountY = 0;
		nextRoomMoveFramesRemaining = oCamera.SLIDE_TOTAL_FRAMES + (roomLeftX + SECTOR_WIDTH - x) / nextRoomMoveAmountX;
		middleOctant = 0;
	} else if (isNearTopSectorEdge) {
		nextRoomMoveAmountX = 0;
		nextRoomMoveAmountY = -TILE_LENGTH / oCamera.SLIDE_TOTAL_FRAMES;
		nextRoomMoveFramesRemaining = oCamera.SLIDE_TOTAL_FRAMES + (y - roomTopY) / (-nextRoomMoveAmountY);
		middleOctant = 2;
	} else {
		nextRoomMoveAmountX = 0;
		nextRoomMoveAmountY = TILE_LENGTH * 2 / oCamera.SLIDE_TOTAL_FRAMES;
		nextRoomMoveFramesRemaining = oCamera.SLIDE_TOTAL_FRAMES + (roomTopY + SECTOR_HEIGHT - y) / nextRoomMoveAmountY;
		middleOctant = 6;
	}
	lowerOctant = middleOctant == 0 ? 7 : middleOctant - 1
	higherOctant = middleOctant + 1;
} else if (state == PlayerState.MOVING_TO_NEXT_ROOM && nextRoomMoveFramesRemaining <= 0) {
	state = PlayerState.IDLE;
}

var oldSpriteIndex = sprite_index;
switch (state) {
	case PlayerState.IDLE: {
		sprite_index = spriteIdle;
	} break;

	case PlayerState.WALKING: {
		sprite_index = spriteWalk;

		var inputDirection = point_direction(0, 0, xInput, yInput);
		var currentOctant = floor(((inputDirection + 22.5) % 360) / 45);
		if (currentOctant != lowerOctant && currentOctant != middleOctant && currentOctant != higherOctant) {
			if (currentOctant >= 3 && currentOctant <= 5) {
				middleOctant = 4;
			} else if (currentOctant == 2 || currentOctant == 6) {
				middleOctant = currentOctant;
			} else {
				middleOctant = 0;
			}

			lowerOctant = middleOctant == 0 ? 7 : middleOctant - 1
			higherOctant = middleOctant + 1;
		}

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
			x -= x % TILE_LENGTH;
			if (sign(xSpeed) == 1) {
				x += TILE_LENGTH - 1;
			}
			xSpeed = 0;
		}

		if (yHadCollision) {
			y -= y % TILE_LENGTH;
			if (sign(ySpeed) == 1) {
				y += TILE_LENGTH - 1;
			}
			ySpeed = 0;
		}

		x += xSpeed;
		y += ySpeed;
	} break;

	case PlayerState.MOVING_TO_NEXT_ROOM: {
		sprite_index = spriteWalk;

		nextRoomMoveFramesRemaining--;
		x += nextRoomMoveAmountX;
		y += nextRoomMoveAmountY;
	} break;
}

if (oldSpriteIndex != sprite_index) {
	localFrame = 0;
}

var facingDirection = middleOctant / 2;
var totalFrames = sprite_get_number(sprite_index) / 4;
image_index = (facingDirection * totalFrames) + localFrame;

localFrame += sprite_get_speed(sprite_index) / game_get_speed(gamespeed_fps);
if (localFrame >= totalFrames) {
	localFrame -= totalFrames;
}
