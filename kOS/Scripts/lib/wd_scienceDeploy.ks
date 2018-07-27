// SGEx (StarGuise Experimental)
//
// FILE: 	wd_sciencedeploy.ks
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
// last update:	
// deploys all science experiments

@LAZYGLOBAL off.
global function _deployScience {
    local SEM to list().
    local pL to ship:parts.

    for tP in pL {
        declare local mL to tP:modules.
        from {local i is 0.} until i = mL:length step {set i to i+1.} do {
            set tM to mL[i].
           if (tM = "ModuleScienceExperiment") or (tM = "DMModuleScienceAnimate") {
                SEM:add(tP:getModuleByIndex(i)).
				tP:getModuleByIndex(i):DOEVENT("Deploy").
            }
        }
    }
    LOG SEM TO "0:/LOGS/SEMS".
    return SEM.
}

global FUNCTION partsScienceDeploya { 
	PRINT "Deploying Science Experiements".
    FOR P IN SHIP:PARTS {
        IF P:MODULES:CONTAINS("ModuleScienceExperiment") {
            P:GETMODULE("ModuleScienceExperiment").
            FOR A IN M:ALLACTIONNAMES() {
                IF A:CONTAINS("tranmit science") { M:DOACTION(A,True). }
            }.
        }
    }.
}

global FUNCTION partsScienceDeployb { 
	PRINT "Deploying Science Experiements".
	FOR P in SHIP:PARTS {
		IF P:MODULES:CONTAINS("ModuleScienceExperiment") {
			P:GETMODULE("ModuleScienceExperiment"):DEPLOY.
		}
	}.
}

// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————
// TODO: 
	
// v 0.0.0.1
	// creation by zer0Kerbal
	// 
	
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
