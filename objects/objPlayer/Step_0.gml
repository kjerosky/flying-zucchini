x += keyboard_check(ord("D")) - keyboard_check(ord("A"));
y += keyboard_check(ord("S")) - keyboard_check(ord("W"));

if (keyboard_check_pressed(vk_enter)) {
	room_goto(room == rmMain ? rmWorld : rmMain);
} else if (keyboard_check_pressed(vk_space)) {
	generateWorld();
}
