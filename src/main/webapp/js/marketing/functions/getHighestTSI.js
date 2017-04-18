/**
 * Get the highest tsi amount available among the perils of :itemNo
 * @param itemNo
 * @return
 */
function getHighestTSI(itemNo){
	var peril = null;
	var highestTSI = 0;
	for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
		peril = objGIPIQuoteItemPerilSummaryList[i];		
		if(peril.itemNo == itemNo && peril.recordStatus != -1 
				&& peril.tsiAmount > highestTSI){
			highestTSI = peril.tsiAmount;
		}
	}
	return highestTSI;
}