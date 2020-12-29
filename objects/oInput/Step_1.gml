moveX = keyboard_check(ord("D")) - keyboard_check(ord("A"));
moveY = keyboard_check(ord("S")) - keyboard_check(ord("W"));

if (keyboard_check_pressed(ord("J"))) {
	moveX = -1;
	moveY = 0;
} else if (keyboard_check_pressed(ord("L"))) {
	moveX = 1;
	moveY = 0;
} else if (keyboard_check_pressed(ord("I"))) {
	moveX = 0;
	moveY = -1;
} else if (keyboard_check_pressed(188)) {
	moveX = 0;
	moveY = 1;
} else if (keyboard_check_pressed(ord("U"))) {
	moveX = -1;
	moveY = -1;
} else if (keyboard_check_pressed(ord("O"))) {
	moveX = 1;
	moveY = -1;
} else if (keyboard_check_pressed(ord("M"))) {
	moveX = -1;
	moveY = 1;
} else if (keyboard_check_pressed(190)) {
	moveX = 1;
	moveY = 1;
}

if (point_distance(0, 0, moveX, moveY) > 1) {
	var moveDirection = point_direction(0, 0, moveX, moveY);
	moveX = lengthdir_x(1, moveDirection);
	moveY = lengthdir_y(1, moveDirection);
}

swapLevelPressed = keyboard_check_pressed(vk_enter);
generateWorldPressed = keyboard_check_pressed(vk_space);
