// We position the camera in the end step event because we should do so after all
// movement has completed.

#macro view view_camera[0]

camera_set_view_size(view, viewWidth, viewHeight);

if (instance_exists(objPlayer)) {
	var currentSectorX = floor(objPlayer.x / viewWidth) * viewWidth;
	var currentSectorY = floor(objPlayer.y / viewHeight) * viewHeight;
	camera_set_view_pos(view, currentSectorX, currentSectorY);
}
