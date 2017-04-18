/**
 * Checks if item has existing perils.
 * @param itemNo - item no to be checked.
 * 
 */

function checksIfQuoteItemHasPerils(quoteId, itemNo){
	var isPerilExisting = false;
	
	for(var i=0; i<objPackQuoteItemPerilList.length; i++){
		if(objPackQuoteItemPerilList[i].quoteId == quoteId &&
		   objPackQuoteItemPerilList[i].itemNo == itemNo &&
		   objPackQuoteItemPerilList[i].recordStatus != -1){
				isPerilExisting = true;
				break;
		}
	}
	
	return isPerilExisting;
}