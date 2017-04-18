function setCAItemObject(newObj){
	try{
		var gipiWCasualtyItem = new Object();
		
		gipiWCasualtyItem.location				= escapeHTML2($F("txtLocation"));
		gipiWCasualtyItem.limitOfLiability		= escapeHTML2($F("txtLimitOfLiability"));
		gipiWCasualtyItem.sectionLineCd			= $("selSectionOrHazardCd").options[$("selSectionOrHazardCd").selectedIndex].getAttribute("sectionLineCd");
		gipiWCasualtyItem.sectionSublineCd		= $("selSectionOrHazardCd").options[$("selSectionOrHazardCd").selectedIndex].getAttribute("sectionSublineCd");
		gipiWCasualtyItem.interestOnPremises	= escapeHTML2($F("txtInterestOnPremises"));
		gipiWCasualtyItem.sectionOrHazardInfo	= escapeHTML2($F("txtSectionOrHazardInfo"));
		gipiWCasualtyItem.conveyanceInfo		= escapeHTML2($F("txtConveyanceInfo"));
		gipiWCasualtyItem.propertyNo			= escapeHTML2($F("txtPropertyNo"));
		gipiWCasualtyItem.locationCd			= $F("locationCd");
		gipiWCasualtyItem.sectionOrHazardCd		= $F("selSectionOrHazardCd");
		gipiWCasualtyItem.capacityCd			= $F("selCapacityCd");
		gipiWCasualtyItem.propertyNoType		= $F("selPropertyNoType");
		
		/*
		if($("row" + newObj.itemNo) != null){
			newObj.masterDetail = 1;
		}else{
			if((gipiWCasualtyItems.location).empty() && (gipiWCasualtyItems.limitOfLiability).empty() && (gipiWCasualtyItems.sectionLineCd).empty() &&
					(gipiWCasualtyItems.sectionSublineCd).empty() && (gipiWCasualtyItems.interestOnPremises).empty() && (gipiWCasualtyItems.sectionOrHazardInfo).empty() &&
					(gipiWCasualtyItems.conveyanceInfo).empty() && (gipiWCasualtyItems.propertyNo).empty() && (gipiWCasualtyItems.locationCd).empty() &&
					(gipiWCasualtyItems.sectionOrHazardCd).empty() && (gipiWCasualtyItems.capacityCd).empty() && (gipiWCasualtyItems.propertyNoType).empty()){
				newObj.masterDetail = 0;
			}else{
				newObj.masterDetail = 1;
			}
		}		
		*/
		
		newObj.gipiWCasualtyItem = gipiWCasualtyItem;
		
		return newObj;
	}catch(e){
		showMessageBox("setCAItemObject : " + e.message);
	}
}