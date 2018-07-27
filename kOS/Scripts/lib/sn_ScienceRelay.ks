// SGEx (StarGuise Experimental)
//
// FILE: 	sn_ScienceRelay.ks
// SUBTYPE:	sentence (sn_)
// - 
// mimics mod: science relay, but done with only kOS
// -
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
// 

@lazyglobal off.

GLOBAL FUNCTION _collectScienceData{

}

GLOBAL FUNCTION _storeasJSON {
}

GLOBAL FUNCTION _xferAccumulatedScienceData {
}

GLOBAL FUNCTION _LoadScienceData { 
}

GLOBAL FUNCTION _relayScienceData { 
}

GLOBAL FUNCtion _Listen {
}

  // dump all data into xfer.json
	// communication xfer.json to sciencelab vessel
	// sciencelab vessel loads data into command module or TST or science container
	// then from science container loads into sciencelab until lab full
  // needs to check for connection
  // connection to proper / else bounce home first
  // check for EC
  // determine best xmitter
  

// ——————————————————————————————————————————————————
// ——— changelog ————————————————————————————————————
// ——————————————————————————————————————————————————
// TODO: 
	
// v 0.0.0.1
	// creation by zer0Kerbal
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
