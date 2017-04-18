/**
 * #incomplete
 * @return
 */
function quoteItemHasChildInformation(){
	var itemNo = getSelectedRowId("itemRow");
	if(objGIPIQuoteItemPerilSummaryList!=null){
		for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
			if(objGIPIQuoteItemPerilSummaryList[i].itemNo == itemNo && 
					objGIPIQuoteItemPerilSummaryList[i].recordStatus != -1){
				return true;
			}
		}
	}
	if(objGIPIQuoteMortgageeList!=null){
		for(var i=0; i<objGIPIQuoteMortgageeList.length; i++){
			if(objGIPIQuoteMortgageeList[i].itemNo == itemNo && 
					objGIPIQuoteMortgageeList[i].recordStatus != -1){
				return true;
			}
		}
	}
	return false;
}