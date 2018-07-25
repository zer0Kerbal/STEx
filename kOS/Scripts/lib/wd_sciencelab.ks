// SGEx (StarGuise Experimental)
//
// FILE: 	wd_sciencelab
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
// science lab utilities

declare global function ListScienceLabModules {
    declare local ScienceLabModules to list().
    declare local partList to ship:parts.

    for thePart in partList {
        declare local moduleList to thePart:modules.
        from {local i is 0.} until i = moduleList:length step {set i to i+1.} do {
            set theModule to moduleList[i].
            // just check for the Module Name. This might be extended in the future.
//            if (theModule = "ModuleScienceLab") or (theModule = "DMModuleScienceAnimate") {
            if (theModule = "ModuleScienceLab") {
                ScienceLabModules:add(thePart:getModuleByIndex(i)). // add it to the list
				thePart:getModuleByIndex(i):DOEVENT("Transmit Science").
            }
        }
    }
    LOG ScienceLabModules TO SciMods.
    return ScienceLabModules.
}
declare global FUNCTION partsLabTransmitScience { 
    FOR P IN SHIP:PARTS {
        IF P:MODULES:CONTAINS("ModuleScienceLab") {
            P:GETMODULE("ModuleScienceLab").
            FOR A IN M:ALLACTIONNAMES() {
                IF A:CONTAINS("tranmit science") { M:DOACTION(A,True). }
            }.
        }
    }.
}

PRINT "Transmitting Availablle Science Research".
partsLabTransmitScience().

// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————

// v 0.0.0.1
	// creation by zer0Kerbal
	// 
