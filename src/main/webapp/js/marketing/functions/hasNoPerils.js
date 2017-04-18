function hasNoPerils(itemNo){
	var hasNone = true;
	if(objGIPIQuoteItemPerilSummaryList!=null){
		if(objGIPIQuoteItemPerilSummaryList.length > 0){
			for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
				if(objGIPIQuoteItemPerilSummaryList[i].recordStatus != -1 && objGIPIQuoteItemPerilSummaryList[i].itemNo==itemNo){
					hasNone = false;
				}
			}
		}
	}
	return hasNone;
}