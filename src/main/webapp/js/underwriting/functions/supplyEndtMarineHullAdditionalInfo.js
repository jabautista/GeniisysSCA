/*	Created by	: bjga 12.10.2010
 * 	Description : Fill-up fields with values in Marine Hull
 */
function supplyEndtMarineHullAdditionalInfo(obj){
	try{
		$("vesselCd").value			= obj == null ? "" : obj.vesselCd;
		$("vesselName").value		= obj == null ? "" : obj.vesselName;
		$("vesselOldName").value	= obj == null ? "" : obj.vesselOldName;
		$("vesTypeDesc").value		= obj == null ? "" : obj.vesTypeDesc;
		$("propelSw").value			= obj == null ? "" : obj.propelSw;
		$("vessClassDesc").value	= obj == null ? "" : obj.vessClassDesc;
		$("hullDesc").value			= obj == null ? "" : obj.hullDesc;
		$("regOwner").value			= obj == null ? "" : obj.regOwner;
		$("regPlace").value			= obj == null ? "" : obj.regPlace;
		$("grossTon").value			= obj == null ? "" : obj.grossTon;
		$("vesselLength").value		= obj == null ? "" : obj.vesselLength;
		$("yearBuilt").value		= obj == null ? "" : obj.yearBuilt;
		$("netTon").value			= obj == null ? "" : obj.netTon;
		$("vesselBreadth").value	= obj == null ? "" : obj.vesselBreadth;
		$("noCrew").value			= obj == null ? "" : obj.noCrew;
		$("deadWeight").value		= obj == null ? "" : obj.deadWeight;
		$("vesselDepth").value		= obj == null ? "" : obj.vesselDepth;
		$("crewNat").value			= obj == null ? "" : obj.crewNat;
		$("dryPlace").value			= obj == null ? "" : obj.dryPlace;
		$("dryDate").value			= obj == null ? "" : obj.dryDate;
		$("geogLimit").value		= obj == null ? "" : obj.geogLimit;
		$("deductText").value		= obj == null ? "" : obj.deductText;
		$("dspPropelSw").value 		= ("S" == $F("propelSw")) ? "SELF-PROPELLED" : "NON-PROPELLED";
	}catch(e){
		showErrorMessage("supplyEndtMarineHullAdditionalInfo", e);
		//showMessageBox("supplyEndtMarineHullAdditionalInfo : " + e.message);
	}
}