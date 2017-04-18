/**
 * Checks if all items has perils as well as the presence of at least one basic peril. 
 * If not, it prompts an error message that will inform the user to complete
 * the necessarily information and disallow him to save Package Quotation information. 
 * 
 */

function checkIfAllQuotationItemsHasPerils(){
	for(var i=0; i< objPackQuoteItemList.length; i++){
		var quoteId = objPackQuoteItemList[i].quoteId;
		var itemNo = objPackQuoteItemList[i].itemNo;

		if(objPackQuoteItemList[i].recordStatus != -1){
			if(!checksIfQuoteItemHasPerils(quoteId, itemNo)){
				showMessageBox("Item no "+itemNo+" has no peril specified, please complete the neccessary information.", imgMessage.ERROR);
				return false;
			}else if(!checkBasicPerilIfExisting(quoteId, itemNo)){
				showMessageBox("Item no "+itemNo+" has no basic peril specified. Basic peril is required.", imgMessage.ERROR);
				return false;
			}
		}
	}
	return true;
}