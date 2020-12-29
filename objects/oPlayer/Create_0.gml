enum PlayerState {
	IDLE,
	WALKING,
	MOVING_TO_NEXT_ROOM
};
state = PlayerState.IDLE;

WALK_SPEED = 1;

spriteIdle = sPlayerIdle;
spriteWalk = sPlayerWalk;
localFrame = 0;

image_speed = 0;

lowerOctant = 5;
middleOctant = 6;
higherOctant = 7;

nextRoomMoveAmountX = -1;
nextRoomMoveAmountY = -1;
nextRoomMoveFramesRemaining = -1;
