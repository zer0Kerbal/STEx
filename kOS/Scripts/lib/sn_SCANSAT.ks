// SGEx (StarGuise Experimental)
//
// FILE: sn_SCANSAT.ks
// SUBTYPE: sentence (sn_)
// provides SCANSat kOS integration functions
//
// AUTHOR: zer0Kerbal
// https://github.com/zer0Kerbal/SGEx/releases
// ——————————————————————————————————————————————————
// status: β 1.0.0.0
// ——————————————————————————————————————————————————
// FOR: SGEx
// ——————————————————————————————————————————————————
// Ω Requires: kOS
// Ω Requires: SCANSat
// Ω Requires: kOS SCANSat.dll
// Ω Requires: SCANSat and kOS part
// ——————————————————————————————————————————————————
// original creation: 17 Jun 18

// This 'sentence' provides the following ralated functions.
	// function SCANSat_on{
	// function SCANSat_off{
	// function SCANSat_toggle{
	// function SCANSat_analyzedata
	
// future function to include: 
	// TODO: KERBnet functions?
	// TODO: improve to more robust functions.
	// TODO: /help parameter

function SCANSat_on{
  set p TO ship:partstitled("SCAN RADAR Altimetry Sensor")[0].
  set m TO p:getmodule("SCANsat").
  m:doevent("start scan: radar").
}

function SCANSat_off{
  set p TO ship:partstitled("SCAN RADAR Altimetry Sensor")[0].
  set m TO p:getmodule("SCANsat").
  m:doevent("stop scan: radar").
}

function SCANSat_toggle{
  set p TO ship:partstitled("SCAN RADAR Altimetry Sensor")[0].
  set m TO p:getmodule("SCANsat").
  m:doevent("toggle scan: radar").
}

function SCANSat_analyzedata
  set p TO ship:partstitled("SCAN RADAR Altimetry Sensor")[0].
  set m TO p:getmodule("SCANexperiment").
  m:doevent("analyze data: radar").
}


// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————

// v 1.0.0.0
	// initial commit to GitHub

// v 0.0.0.6
   // corrected typos
   // adjusted things
   // adjust name
   // removed wait 5 from each function - debug

// v 0.0.0.5
   // added header

// v 0.0.0.4
   /// added changelog

// v 0.0.0.3
   // added function list
   // added TODO:

// v 0.0.0.2
   // conversion to primitive library item - sentence of 4 words.

// v 0.0.0.1
// creation by zer0Kerbal
