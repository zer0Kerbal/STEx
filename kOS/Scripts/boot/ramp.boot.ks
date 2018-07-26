// SGEx (StarGuise Experimental)
// FILE: /boot/ramp.boot.ks

// generic boot - WIP.

// SUBTYPE:	boot
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
// creation: 	01 Jul 18
// last update: 25 Jul 18

set versionNumber to "v0.0.2.7".
SET _sN to ship:name.
SET lFile to _sN + "_" + time:year + "_" + time:day + ".log".
SET aFile to "0:/logs/"  + lFile.
set runmode to 0. log "" to runmode.ks. run runmode.ks.

declare global function set_runmode {
  parameter n. set runmode to n.
  print "Runmode set to " + n.
  log "" to runmode.ks. delete runmode.ks.
  log "set runmode to " + n + "." to runmode.ks.
}

// following will err if no connection to KSC
// also need to include local copy of filenames.json jic
// RUNPATH("0:/ramp/rampcompile.ks").
//set dependency to READJSON("0:/ramp/filenames.json").

declare global function LOGS {parameter sT. parameter bTS is 1. IF bTS {LOG "[" + time:calendar + "] @ [" + time:clock + "] " + sT to lFile. LOG "[" + time:calendar + "] @ [" + time:clock + "] " + sT to aFile. } ELSE { LOG sT to lFile. LOG sT to aFile.	}}

declare global function ECHO {parameter sT is " ". parameter bTM is 1. parameter bGUI is 1. parameter bTS is 1. LOGS(sT, bTS). if bTM {PRINT sT.} if bGUI {HUDTEXT(sT, 4, 2, 14, GREEN, not(bTM)).}}

Clearscreen. SWITCH to 1.

//CORE:PART:GETMODULE("kOSProcessor"):DOEVENT("Open Terminal").
copypath("0:/boot/RAMP.BOOT.ks", "1:/boot/").

//http://patorjk.com/software/taag/#p=display&f=Alpha&t=SGEx


ECHO("83 71 69 120").
ECHO("").
ECHO("        Navigational Operating System (SGExNOS)         ").
ECHO("               >>==- zer0Kerbal =--<<                   ").
ECHO("                                                        ").
ECHO("                        " + versionNumber +"            ").
ECHO("                                                        ").
ECHO("      ___           ___           ___           ___     ").
ECHO("     /  /\         /  /\         /  /\         /__/|    ").
ECHO("    /  /:/_       /  /:/_       /  /:/_       |  |:|    ").
ECHO("   /  /:/ /\     /  /:/ /\     /  /:/ /\      |  |:|    ").
ECHO("  /  /:/ /::\   /  /:/_/::\   /  /:/ /:/_   __|__|:|    ").
ECHO(" /__/:/ /:/\:\ /__/:/__\/\:\ /__/:/ /:/ /\ /__/::::\____").
ECHO(" \  \:\/:/~/:/ \  \:\ /~~/:/ \  \:\/:/ /:/    ~\~~\::::/").
ECHO("  \  \::/ /:/   \  \:\  /:/   \  \::/ /:/      |~~|:|~~ ").
ECHO("   \__\/ /:/     \  \:\/:/     \  \:\/:/       |  |:|   ").
ECHO("     /__/:/       \  \::/       \  \::/        |  |:|   ").
ECHO("     \__\/         \__\/         \__\/         |__|/    ").
ECHO("").
PRINT "                                       ".
PRINT "   ███████╗ ██████╗ ███████╗██╗  ██╗   ".
PRINT "   ██╔════╝██╔════╝ ██╔════╝╚██╗██╔╝   ".
PRINT "   ███████╗██║  ███╗█████╗   ╚███╔╝    ".
PRINT "   ╚════██║██║   ██║██╔══╝   ██╔██╗    ".
PRINT "   ███████║╚██████╔╝███████╗██╔╝ ██╗   ".
PRINT "   ╚══════╝ ╚═════╝ ╚══════╝╚═╝  ╚═╝   ".
PRINT "                                 ".
PRINT "".
PRINT "83 71 69 120".
PRINT "Navigational Operating System (SGExNOS)".
PRINT "       >>==- zer0Kerbal =--<<          ".
PRINT "                                       ".
PRINT "       " + versionNumber +"   ".
PRINT "".
LOGS("Booting " + _sN + " from RAMP.BOOT.ks " + versionNumber).
WAIT 0.5.
ECHO("Updating from KSC Kray IV Jedi xXx 2K /boot/RAMP.BOOT.ks").

  for dependency in list(
    "launch_asc", 	//"launchtocirc.ks", <-- non-ramp
	"_abrake",		// airbrake lib <-- non-ramp
	"_dchutes",		// chutes lib <-- non-ramp
	"approach",
	"circ",
	"circ_alt",
	"depart",
	"deorbitsp",
    "dock",
	"fly",
	"initialize",
	"land",
	"landvac",
	"lib_dock",
	"lib_land",
	"lib_parts",
	"lib_rover",
	"lib_staging",
	"lib_terrain",
	"lib_ui",
    "lib_util",
	"lib_warp",
    "match",
	"node",
	"node_alt",
	"node_apo",
	"node_hoh",
	"node_inc",
	"node_inc_equ",
	"node_inc_tgt",
	"node_peri",
	"node_vel_tgt",
    "rdv",
	"rover",
	"rover_autosteer",
	"roverdrive",
	"roverroute",
	"transfer",
	"vtol",
	"warp"
  ) { copypath("0:/ramp/" + dependency + ".ksm", "1:/").  LOGS(dependency + "... copied."). }
  // needed to add .ksm
  
  // RUNMODE
	//1 = PRELAUNCH
	//2 = LAUNCHTOCIRC(80)
	//3 = RENDEZVOUS
	//4 = DOCK
	//5 = DOCKED (HIBERNATE)
	//6 - xfer resources
	//7 - DEPART
	//8 - RTS
	
	
LOGS("Status: " + ship:status). // ship's status

IF ADDONS:AVAILABLE("RT")
{
// delay in seconds from KSC to vessel
	SET bKSCConnect to addons:rt:haskscconnection(ship).
	set fKSCDelay to addons:rt:KSCDelay(ship).
	
	PRINT "Connection Home : " + 
		addons:rt:haskscconnection(ship) +
		" with delay of (in seconds) from KSC to vessel: " + 
		round(addons:rt:KSCDelay(ship),6).
	LOGS("Connection Home : " + 
		bKSCConnect + 
		" with delay of (in seconds) from KSC to vessel: " + 
		ROUND(fKSCDelay,6)). 
}

LOGS("AVAILABLE RESOURCES:").
LIST RESOURCES IN RESLIST.
FOR RES IN RESLIST {
	LOGS("   : " + RES:NAME + " (" + 
		ROUND(100*RES:AMOUNT/RES:CAPACITY) + "%) [" + 
		floor(RES:AMOUNT) + "/" + floor(RES:CAPACITY) + "]").
	}.

 
DELETEPATH(lFile).
print "Starting runmode: " + runmode.
PRINT "Commands: RDV(aka rendezvous), APPROACH, MATCH, DOCK, DEPART, DEORBITSP, land(lat,lng), landvac(lat,long), launch_asc(m, inc) VTOL(maxcycles, IPU), FLY{Plane/Shuttle), INITIALIZE".


// // declare global function fetch
// // {
// set fetchrunmode TO -1

// until fetchrunmode IS -1
// {
	// ON AG1 {
		// SET fetchrunMode TO fetchrunMode - 1.
		// SET updateSettings TO true.
	// }
	// ON AG2 {
		// SET runMode TO runMode + 1.
		// SET updateSettings TO true.
	// }
	// if fetchrunmode = 0 {
		// // do nothing - docked or asleep

		// wait 0.25
	// }
	// if fetchrunmode = 1 {
		// // initiating fetch
		// lOGS("Fetching " + ship.target.name)
		// // wait until user says go, allowing time to set target.
	// }
	// if fetchrunmode = 2  {
	// LOGS("Departing from " + ship:name).
		// // Departing from docked ship - if docked. need to determine.
		// SET sTarget to ship:name.
		// RUN depart.
	// }
	// if fetchrunmode = 3 {
		// // Rendezvous with target
		// LOGS("Rendezvous with " + ship.target.name).
		// RUN rdv.
	// }
	// if fetchrunmode = 4 {
		// // Approaching (getting closer)
		// LOGS("Approaching with " + ship.target.name).
		// RUN approach.
	// }
	// if fetchrunmode = 5 {
		// // Matching target velocity
		// LOGS("Matching velocity with " + ship.target.name).
		// RUN match.
	// }
	// if fetchrunmode = 6 {
		// // Docking with target (need to allow time to select correct ports)
		// LOGS("Docking with " + ship.target.name).
		// RUN dock.
	// }
	// if fetchrunmode = 7 {
		// // once docked, set target to stored vessel
		// SET ship:target TO sTarget.
		// LOGS("Rendezvous with " + ship.target.name).
		// RUN rdv.
	// }
	// if fetchrunmode = 8 {
		// //
		// LOGS("Approaching with " + ship.target.name).
		// RUN approach.
	// }
	// if fetchrunmode = 9 {
		// //
		// LOGS("Matching velocity with " + ship.target.name).
		// RUN match.
	// }
	// if fetchrunmode = 10 {
		// //
		// LOGS("Docking with " + ship.target.name).
		// run dock.
	// }
	// if fetchrunmode = 11 {
	// }
	// if fetchrunmode = 12 {
	// }
// }
	
// }
  // use dockingport tag "KSS Crew Ship 5" (from core:tag). for status.
  // OR use core:count > 1{HIBERNATE} ELSE {???}
	// if (ship:status = "DOCKED")
	// {
		// PRINT "Dave, there is nothing to do except go to sleep.".
	// }
	// ELSE
	// {
		// PRINT "DOCKING".
		// run dock.ks.
	// }
	
// runmode - 
	//prelaunch - preflight
	//landed - launch2circ
	//flying - stage as needed, make sure plugged in, fairings
	//orbiting - check for orbit, rdzv, dock.
	//docked - check for update, sleep.
  
//RUN DEPART.
	
// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————

// v 0.0.0.1
	// creation by zer0Kerbal
	// MIT license:
  //MIT License

//Copyright (c) 2018 zer0Kerbal

//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.
