// SGEx (StarGuise Experimental)
//
// FILE: 	sn_NFE-capacitor.ks
// SUBTYPE:	sentence (sn_)
// - 
//
// AUTHOR: u/Magnevv, zer0Kerbal
// happily swiped (and modified) from:http://pastebin.com/EYViWNX9
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

@LAZYGLOBAL off.

// Create a list of all parts with capacitators.
SET capacitors TO list().

// Create a reference to the total/global value of ec and sc
LIST RESOURCES IN RESLIST.

FUNCTION CapList {
	PRINT "Found capacitors:".
	FOR part IN SHIP:PARTS {
	  FOR resource in part:RESOURCES {
		IF resource:NAME = "StoredCharge" {
		  capacitors:ADD(part).
		  print " - " + part:NAME.
		}
	} } }

FUNCTION ECSC {
	FOR resource IN RESLIST {
	  IF resource:NAME = "ElectricCharge" {
		set EC to resource.
	  } ELSE IF resource:NAME = "StoredCharge" {
		set SC to resource.
	  }
	}
}

WAIT 3.
clearscreen.

// log "-- start --" to "dischargelog.log".

print "CAPACITOR MANAGER".

set lastEC to EC:AMOUNT.
set lastTC to EC:AMOUNT + SC:AMOUNT.
set lastT to TIME:SECONDS.
set charging to FALSE.
set lastPrint to 7.
UNTIL False {
  WAIT 0.25.
  // Figure out at what rates EC and SC is currently changing.
  set dT to TIME:SECONDS - lastT.
  set lastT to TIME:SECONDS.
  set dEC to (EC:AMOUNT - lastEC) / dT.
  set lastEC to EC:AMOUNT.
  set dTC to (EC:AMOUNT + SC:AMOUNT - lastTC) / dT.
  set lastTC to EC:AMOUNT + SC:AMOUNT.
 
  // We only care about managing capacitators if we are currently losing more
  // energy than we are gaining.
  IF dTC < 0 {
    // Try to keep our EC amount at around half, and change it faster towards
    // that value the further out it currently is. By keeping it around half we
    // keep a decent amount of leeway in both directions. Upwards leeway avoids accidentally
    // wasting charge by running capacitators when we are at max, downwards avoids the system
    // shutting down (engines burning out, kOS computer restarting, SAS stopping).
    set targetEC to (EC:CAPACITY * 0.5 - EC:AMOUNT) / 2.0.
    
    // log "Rebalance session. tEC " + targetEC + ". dEC " + dEC + ". Current " + EC:AMOUNT to "dischargelog.log".
    
    // In this initial step, we look capacitators currently firing, and adjust them until
    // the rate of change of the EC is (close to) equal to our target.
    if abs(dEC - targetEC) > 10 {
      for capacitor in capacitors {
        set module to capacitor:GETMODULE("DischargeCapacitor").
        if module:GETFIELD("status") <> "Ready" and module:GETFIELD("status") <> "Discharged!" {
          set currentDischargeRate to module:GETFIELD("adjusted discharge rate").
          set maxdischargerate to 100 * currentDischargeRate / module:GETFIELD("percent power").
          // setting targetRate like this may cause it to be over 100% or under 50%, but that's fine 
          // since the setfield will just cap it back to a valid value, and we then use the actual
          // value to adjust dEC.
          set targetRate to  100 * (targetEC - (dEC - currentDischargeRate)) / maxdischargerate.
          module:SETFIELD("percent power", targetRate).
          // log "Adjusting. Current: " + currentDischargeRate 
            // + ". Max: " + maxdischargerate
            // + ". Target: " + targetRate
            // + ". Result: " + module:GETFIELD("percent power") to "dischargelog.log".

          set dEC to dEC - currentDischargeRate + maxdischargerate * module:GETFIELD("percent power") / 100.
          
          if abs(dEC - targetEC) < 10 { break. }
        }
      }
      // log "after " + dEC to "dischargelog.log".
    }
  
    // After the currently discharging capacitors have been adjusted, if we are still losing
    // EC, it means that we need to trigger another one. We then simply trigger capacitors until
    // our EC is again flowing up (we could follow this up with another balancing, but we just leave
    // that for the next iteration).
    // This logic is not ideal in all cases. For instance, we have a series of smaller capacitors
    // that need to be fired in parallel, and some big capacitors that have to be fired alone
    // not to overflow, this logic will still trigger the big capacitor in conjunction with the
    // smaller ones.
    if dEC + 10 < targetEC {
      FOR capacitor in capacitors {
        set module to capacitor:GETMODULE("DischargeCapacitor").
        IF module:GETFIELD("status") = "Ready" {
          set max_rate to 100 * module:GETFIELD("adjusted discharge rate") / module:GETFIELD("percent power").
          // Firing at 100% power means that we reach targetEC in as few capacitors as possible.
          module:SETFIELD("percent power", 100).
          module:DOEVENT("discharge capacitor").
          set dEC to dEC + max_rate.
          // log "Discharging capacitor. Current rate " + dEC to "dischargelog.log".
          if dEC > targetEC { break. }
        }
      }
    }
  }

  // Print a list of all currently discharging capacitor. At this build of kOS, string
  // manipulation is not in, so we have to check for "not ready" and "not discharged" because
  // the status string indicating discharging isn't static, and is postfixed by the amount
  // it's discharging with. Unfortunately, the string for recharging also has that postfix
  // which makes the code for checking "Is this capacitator discharging" inelegant.
  set i to 7.
  for capacitor in capacitors {
    set module to capacitor:GETMODULE("DischargeCapacitor").
    if module:GETFIELD("status") <> "Ready" AND module:GETFIELD("status") <> "Discharged!" AND not charging {
      print module:GETFIELD("status")
        + ". Store: " + round(capacitor:RESOURCES[0]:AMOUNT) 
        + ". Time left: " + round(capacitor:RESOURCES[0]:AMOUNT / module:GETFIELD("adjusted discharge rate"), 2)
        + " seconds." at (5, i).
      set i to i + 1.
    }
  }
  set iterationLastPrint to i.
  until i >= lastPrint {
    print "                                                                                    " at (5, i).
    set i to i + 1.
  }
  set lastPrint to iterationLastPrint.
  
  // We globally recharge all capacitors if we are either currently gaining more EC than
  // we are using (engines off typically). We also set them to charge if we are at full
  // capacity (because then we technically can't verify that we are gaining more than
  // we are using). Because the charging may use more power than we are generating, and
  // that could cause systems to shut down, we stop charging if we have less than 50% EC.
  if (EC:AMOUNT = EC:CAPACITY OR dTC > 0) AND EC:AMOUNT > EC:CAPACITY*0.5 AND charging = FALSE {
    FOR capacitor in capacitors {
      capacitor:GETMODULE("DischargeCapacitor"):DOACTION("enable charging", TRUE).
    }
    set charging to TRUE.
  } ELSE IF dTC < 0 and charging = TRUE {
    FOR capacitor in capacitors {
      capacitor:GETMODULE("DischargeCapacitor"):DOACTION("disable charging", TRUE).
    }
    set charging to FALSE.
  }

  // Printing the status display
  print "Electric Charge: " + ROUND(EC:AMOUNT) + " / " + EC:CAPACITY + "(" + ROUND(100*EC:AMOUNT/EC:CAPACITY) + "%) [" + round(dEC) + "]        " AT (3, 2).
  print "Stored Charge: " + ROUND(SC:AMOUNT) + " / " + SC:CAPACITY + "(" + ROUND(100*SC:AMOUNT/SC:CAPACITY) + "%) [" + round(dTC) + "]       " at (3, 3).
  IF dTC < 0 {
    print "Time until empty at current rate: " + ROUND(-(SC:AMOUNT+EC:AMOUNT)/dTC) + " seconds       " AT (3, 4).
  } ELSE IF dTC > 0 {
    print "Time until recharged at current rate: " + ROUND((SC:CAPACITY+EC:CAPACITY-SC:AMOUNT-EC:AMOUNT)/dTC) + " seconds       " AT (3, 4).
  } ELSE {
    print "                                                              " AT (3, 4).
  }
  if charging = TRUE {
    print "Charging enabled " at (3, 5).
  } ELSE {
    print "Charging disabled" at (3, 5).
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
