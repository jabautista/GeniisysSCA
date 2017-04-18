function setMHItemObject(newObj) {
	try {
		var mhObj = new Object();
		
		mhObj.vesselCd		= $F("vesselCd");				
		//mhObj.vesselName	= changeSingleAndDoubleQuotes2($F("vesselName"));
		mhObj.vesselName	= escapeHTML2($F("vesselName")); //replaced by: Mark C. 04162015 SR4302
		mhObj.vesselOldName	= ($F("vesselOldName") == "" ? null : escapeHTML2($F("vesselOldName")));
		//mhObj.vesTypeDesc	= ($F("vesTypeDesc") == "" ? null : changeSingleAndDoubleQuotes2($F("vesTypeDesc")));
		mhObj.vesTypeDesc	= ($F("vesTypeDesc") == "" ? null : escapeHTML2($F("vesTypeDesc"))); //replaced by: Mark C. 04162015 SR4302
		mhObj.propelSw		= ($F("propelSw") == "" ? null : $F("propelSw"));
		//mhObj.vessClassDesc	= ($F("vessClassDesc") == "" ? null : changeSingleAndDoubleQuotes2($F("vessClassDesc")));
		mhObj.vessClassDesc	= ($F("vessClassDesc") == "" ? null : escapeHTML2($F("vessClassDesc"))); //replaced by: Mark C. 04162015 SR4302
		mhObj.hullDesc		= ($F("hullDesc") == "" ? null : escapeHTML2($F("hullDesc")));
		mhObj.regOwner		= ($F("regOwner") == "" ? null : escapeHTML2($F("regOwner")));
		mhObj.regPlace		= ($F("regPlace") == "" ? null : escapeHTML2($F("regPlace")));
		mhObj.grossTon		= ($F("grossTon") == "-" ? null : $F("grossTon"));
		mhObj.yearBuilt		= ($F("vesselLength") == "-" ? null : $F("vesselLength"));
		mhObj.deadWeight	= ($F("deadWeight") == "-" ? null : $F("deadWeight"));
		mhObj.crewNat		= $F("crewNat");
		mhObj.vesselLength	= $F("vesselLength");
		mhObj.vesselBreadth	= $F("vesselBreadth");
		mhObj.vesselDepth	= $F("vesselDepth");
		mhObj.dryPlace		= ($F("dryPlace") == "-" ? null : escapeHTML2($F("dryPlace")));
		mhObj.dryDate		= $F("dryDate") == "" ? null : $F("dryDate");
		mhObj.recFlag		= ($F("recFlag") == "" ? null : nvl($F("recFlag"), ""));
		mhObj.deductText	= ($F("deductText") == "" ? null : escapeHTML2($F("deductText")));
		mhObj.geogLimit		= ($F("geogLimit") == "-" ? null : escapeHTML2($F("geogLimit")));
		
		newObj.gipiWItemVes = mhObj;
		
		// mark jm 12.01.2011 remove this whole if condition if tablegrid in marine hull is on full implementation
/*		if(itemTablegridSw != "Y"){
			filterVesselLOV("vesselCd", $("vesselCd").value, "MH");
		}			
*/		
		return newObj;
	} catch(e) {
		showErrorMessage("setMHItemObject", e);
	}
}