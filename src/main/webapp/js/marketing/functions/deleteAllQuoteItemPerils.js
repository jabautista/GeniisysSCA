/**
 * Set recordStatus of all perils of the quotation item to -1 (to be deleted)
 * given the quoteId and itemNo
 * @param quoteId - quoteId of the quotation under the Package quotation
 * @param itemNo - the itemNo
 * 
 */

function deleteAllQuoteItemPerils(quoteId, itemNo){
	for(var i=0; i<objPackQuoteItemPerilList.length; i++){
		if(objPackQuoteItemPerilList[i].quoteId == quoteId &&
		   objPackQuoteItemPerilList[i].itemNo == itemNo){
			objPackQuoteItemPerilList[i].recordStatus = -1;
		}
	}
	($$("div#quoteItemPerilTableContainer div([quoteId='"+ quoteId +"'][itemNo='" + itemNo + "'])")).invoke("remove");
	resizeTableBasedOnVisibleRows("itemPerilTable", "quoteItemPerilTableContainer");
	computeTotalItemTsiandPremAmount("txtTotalTsiAmount", "txtTotalPremiumAmount");
}