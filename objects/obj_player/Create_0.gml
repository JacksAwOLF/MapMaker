/// @description Insert description here


// these values can be played around with

prevX = x;
prevY = y;

horMaxSpd = 4;			// maximum pixels/step horizontally
horAccel = 0.8;			// how speed increases/step when key is pressed
horDccel = 1.2;			// how speed decreases/step when no key is pressed

imgIndCounter = 0;		// counter that increments while moving in a dir
imgIndCounterSpd = 0.5;	// how much prev counter increments/step
image_index = 0;		// initial index of sprite to draw



// for debug purposes
// apparantly the step event runs room_speed times a second
// which is set to 60 by default

//room_speed = 10;




// don't change these values
horSpd = 0;		
image_speed = 0;






