/*	Date		Author			Description
 * 	==========	===============	==============================
 * 	09.13.2011	mark jm			Fill-up fields with values in Casualty 
 */
function supplyCAAdditionalTG(obj){
	try{		
		$("locationCd").value				= obj == null ? "" : obj.locationCd;
		$("txtLocation").value 				= obj == null ? "" : unescapeHTML2(nvl(obj.location, ""));
		$("selSectionOrHazardCd").value 	= obj == null ? "" : obj.sectionOrHazardCd;
		$("selCapacityCd").value 			= obj == null ? "" : obj.capacityCd;
		$("txtLimitOfLiability").value 		= obj == null ? "" : unescapeHTML2(nvl(obj.limitOfLiability, ""));
		$("txtLocation").value				= obj == null ? "" : unescapeHTML2(nvl(obj.location, ""));
		$("txtLimitOfLiability").value		= obj == null ? "" : unescapeHTML2(nvl(obj.limitOfLiability, ""));
		$("txtInterestOnPremises").value	= obj == null ? "" : unescapeHTML2(nvl(obj.interestOnPremises, ""));
		$("txtSectionOrHazardInfo").value	= obj == null ? "" : unescapeHTML2(nvl(obj.sectionOrHazardInfo, ""));
		$("txtConveyanceInfo").value		= obj == null ? "" : unescapeHTML2(nvl(obj.conveyanceInfo, ""));		
		$("selCapacityCd").value			= obj == null ? "" : obj.capacityCd;
		$("txtPropertyNo").value			= obj == null ? "" : unescapeHTML2(nvl(obj.propertyNo, ""));
		$("selPropertyNoType").value		= obj == null ? "" : obj.propertyNoType;
		
		obj != null ? null : setCAAddlFormDefault();
		
		//setGroupedItemsForm(null);
		//setCasualtyPersonnelForm(null);		
	}catch(e){
		showErrorMessage("supplyCAAdditionalTG", e);
	}
}