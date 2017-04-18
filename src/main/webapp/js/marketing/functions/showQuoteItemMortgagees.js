function showQuoteItemMortgagees(){
	var itemNo = getSelectedRowId("itemRow");
	if($("txtMortgageeItemNo")!=null){
		$("txtMortgageeItemNo").value = $F("txtItemNo");
	}
	if(objGIPIQuoteMortgageeList==null || $("mortgageeListingDiv") == null){
		if(loadMortgageeSubpage()){ // dummy if statement
		}
	}
	if(objGIPIQuoteMortgageeList!=null){
		var mortgageeObj = null;
		mortgageeTableContainer = $("mortgageeListingDiv"); 
		mortgageeTableContainer.update("");
		for(var i=0; i<objGIPIQuoteMortgageeList.length; i++){
			mortgageeObj = objGIPIQuoteMortgageeList[i];
			if(mortgageeObj.itemNo == itemNo && mortgageeObj.recordStatus != -1){
				mortgageeRow = makeGIPIQuoteMortgageeRow(mortgageeObj);
				try{
					mortgageeTableContainer.insert({bottom: mortgageeRow});
				}catch(e){
					showErrorMessage("Error in showQuoteItemMortgagees", e);
				}
			}
		}
		resetTableStyle("mortgageeInformationDiv", "mortgageeListingDiv", "mortgageeRow");
		setMortgageeNameLov();
	}
}