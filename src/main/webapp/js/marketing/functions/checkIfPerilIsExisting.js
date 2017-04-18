/**
 * Checks if peril is already existing.
 * @param perilCode - the peril code to be compared.
 * 
 */

function checkIfPerilIsExisting(perilCode){
	var selectedItemRow = getSelectedRow("row");
	var isPerilExisting = false;
	
	if(selectedItemRow != null){
		for(var i=0; i<objPackQuoteItemPerilList.length; i++){
			if(objPackQuoteItemPerilList[i].quoteId == objCurrPackQuote.quoteId &&
			   objPackQuoteItemPerilList[i].itemNo == selectedItemRow.getAttribute("itemNo") &&
			   objPackQuoteItemPerilList[i].recordStatus != -1 && 
			   objPackQuoteItemPerilList[i].perilCd == perilCode){
					isPerilExisting = true;
					break;
			}
		}
	}
	return isPerilExisting;
}