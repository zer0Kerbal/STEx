// SGEx (StarGuise Experimental)

// FILE: /ramp/rampcompile.ks

// complies a list of files, then creates a filename.json file from that list.

// SUBTYPE:	file utility
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
// creation: 	15 Jul 18
// last update:	15 Jul 18

print "compiling libraries.".

global function _compile {
	parameter sT is "".
	if sT <> "" {
		print "compiling " + sT + " => " + sT + "m".
		compile sT.
		print " - done".
	} else Print "ERROR 01x4515: " + sT + "not valid filename".
}

global function _createfilejson {
	parameter sT is "0:/ramp/filenames.json".
	// create file
	WRITEJSON(sT, filenames).
}

for filenames in list (
		"__setinclan",
		"_abrake",
		"_dchutes",
		"approach",
		"circ",
		"circ_alt",
		"deorbitsp",
		"depart",
		"dock",
		"fly",
		"grapple",
		"initialize",
		"land",
		"landvac",
		"launch",
		"launch_asc",
		"launch_ssto",
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
		"rampcompile",
		"rdv",
		"rvr",
		"rvr-astr",
		"rvr-cnvy",
		"rvr-drve",
		"rvr-rout",
		"xfer",
		"vtol",
		"warp"
	) _compile("0:/ramp/" + filenames + ".ks").

	print "All libraries compiled.".
	_createfilejson().
	PRINT "filenames.json created".
  
// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————

// v 0.0.0.1
	// creation by zer0Kerbal
	// 
