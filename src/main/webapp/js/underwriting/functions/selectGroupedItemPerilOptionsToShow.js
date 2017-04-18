function selectGroupedItemPerilOptionsToShow(){
	var itemNo = $F("itemNo");
	var cGroupedItemNo = $F("groupedItemNo");
	
	if ($$("div[name='cov']").size()== 0){
		showGroupedBasicPerilsOnly();
	} else {
		$$("div[name='cov']").each(function(row){
			if (row.getAttribute("item") ==  itemNo && row.getAttribute("groupedItemNo") == cGroupedItemNo){
				showAllGroupedPerilsOptions();
			}else{
				showGroupedBasicPerilsOnly();
			}
		});
	}
}