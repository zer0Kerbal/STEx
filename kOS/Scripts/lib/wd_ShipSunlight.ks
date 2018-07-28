// SGEx (StarGuise Experimental)
// - 
// FILE: wd_ShipSunlight.ks
// TYPE: word (wd_)
// - 
// Calculate If your ship is in darkness to its ORBIT:BODY
// - 
// Shamelessly nicked from legnad1
// via: /r/Kos/comments/7a3xbn/calculate_if_your_ship_is_in_darkness_to_its/
// - 
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
// creation: 27 Jul 18
// last upd: 27 Jul 18
// - 
// determines if ship is in sunlight (respective to the parent body - it does not take into account moons or other bodies - ONLY the parent body).
// https://pastebin.com/iby5awyG

@LAZYGLOBAL off.
function shipsunlight {
    parameter _now is TIME:SECONDS.
	
	SET sl TO 1.
    SET vShp TO SHIP:POSITION.
    SET vShpFutr TO POSITIONAT(SHIP,_now).
    SET vShpSun TO POSITIONAT(BODY("SUN"), TIME:SECONDS).
    SET vShpBdy TO POSITIONAT(ORBIT:BODY, TIME:SECONDS).
    SET vShpFutrBdy TO -vShpBdy + vShpFutr.
    SET vShpFutrSun TO -vShpSun + vShpFutr.
    SET vSunBdy TO -vShpSun + vShpBdy.
    SET shdAng TO ARCTAN(ORBIT:BODY:RADIUS/vSunBdy:MAG).
	
    IF (VANG(vSunBdy,vShpFutrSun) < shdAng)
        AND (vShpFutrSun:MAG > vSunBdy:MAG)
    { SET sl TO 0. } //ELSE {SET sl TO 1. }
    return sl.
}

// TODO:
// nuggreat
   // use arcSin not arcTan #29
   // raised issue concerning ARCSIN vs ARCTAN #29
   // raised issue concerning code change to set1 early #30

// v0.0.0.2
   // code cleaning pass one

// v0.0.0.1
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
