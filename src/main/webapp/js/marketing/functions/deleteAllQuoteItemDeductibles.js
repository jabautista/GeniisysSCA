/**
 * Set recordStatus of all deductibles of the quotation item to -1 (to be deleted)
 * given the quoteId and itemNo
 * @param quoteId - quoteId of the quotation under the Package quotation
 * @param itemNo - the itemNo
 * 
 */

function deleteAllQuoteItemDeductibles(quoteId, itemNo){
	for(var i=0; i<objPackQuoteDeductiblesList.length; i++){
		if(objPackQuoteDeductiblesList[i].quoteId == quoteId &&
		   objPackQuoteDeductiblesList[i].itemNo == itemNo){
		    objPackQuoteDeductiblesList[i].recordStatus = -1;
		}
	}
	
	if($("addDeductibleForm")!= null){
		($$("div#quoteDeductibleTableContainer div([quoteId='"+ quoteId +"'][itemNo='" + itemNo + "'])")).invoke("remove");
		resizeTableBasedOnVisibleRowsWithTotalAmount("quoteDeductiblesTable", "quoteDeductibleTableContainer");
		$("totalDeductibleAmount").innerHTML = computeTotalDeductibleAmountForPackageQuotation();
	}
}