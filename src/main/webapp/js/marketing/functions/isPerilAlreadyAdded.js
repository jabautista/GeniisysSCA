/**
 * Check if peril is already in display
 * #validation #peril #isAdded
 * @param perilObj
 * @return
 */
function isPerilAlreadyAdded(perilLov){
	var selectedItemNo = getSelectedRowId("itemRow");
	var perilObj = null;
	for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length;i++){
		perilObj = objGIPIQuoteItemPerilSummaryList[i];
		if(perilObj.itemNo == selectedItemNo){
			if(perilObj.perilCd == perilLov.perilCd && perilObj.recordStatus != -1){
				return true;
			}
		}
	}
	return false;
}