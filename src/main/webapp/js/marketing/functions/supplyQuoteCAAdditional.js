/**
 * @param obj
 * @return
 */
function supplyQuoteCAAdditional(obj){
	try{
		if($("txtLocation") != undefined) 		 $("txtLocation").value 			= obj == null ? "" : unescapeHTML2(nvl(obj.location, ""));
		if($("selSectionOrHazard") != undefined) $("selSectionOrHazard").value 		= obj == null ? "" : obj.sectionOrHazardCd;
		if($("selCapacity") != undefined) 		 $("selCapacity").value 			= obj == null ? "" : obj.capacityCd;
		if($("txtLimitOfLiability") != undefined)$("txtLimitOfLiability").value 	= obj == null ? "" : unescapeHTML2(nvl(obj.limitOfLiability, ""));
	}catch (e) {
		showErrorMessage("supplyQuoteCAAdditional", e);
	}
}