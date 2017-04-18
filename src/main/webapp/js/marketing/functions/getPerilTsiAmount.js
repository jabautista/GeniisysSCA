/**
 * Gets the TSI amount of a peril.
 * @param perilCode - the peril code
 * @return tsiAmount - the TSI amount of the peril
 */

function getPerilTsiAmount(perilCode){
	var selectedItemRow = getSelectedRow("row");
	var tsiAmount = 0;
	
	if(selectedItemRow != null){
		for(var i=0; i<objPackQuoteItemPerilList.length; i++){
			if(objPackQuoteItemPerilList[i].quoteId == objCurrPackQuote.quoteId &&
			   objPackQuoteItemPerilList[i].itemNo == selectedItemRow.getAttribute("itemNo") &&
			   objPackQuoteItemPerilList[i].recordStatus != -1 && 
			   objPackQuoteItemPerilList[i].perilCd == perilCode){
					tsiAmount = objPackQuoteItemPerilList[i].tsiAmount;
					break;
			}
		}
	}
	
	tsiAmount = parseFloat(tsiAmount);
	return tsiAmount;
}