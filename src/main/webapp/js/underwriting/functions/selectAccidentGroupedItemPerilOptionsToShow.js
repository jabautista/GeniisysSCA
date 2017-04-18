function selectAccidentGroupedItemPerilOptionsToShow(grpItemNo){
	try{
		var itemNo = $F("itemNo");
		var cGroupedItemNo = parseInt($F("groupedItemNo"));
		
		if ($$("div#coverageTable div[name='rowCoverage']").size() == 0){			
			showGroupedBasicPerilsOnly();
		} else {
			if(($$("div#coverageListing div[grpItem='" + cGroupedItemNo + "']")).length > 0){
				//showAllGroupedPerilsOptions();
				filterLOV3("cPerilCd", "rowCoverage", "perilCd", "grpItem", grpItemNo);
			}else{				
				showGroupedBasicPerilsOnly();
			}			
		}
	}catch(e){
		showErrorMessage("selectAccidentGroupedItemPerilOptionsToShow", e);
	}	
}