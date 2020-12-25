// We position the camera in the end step event because we should do so after all
// movement has completed.

#macro view view_camera[0]

camera_set_view_size(view, viewWidth, viewHeight);

if (instance_exists(objPlayer)) {
	var targetViewX = clamp(objPlayer.x - viewWidth / 2, 0, room_width - viewWidth);
	var targetViewY = clamp(objPlayer.y - viewHeight / 2, 0, room_height - viewHeight);
	
	var currentViewX = camera_get_view_x(view);
	var currentViewY = camera_get_view_y(view);
	
	// Set this speed to 1 or just set the camera position to the target position
	// to not have any camera movement smoothing.
	var cameraSpeed = 1;
	
	camera_set_view_pos(
		view,
		lerp(currentViewX, targetViewX, cameraSpeed),
		lerp(currentViewY, targetViewY, cameraSpeed)
	);
}
