/**
 * Check if mortgagee is already in display
 * #validation #mortgagee #isAdded
 * @param perilObj
 * @return
 */
function isMortgageeAlreadyAdded(mortgageeLov){
	var selectedItemNo = getSelectedRowId("itemRow");
	var mortgageeObj = null;
	for(var i=0; i<objGIPIQuoteMortgageeList.length;i++){
		mortgageeObj = objGIPIQuoteMortgageeList[i];
		if(mortgageeObj.itemNo == selectedItemNo && mortgageeObj.recordStatus != -1){
			if(mortgageeObj.mortgCd == mortgageeLov.mortgCd){
				return true;
			}
		}
	}
	return false;
}