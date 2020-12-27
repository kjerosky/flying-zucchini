if (keyboard_check_pressed(vk_enter)) {
	room_goto(room == rmMain ? rmWorld : rmMain);
} else if (keyboard_check_pressed(vk_space)) {
	generateWorld();
}

var xInput = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var yInput = keyboard_check(ord("S")) - keyboard_check(ord("W"));
if (keyboard_check_pressed(ord("J"))) {
	xInput = -1;
	yInput = 0;
} else if (keyboard_check_pressed(ord("L"))) {
	xInput = 1;
	yInput = 0;
} else if (keyboard_check_pressed(ord("I"))) {
	xInput = 0;
	yInput = -1;
} else if (keyboard_check_pressed(188)) {
	xInput = 0;
	yInput = 1;
} else if (keyboard_check_pressed(ord("U"))) {
	xInput = -1;
	yInput = -1;
} else if (keyboard_check_pressed(ord("O"))) {
	xInput = 1;
	yInput = -1;
} else if (keyboard_check_pressed(ord("M"))) {
	xInput = -1;
	yInput = 1;
} else if (keyboard_check_pressed(190)) {
	xInput = 1;
	yInput = 1;
}

var xSpeed = xInput * PLAYER_SPEED;
var ySpeed = yInput * PLAYER_SPEED;

var collisionLayerId = layer_get_id("CollisionTiles");
var collisionTileMap = layer_tilemap_get_id(collisionLayerId);

if (tilemap_get_at_pixel(collisionTileMap, x + xSpeed, y)) {
	x -= x mod TILE_LENGTH;
	if (sign(xSpeed) == 1) {
		x += TILE_LENGTH - 1;
	}
	xSpeed = 0;
}

if (tilemap_get_at_pixel(collisionTileMap, x, y + ySpeed)) {
	y -= y mod TILE_LENGTH;
	if (sign(ySpeed) == 1) {
		y += TILE_LENGTH - 1;
	}
	ySpeed = 0;
}

x += xSpeed;
y += ySpeed;
