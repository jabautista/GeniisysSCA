/**
 * Get the highest tsi amount available among the perils of :itemNo
 * @param itemNo
 * @return
 */
function getLowestTSI(itemNo){
	try{
		var peril = null;
		var lowestTSI = 0;
		for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
			peril = objGIPIQuoteItemPerilSummaryList[i];
			if(peril.itemNo == itemNo && peril.recordStatus != -1){
				if(i==0){
					lowestTSI = peril.tsiAmount;
				}else if(peril.tsiAmount < lowestTSI){
					lowestTSI = peril.tsiAmount;
				}
			}
		}
	}catch(e){
		showErrorMessage("Error caught in getting lowest tsi", e);
	}
	return lowestTSI;
}