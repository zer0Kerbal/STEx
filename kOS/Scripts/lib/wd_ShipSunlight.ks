// SGEx (StarGuise Experimental)
// Shamelessly nicked from legnad1
// via: /r/Kos/comments/7a3xbn/calculate_if_your_ship_is_in_darkness_to_its/
//
// FILE: 	wd_ShipSunlight.ks
// SUBTYPE:	word (wd_)
// - 
//
// AUTHOR: zer0Kerbal
// https://github.com/zer0Kerbal/SGEx/releases
// ——————————————————————————————————————————————————
// status: β 1.0.0.0
// ——————————————————————————————————————————————————
// FOR: SGEx
// ——————————————————————————————————————————————————
// Ω Requires: kOS
// Ω Requires: Kerbal Space Program
// ——————————————————————————————————————————————————
// creation: 	
// last update:	
// Calculate If your Ship is in darkness to its ORBIT:BODY
//This short script detemines wether your Ship is in darkness or sunlight (respective to the parent body - it does not take into account moons or other bodies - ONLY the parent body).
// https://pastebin.com/iby5awyG

@LAZYGLOBAL off.
function ktc_ship_sunlight {
    parameter AtUT is TIME:SECONDS.
    SET vec_ship TO SHIP:POSITION.
    SET vec_ship_future TO POSITIONAT(SHIP,atut).
   
    SET vec_ship_sun TO POSITIONAT(BODY("SUN"), TIME:SECONDS).
    SET vec_ship_body TO POSITIONAT(ORBIT:BODY, TIME:SECONDS).
   
    SET vec_ship_future_body TO -vec_ship_body + vec_ship_future.
    SET vec_ship_future_sun TO -vec_ship_sun + vec_ship_future.
   
    SET vec_sun_body TO -vec_ship_sun + vec_ship_body.
   
    SET shade_angle TO arctan(ORBIT:BODY:RADIUS/vec_sun_body:MAG).
    IF (VANG(vec_sun_body,vec_ship_future_sun) < shade_angle)
        AND (vec_ship_future_sun:MAG > vec_sun_body:MAG)
    {
        SET sunlight TO false.
    } ELSE {
        SET sunlight TO true.
    }
    return sunlight.
}

// TODO:
// nuggreat
// I am fairly positive you should be using arcSin not arcTan because the radius  is the opposite side to of the angle you want to find for the shadow and because your second distance is from the sun to the body it is the hypotenuse not the adjacent side of the angle you want.
// The reasoning for this is that the line that defines the cross from between shadow and light it tangent (90 degrees) to the radius of the body. So the angle between the line from the sun to the body and the radius must be less than 90 degrees making the line from the sun to the body the hypotenuse not the adjacent side.
// Admittedly the angle between the line from the sun to the body and the radius is so close to 90 degrees the inaccuracy is basically 0 but it is still incorrect and for bodies closer to the sun the use of arcTan would be less accurate.

// v 0.0.0.1
	// creation by zer0Kerbal
	// License (s.i.c.)
	
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
