/*	Created by	: mark jm 09.27.2010
 * 	Description : Fill-up fields with values in Casualty
 */
function supplyEndtCasualtyAdditionalInfo(obj){
	try{		
		$("txtLocation").value 				= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? unescapeHTML2(nvl(obj.location, "")) : "") : unescapeHTML2(nvl(obj.location, ""));
		$("selSectionOrHazardCd").value 	= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? obj.sectionOrHazardCd : "") : obj.sectionOrHazardCd;
		$("selCapacityCd").value 			= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? obj.capacityCd : "") : obj.capacityCd;
		$("txtLimitOfLiability").value 		= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? unescapeHTML2(nvl(obj.limitOfLiability, "")) : "") : unescapeHTML2(nvl(obj.limitOfLiability, ""));
		$("txtLocation").value				= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? unescapeHTML2(nvl(obj.location, "")) : "") : unescapeHTML2(nvl(obj.location, ""));
		$("txtLimitOfLiability").value		= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? unescapeHTML2(nvl(obj.limitOfLiability, "")) : "") : unescapeHTML2(nvl(obj.limitOfLiability, ""));
		$("txtInterestOnPremises").value	= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? unescapeHTML2(nvl(obj.interestOnPremises, "")) : "") : unescapeHTML2(nvl(obj.interestOnPremises, ""));
		$("txtSectionOrHazardInfo").value	= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? unescapeHTML2(nvl(obj.sectionOrHazardInfo, "")) : "") : unescapeHTML2(nvl(obj.sectionOrHazardInfo, ""));
		$("txtConveyanceInfo").value		= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? unescapeHTML2(nvl(obj.conveyanceInfo, "")) : "") : unescapeHTML2(nvl(obj.conveyanceInfo, ""));		
		$("selCapacityCd").value			= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? obj.capacityCd : "") : obj.capacityCd;
		$("txtPropertyNo").value			= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? unescapeHTML2(nvl(obj.propertyNo, "")) : "") : unescapeHTML2(nvl(obj.propertyNo, ""));
		$("selPropertyNoType").value		= obj == null ? "" : (obj.includeAddl != null) ? ((obj.includeAddl) ? obj.propertyNoType : "") : obj.propertyNoType;
	}catch(e){
		showErrorMessage("supplyEndtCasualtyAdditionalInfo", e);
		//showMessageBox("supplyEndtCasualtyAdditionalInfo : " + e.message);
	}	
}