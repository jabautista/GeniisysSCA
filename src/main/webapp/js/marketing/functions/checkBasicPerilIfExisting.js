/**
 * Checks if basic peril is existing.
 * @param itemNo - itemNo to be checked
 */

function checkBasicPerilIfExisting(quoteId, itemNo){
	var isBasicPerilExisting = false;
	
	for(var i=0; i<objPackQuoteItemPerilList.length; i++){
		if(objPackQuoteItemPerilList[i].quoteId == quoteId &&
		   objPackQuoteItemPerilList[i].itemNo == itemNo &&
		   objPackQuoteItemPerilList[i].recordStatus != -1 && 
		   objPackQuoteItemPerilList[i].perilType == "B"){
				isBasicPerilExisting = true;
				break;
		}
	}
	
	return isBasicPerilExisting;
}