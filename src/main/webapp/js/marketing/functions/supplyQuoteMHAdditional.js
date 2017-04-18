/**
 * 
 * @param obj
 * @return
 */
function supplyQuoteMHAdditional(obj){
	try{
		$("vessel").value 			= obj == null ? "" : obj.vesselCd; 
		$("vesselType").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.vesTypeDesc, ""));
		$("vesselClass").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.vessClassDesc, ""));
		$("registeredOwner").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.regOwner, ""));
		$("vesselOldName").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.vesselOldName, "-")); 
		$("propellerType").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.propelSw, ""));  
		$("hullType").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.hullDesc, ""));  
		$("place").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.regPlace, "")); 
		$("grossTonnage").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.grossTon, "")); 
		$("vesselLength").value 	= obj == null ? "" : obj.vesselLength;  
		$("yearBuilt").value 		= obj == null ? "" : obj.yearBuilt; 
		$("netTonnage").value 		= obj == null ? "" : obj.netTon;
		$("vesselBreadth").value 	= obj == null ? "" : obj.vesselBreadth;
		$("noOfCrew").value 		= obj == null ? "" : obj.noCrew;
		$("deadweightTonnage").value = obj == null ? "" : obj.deadWeight; 
		$("vesselDepth").value 		= obj == null ? "" : obj.vesselDepth; 
		$("nationality").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.crewNat, ""));
		$("drydockPlace").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.dryPlace, ""));
		$("drydockDate").value 		=  obj == null ? "" : dateFormat(obj.dryDate, "mm-dd-yyyy");
		$("geogLimit").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.geogLimit, ""));
	}catch (e){
		showErrorMessage("supplyMHAdditional", e);
	}
}