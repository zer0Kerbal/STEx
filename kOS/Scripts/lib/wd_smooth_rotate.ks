// SGEx (StarGuise Experimental)
// Shamelessly nicked from Rybec via /r/Kos
//
// FILE: 	wd_smooth_rotate.ks
// SUBTYPE:	word (wd_)
// - 
//
// AUTHOR: u/Rybec, zer0Kerbal
// happily swiped (and modified) from: https://www.reddit.com/r/Kos/comments/3ivlz9/
// https://github.com/zer0Kerbal/SGEx/releases
// ——————————————————————————————————————————————————
// status: β 1.0.0.0
// ——————————————————————————————————————————————————
// FOR: SGEx
// ——————————————————————————————————————————————————
// Ω Requires: 
// Ω Requires: 
// ——————————————————————————————————————————————————
// creation: 	
// last update:	
// Cooked steering flailing your craft wildly? PIDs unsuitable? Look no further!

@LAZYGLOBAL off.

FUNCTION smoothRotate {
    PARAMETER dir.
    LOCAL spd IS max(SHIP:ANGULARMOMENTUM:MAG/10,4).
    LOCAL curF IS SHIP:FACING:FOREVECTOR.
    LOCAL curR IS SHIP:FACING:TOPVECTOR.
    LOCAL rotR IS R(0,0,0).
    IF VANG(dir:FOREVECTOR,curF) < 90{SET rotR TO ANGLEAXIS(min(0.5,VANG(dir:TOPVECTOR,curR)/spd),VCRS(curR,dir:TOPVECTOR)).}
    RETURN LOOKDIRUP(ANGLEAXIS(min(2,VANG(dir:FOREVECTOR,curF)/spd),VCRS(curF,dir:FOREVECTOR))*curF,rotR*curR).
}

FUNCTION smoothRotateLong {
    PARAMETER dir.
    LOCAL spd IS max(SHIP:ANGULARMOMENTUM:MAG/10,4).
    LOCAL curF IS SHIP:FACING:FOREVECTOR.
    LOCAL curR IS SHIP:FACING:TOPVECTOR.
    LOCAL dirF IS dir:FOREVECTOR.
    LOCAL dirR IS dir:TOPVECTOR.
    LOCAL axis IS VCRS(curF,dirF).
    LOCAL axisR IS VCRS(curR,dirR).
    LOCAL rotAng IS VANG(dirF,curF)/spd.
    LOCAL rotRAng IS VANG(dirR,curR)/spd.
    LOCAL rot IS ANGLEAXIS(min(2,rotAng),axis).
    LOCAL rotR IS R(0,0,0).
    IF VANG(dirF,curF) < 90{
        SET rotR TO ANGLEAXIS(min(0.5,rotRAng),axisR).
    }
    RETURN LOOKDIRUP(rot*curF,rotR*curR).
}

// Cooked steering flailing your craft wildly? PIDs unsuitable? Look no further!

// EDIT: Now modified for more consistent results across a wider range of vessels; now works well for anything that's not critically undertorqued. EDIT2: FYI, you may need to up your IPU if you use this; LOCK eats into your trigger limit and I've been hitting the 200 IPU limit with pretty simple triggers. I've not yet tried locking to a variable and then setting that variable to smoothRotate(dir) in a main loop yet, as that kinda defeats the point.

// A video showing relative performance on an absurdly extreme example. I wanted to add captions, but I don't have any editors installed right now. :( The craft has so much torque that stock SAS makes it vibrate all over space. Trying to use unaided cooked steering (red line) cannot settle out and wobbles wildly around the target. Using the method outlined below (blue line), everything is butter smooth and precisely controlled with negligible overshoot.

 

// For those who have somehow not noticed, cooked steering hates you and everything you stands for if you have too much reaction torque for the mass of your vessel, or just want to make a turn that's too far (and in general, really). This is most noticeable on very small/light spacecraft, where the built-in reaction torque on probe cores are rather excessive for their mass. Even if you somehow reduce the reaction torque (there's a mod for that!), tiny craft still don't like to settle out and will wobble about the direction to which you LOCK STEERING.

// Until now, the only real publicly vetted way of dealing with this is to write a PID based solution, but a PID library can be over a kilobyte if you don't compress it by sucking all the whitespace out and use short variable names. If you're like me and you like to work within the volume space limits as much as possible, that's a fifth of your capacity gone just to steer, not including the code you have to add to setup and operate three (four, with throttle) seperate PIDs. Oh, and you have to tune them, and the tuning is different for each craft.

 

// Enter smoothRotate():

// For a measly 463 characters, you too can combine the convenience of cooked steering with actual functioning orientation. Anywhere you LOCK STEERING TO DIRECTION, simply LOCK STEERING TO smoothRotate(DIRECTION) instead! Note that smoothRotate takes a direction and will not accept a vector. If you're trying to aim at a vector (say, NEXTNODE:DV), simply add :DIRECTION to the end of it! Your craft design is irrelevant. Tuning is irrelevant. smoothRotate() doesn't have time for that.

 

// "But Rybec, how does it work? What is the true source of your magic? It still uses cooked steering!"

// A magician never reveals his...

// Ahem, that is.. Instead of passing your desired aim direction directly, it finds a direction close to your current orientation that's along the shortest path between where you are and where you want to be. It has an angle limit determined by your craft's mass (since heavy craft also tend to wobble a lot due to high rotational inertia. Paired with excessive torque, game over). It also never tries to aim more than 1/4 the total distance, which provides an extra dampening effect when you reach the setpoint. This effectively eliminates wobble even on the ridiculous over-torqued tiny test ships I've tried (see video). Because it only tries to rotate a certain amount per tick, once it's up to rotation speed the control inputs null out until it needs to stop (20 - 0.1* mass degrees/second, with a lower cap of 5 deg/s, you may want to make this a parameter depending on your exact usage. Mass formula subject to tuning.). So not only does it move in mostly a straight line from A to B, it does so very efficiently. Even craft that are relatively stable and responsive under basic cooked steering still receive an efficiency benefit, and as the video shows this function will even tame nonsensical creations that cannot be controlled by mortal men. (no really, hold A for ~three seconds and Jeb gets liquefied by the 60+G of centrifugal force. I think if I added a decoupler I could launch the pod to Duna just by spinning.)

// It's still not perfect, in my testing I saw that very very large craft (200+ tons on my specific test) with more torque than they actually need can still have a bit of roll wobble due to high angular momentum even at low speed. A better solution would factor in the craft's rotational inertia instead of it's mass and set different speed limits or damping divisors for pitch/yaw vs roll. I've not quite figured out how to do this yet, and it may need more extra code than I'm comfortable with. The point of this is to be lightweight, and as-is it should work with most sensible spacecraft designs.

// As it is though, using smoothRotate, you can set a goal condition of 0.05 degrees from target and 0.001 angular velocity and actually expect it to get and stay there. (provided, of course, your desired direction is moving slower than that, in the case of PROGRADE, etc).

// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————

// v 0.0.0.1
	// creation by zer0Kerbal
	// uploaded WIP to GitHub
	// CC 4.0 BY-NC-SA
	
//
// Copyright © 2017-2018, zer0Kerbal and StarGuise Experimental (SGEx)
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice,
//    this list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
//    this list of conditions and the following disclaimer in the documentation and/or other
//    materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// Used under a Creative Commons Attribution-ShareAlike 3.0 Unported License.
// 
