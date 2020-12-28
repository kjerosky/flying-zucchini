// We position the camera in the end step event because we should do so after all
// movement has completed.

#macro view view_camera[0]

camera_set_view_size(view, VIEW_WIDTH, VIEW_HEIGHT);

if (!instance_exists(oPlayer)) {
	exit;
} else if (x == UNINITIALIZED_CAMERA_PIXEL_POSITION) {
	x = floor(oPlayer.x / VIEW_WIDTH) * VIEW_WIDTH;
	y = floor(oPlayer.y / VIEW_HEIGHT) * VIEW_HEIGHT;
}

var playerSectorX = floor(oPlayer.x / VIEW_WIDTH) * VIEW_WIDTH;
var playerSectorY = floor(oPlayer.y / VIEW_HEIGHT) * VIEW_HEIGHT;

if (x < playerSectorX) {
	x = min(playerSectorX, x + SLIDE_HORIZONTAL_PIXELS_PER_FRAME);
} else if (x > playerSectorX) {
	x = max(playerSectorX, x - SLIDE_HORIZONTAL_PIXELS_PER_FRAME);
}

if (y < playerSectorY) {
	y = min(playerSectorY, y + SLIDE_VERTICAL_PIXELS_PER_FRAME);
} else if (y > playerSectorY) {
	y = max(playerSectorY, y - SLIDE_VERTICAL_PIXELS_PER_FRAME);
}

camera_set_view_pos(view, x, y);
