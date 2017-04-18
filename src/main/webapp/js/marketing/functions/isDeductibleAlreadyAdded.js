/**
 * Checks if deductible is already added in objGIPIQuoteDeductiblesSummaryList
 * - ignores deleted (those with recordStatus -1) deductibles
 * @param deductibleCd
 * @return
 */
function isDeductibleAlreadyAdded(deductibleCd){
	for(var i=0; i<objGIPIQuoteDeductiblesSummaryList.length; i++){
		if(objGIPIQuoteDeductiblesSummaryList[i].dedDeductibleCd == deductibleCd && 
				objGIPIQuoteDeductiblesSummaryList[i].recordStatus != -1){
			return true;
		}
	}
	return false;
}