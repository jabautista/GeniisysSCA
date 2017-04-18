/**
 * Checks if the items having the currencyCode d currencyRate of the currently
 * selected item has a peril item OR invoiceChange - works fine despite changes =)
 * @return
 */
function hasPerils(){
	var itemNo = getSelectedRowId("itemRow");
	var hasPerils = false;
	
	if($("itemPerilMotherDiv") !=null){
		if($("itemPerilMotherDiv").childElements().size() > 0){
			hasPerils = true;
		}
	}
	return hasPerils;
}