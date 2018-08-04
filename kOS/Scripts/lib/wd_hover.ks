// SGEx (StarGuise Experimental)
// Shamelessly nicked from u/Magnevv via /r/Kos
//
// FILE: 	wd_hover.ks
// SUBTYPE:	word (wd_)
// - 
//
// AUTHOR: u/Magnevv, zer0Kerbal
// happily swiped (and modified) from: 
   // https://www.reddit.com/r/Kos/comments/2zd7y3
   // http://pastebin.com/UAAd5pRD
// https://github.com/zer0Kerbal/SGEx/releases
// ——————————————————————————————————————————————————
// status: β 1.0.0.1
// ——————————————————————————————————————————————————
// FOR: SGEx
// ——————————————————————————————————————————————————
// Ω Requires: kOS
// Ω Requires: 
// ——————————————————————————————————————————————————
// creation: 	
// last update:	03 Aug 18
// Automatic balancing of unstable crafts with kOS

@LAZYGLOBAL off.

clearscreen.

LIST ENGINES in engines.
SET vectors to LIST().

set i to 0.
until i = engines:length {
  print i.
  set pos to engines[i]:position.
  vectors:add(VECDRAWARGS(
    pos,
    engines[i]:facing:forevector * engines[i]:thrust,
    RGB(1, 0, 0),
    "",
    1.0,
    TRUE
  )).
  set engines[i]:thrustlimit to 100.
  set i to i + 1.
}

on AG1 {
  for vec in vectors {
    set vec:show to not (vec:show).
  }
  set torquevec:show to not (torquevec:show).
  PRESERVE.
}

set torquevec to VECDRAWARGS(V(0, 0, 0), V(0, 0, 0), RGB(0, 0, 1), "torque", 1.0, TRUE).

set exit to false.
on AG9 { set exit to true. }

set torques to LIST().
for eng in engines { torques:add(0). }

until exit {
  set total_torque to V(0, 0, 0).
  set i to 0.
  until i = engines:length {
    set thrust to engines[i]:facing:forevector * engines[i]:maxthrust * engines[i]:thrustlimit / 100.
    set torques[i] to VCRS(thrust, engines[i]:position).
    set total_torque to total_torque + torques[i].
    set vectors[i]:VEC to thrust.
    set vectors[i]:START to engines[i]:position.
    set i to i + 1.
  }

  set reset to true.
  until total_torque:MAG < 1.0 {
    if reset {
      set total_torque to V(0, 0, 0).
      set i to 0.
      until i = engines:length {
        set engines[i]:thrustlimit to 100.
        set thrust to engines[i]:facing:forevector * engines[i]:maxthrust * engines[i]:thrustlimit / 100.
        set torques[i] to VCRS(thrust, engines[i]:position).
        set total_torque to total_torque + torques[i].
        set i to i + 1.
      }
      set reset to false.
      print "Recalculating thrusts".
    }
    // get engine with lowest angle to current torque, and reduce it's throttle
    set lowestAngle to 360.
    set lowestEngine to 0.
    set i to 0.
    until i = engines:length {
      set angle to ARCCOS(total_torque * torques[i] / (total_torque:MAG *  torques[i]:MAG)).
      if angle < lowestAngle {
        set lowestAngle to angle.
        set lowestEngine to i.
      }
      set i to i+1.
    }

    set factor to 1 - (total_torque:MAG / (torques[lowestEngine]:mag * COS(lowestAngle))).
    //set deltaTorque to torques[i] * (factor - 1).
    set engines[lowestEngine]:thrustlimit to engines[lowestEngine]:thrustlimit * factor.
    set thrust to engines[lowestEngine]:facing:forevector * engines[lowestEngine]:maxthrust * engines[lowestEngine]:thrustlimit / 100.
    set deltaTorque to VCRS(thrust, engines[lowestEngine]:position) - torques[lowestEngine].
    set torques[lowestEngine] to torques[lowestEngine] + deltaTorque.
    set total_torque to total_torque + deltaTorque.
    //set torques[lowestEngine] to VCRS(thrust, engines[lowestEngine]:position).
  }

  set torquevec:VEC to total_torque. // visual
  wait 0.1.
}

// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————

// v 0.0.0.1
	// started converting to library
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
