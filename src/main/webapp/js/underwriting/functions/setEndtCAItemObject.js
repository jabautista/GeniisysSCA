/*	Created by	: mark jm 09.30.2010
 * 	Description	: set detail information for Casualty
 */
function setEndtCAItemObject(newObj){	
	try{		
		newObj.location				= escapeHTML2($F("txtLocation"));
		newObj.limitOfLiability		= escapeHTML2($F("txtLimitOfLiability"));
		newObj.sectionLineCd		= "";
		newObj.sectionSublineCd		= "";
		newObj.interestOnPremises	= escapeHTML2($F("txtInterestOnPremises"));
		newObj.sectionOrHazardInfo	= escapeHTML2($F("txtSectionOrHazardInfo"));
		newObj.conveyanceInfo		= escapeHTML2($F("txtConveyanceInfo"));
		newObj.propertyNo			= escapeHTML2($F("txtPropertyNo"));
		newObj.locationCd			= "";
		newObj.sectionOrHazardCd	= $F("selSectionOrHazardCd");
		newObj.capacityCd			= $F("selCapacityCd");
		newObj.propertyNoType		= $F("selPropertyNoType");
		
		if($("row" + newObj.itemNo) != null){
			newObj.masterDetail = 1;
		}else{
			if((newObj.location).empty() && (newObj.limitOfLiability).empty() && (newObj.sectionLineCd).empty() &&
					(newObj.sectionSublineCd).empty() && (newObj.interestOnPremises).empty() && (newObj.sectionOrHazardInfo).empty() &&
					(newObj.conveyanceInfo).empty() && (newObj.propertyNo).empty() && (newObj.locationCd).empty() &&
					(newObj.sectionOrHazardCd).empty() && (newObj.capacityCd).empty() && (newObj.propertyNoType).empty()){
				newObj.masterDetail = 0;
			}else{
				newObj.masterDetail = 1;
			}
		}		
		
		return newObj;
	}catch(e){
		showErrorMessage("setEndtCAItemObject", e);
	}
}