function supplyMHAdditional(obj) {
	try {
		$("vesselCd").value			= 	obj == null ? "" : obj.vesselCd;
		$("vesselName").value		=	obj == null ? "" : unescapeHTML2(obj.vesselName);
		$("vesselOldName").value	=	obj == null ? "" : unescapeHTML2(nvl(obj.vesselOldName, ""));
		$("vesTypeDesc").value		= 	obj == null ? "" : unescapeHTML2(nvl(obj.vesTypeDesc, ""));
		$("propelSw").value			=	obj == null ? "" : nvl(obj.propelSw, "");
		$("vessClassDesc").value	=	obj == null ? "" : unescapeHTML2(nvl(obj.vessClassDesc, ""));
		$("hullDesc").value			=	obj == null ? "" : unescapeHTML2(nvl(obj.hullDesc, ""));
		$("regOwner").value			=	obj == null ? "" : unescapeHTML2(nvl(obj.regOwner, ""));
		$("regPlace").value			=	obj == null ? "" : unescapeHTML2(nvl(obj.regPlace, ""));
		$("grossTon").value			=	obj == null ? "" : nvl(obj.grossTon, "") != "" ? formatCurrency(obj.grossTon) : "";
		$("deadWeight").value		=	obj == null ? "" : nvl(obj.deadWeight, "") != "" ? lpad(obj.deadWeight, 8, "0") : "";
		$("crewNat").value			=	obj == null ? "" : unescapeHTML2(nvl(obj.crewNat, ""));		//Gzelle 06012015 SR4302
		$("vesselLength").value		=	obj == null ? "" : nvl(obj.vesselLength, "") != "" ? formatCurrency(obj.vesselLength).replace(/,/g, "") : "";
		$("vesselBreadth").value	=	obj == null ? "" : nvl(obj.vesselBreadth, "") != "" ? formatCurrency(obj.vesselBreadth).replace(/,/g, "") : "";
		$("vesselDepth").value		=	obj == null ? "" : nvl(obj.vesselDepth, "") != "" ? formatCurrency(obj.vesselDepth).replace(/,/g, "") : "";
		$("dryPlace").value			=	obj == null ? "" : unescapeHTML2(nvl(obj.dryPlace, ""));
		$("dryDate").value			=	obj == null ? "" : obj.dryDate;
		$("recFlag").value			=	obj == null ? "" : nvl(obj.recFlag, "");
		$("deductText").value		=	obj == null ? "" : obj.deductText;
		$("geogLimit").value		=	obj == null ? "" : unescapeHTML2(nvl(obj.geogLimit, ""));
		$("netTon").value			=	obj == null ? "" : nvl(obj.netTon, "") != "" ? formatCurrency(obj.netTon) : "";
		$("noCrew").value			=   obj == null ? "" : nvl(obj.noCrew, "") != "" ? lpad(obj.noCrew, 8, "0") : "";
		$("yearBuilt").value		=	obj == null ? "" : nvl(obj.yearBuilt, "");
		
		// mark jm 12.01.2011 remove this whole if condition if tablegrid in marine hull is on full implementation
		/*if(databaseName != "GEN10G" && itemTablegridSw != "Y"){
			filterVesselLOV("vesselCd", $("vesselCd").value, "MH");
		}*/
	} catch(e) {
		showErrorMessage("supplyMHAdditional", e);
	}
}