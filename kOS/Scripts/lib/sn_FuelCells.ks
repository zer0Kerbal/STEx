// SGEx (StarGuise Experimental)
//
// FILE: 	sn_FuelCells.ks
// SUBTYPE:	sentence (sn_)
// - 
//
// AUTHOR: u/snareddit, zer0Kerbal
// happily swiped (and modified) from: https://pastebin.com/BPjWXpdj
// https://github.com/zer0Kerbal/SGEx/releases
// ——————————————————————————————————————————————————
// status: β 1.0.0.0
// ——————————————————————————————————————————————————
// FOR: SGEx
// ——————————————————————————————————————————————————
// Ω Requires: Near-Future Electrical
// Ω Requires: kOS
// ——————————————————————————————————————————————————
// creation: 	
// last update:	03 Aug 18


@LAZYGLOBAL OFF.
global partname to "US.1P110.Wedge.Fuelcell".
global modulename to "ModuleResourceConverter".
 
global US_fuelcells to ship:partsdubbed("US.1P110.Wedge.Fuelcell").
global Onlevel to 0.15.
global Offlevel to 0.3.
global monitorresource to list().
 
clearscreen.
 
for monitorresource in ship:resources{
        if monitorresource:name = "ElectricCharge"
        {
                if US_fuelcells:length>0
                {
                        print"monitoring "+monitorresource:name.
                        print"controlling fuelcell: "+US_fuelcells[0]:name.
                        print"Toggle AG10 (Num0) to end.".
                        until ag10
                                {
                                        print "current level "+round(monitorresource:amount/monitorresource:capacity*100,0)+"%  " at (0,5).
                                        if monitorresource:amount/monitorresource:capacity < Onlevel
                                                {
                                                        US_fuelcells[0]:getmodule("ModuleResourceConverter"):doaction("start fuel cell",true).
                                                        print "Fuelcell started." at (0,6).
                                                }
                                        else if monitorresource:amount/monitorresource:capacity > Offlevel
                                                {
                                                        US_fuelcells[0]:getmodule("ModuleResourceConverter"):doaction("stop fuel cell",true).
                                                        print "Fuelcell stopped." at (0,6).
                                                }
                               
                                }
                                wait 1.
                        print "Monitoring stopped".
                }
                else
                {
                        print "Universal Storage Fuellcell not found".
                }
        }
}


// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————

// v 0.0.0.1
	// creation by zer0Kerbal
	// started converting to library
	// uploaded WIP to GitHub
	// License: CC 4.0 BY-NC-SA
	
// 
// Copyright © 2017-2018, zer0Kerbal
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
