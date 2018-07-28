// SGEx (StarGuise Experimental)
//
// FILE: 	wd_sciencelab.ks
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
// Ω Requires: 
// Ω Requires: 
// ——————————————————————————————————————————————————
// creation: 	
// last update:	27 Jul 18

// science lab utilities

@LAZYGLOBAL off.
parameter HELP is 0.

declare global function ListScienceLabModules {
    declare local ScienceLabModules to list().
    declare local partList to ship:parts.

	PRINT "Transmitting Available Science Research".
    for thePart in partList {
        declare local moduleList to thePart:modules.
        from {local i is 0.} until i = moduleList:length step {set i to i+1.} do {
            set theModule to moduleList[i].
            // just check for the Module Name. This might be extended in the future.
            if (theModule = "ModuleScienceLab") or (theModule = "DMModuleScienceAnimate") {
//            if (theModule = "ModuleScienceLab") {
                ScienceLabModules:add(thePart:getModuleByIndex(i)). // add it to the list
				thePart:getModuleByIndex(i):DOEVENT("Transmit Science").
            }
        }
    }
    LOG ScienceLabModules TO SciMods.
    return ScienceLabModules.
}

declare global FUNCTION partsLabTransmitScience { 
	PRINT "Transmitting Available Science Research".
    FOR P IN SHIP:PARTS {
        IF P:MODULES:CONTAINS("ModuleScienceLab") {
            P:GETMODULE("ModuleScienceLab").
            FOR A IN M:ALLACTIONNAMES() {
                IF A:CONTAINS("tranmit science") { M:DOACTION(A,True). }
            }.
        }
    }.
}

DECLARE GLOBAL FUNCTION ScienceLabHelp{
	PRINT "partsLabTransmitScience(). steps through transmits from all parts and those parts that have ModuleScienceLab AND have science data researched."
	PRINT "ListScienceLabModules(). creates a log file named SciMods on current active volume AND returns a list of parts with ModuleScienceLab or DMModuleScienceAnimate in them.
	SET HELP TO 0.
	}

IF HELP { ScienceLabHelp(). }.

// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————
// TODO: 
	// Part:GETMODULE(“module name”).
	// are there any "ModuleScienceLab" on ship?
	//	if yes, then step through them and transmit science if enough energy
	// stretch - how long. and warp to that point
	// stretch - choose best choice to xmit - shut off all others until xmit=done.
	// also check to see if cleanup needed and exec cleanup
	// OnTransmissionComplete
	// GetScienceCount < 1
	// CleanUpVesselExperiments	(	Vessel 	v	)	
	// OnTransmissionComplete (ScienceData data, Vessel origin, bool xmitAborted)
	// TransmissionErrorScreenMessage (string reason)
	// S.I.C sn_ScienceRelay.ks
	
// v 0.0.0.2
   // converted into primative library file	

   // v 0.0.0.1
	// creation by zer0Kerbal
	// License (S.I.C.)
	
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
