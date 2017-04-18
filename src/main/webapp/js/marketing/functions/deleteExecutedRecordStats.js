/**
 * Deletes Records having -1 status from the lists to prevent them from being displayed [in case a new item is added]
 * e.g.: 
 * 1. loaded item 2's perils, and other child information
 * 2. delete item 2.
 * 3. press Save.
 * 4. create a new item 2. try reloading subpages.
 * this method prevents the old #2 subpages from being loaded again. 
 * @author rencela
 * @return
 */
function deleteExecutedRecordStats(){
	if(objGIPIQuoteMortgageeList!=null){
		for(var i=0; i<objGIPIQuoteMortgageeList.length; i++){
			if(objGIPIQuoteMortgageeList[i].recordStatus == -1){
				objGIPIQuoteMortgageeList.splice(i,1);
			}
		}
	}
	
	if(objGIPIQuoteItemPerilSummaryList!=null){
		for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
			if(objGIPIQuoteItemPerilSummaryList[i].recordStatus == -1){
				objGIPIQuoteItemPerilSummaryList.splice(i,1);
			}
		}
	}
	
	if(objGIPIQuoteDeductiblesSummaryList!=null){
		for(var i=0; i<objGIPIQuoteDeductiblesSummaryList.length; i++){
			if(objGIPIQuoteDeductiblesSummaryList[i].recordStatus == -1){
				objGIPIQuoteDeductiblesSummaryList.splice(i,1);
			}
		}
	}
	
	if(objGIPIQuoteItemList!=null){
		for(var i=0; i<objGIPIQuoteItemList.length; i++){
			if(objGIPIQuoteItemList[i].recordStatus == -1){
				objGIPIQuoteItemList.splice(i, 1);
			}
		}
	}
}