/**
 * Checks if the peril list is empty of perils - perils having record status
 * that is not equal to -1 will be ignored - skip the looping statement if
 * perilList.length < 1
 * @param perilList
 * @return
 */
function quotePerilListIsEmpty(){
	var selectedItemNo = getSelectedRowId("itemRow");
	var tmpPeril = null;
	for(var t=0; t<objGIPIQuoteItemPerilSummaryList.length; t++){
		tmpPeril = objGIPIQuoteItemPerilSummaryList[t];
		if(tmpPeril.itemNo == selectedItemNo){ // skip unrelated items
			if(tmpPeril.recordStatus != -1){ // ignore deleted items
				return false;
			}
		}
	}
	return true;
}