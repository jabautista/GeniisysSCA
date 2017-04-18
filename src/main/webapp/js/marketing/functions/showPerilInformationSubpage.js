/**
 * THROWS NULL EXCEPTION IN CASUALTY!
 * @return
 */
function showPerilInformationSubpage(){
	try{
		var itemNo = getSelectedRowId("itemRow");	
		var perilObj = null;
//		if($("itemPerilMotherDiv")==null){
//		}
		$("itemPerilMotherDiv").update("");
		
		for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
			perilObj = objGIPIQuoteItemPerilSummaryList[i];
			perilObj.premiumAmount = computePremiumAmount2(perilObj);
			if(perilObj.itemNo == itemNo && perilObj.recordStatus != -1){
				var newPerilRow = makeGIPIQuoteItemPerilRow(perilObj);
				$("itemPerilMotherDiv").insert({bottom: newPerilRow});
			}
		}

		resetTableStyle("itemPerilTable","itemPerilMotherDiv","perilRow");
		computeInvoiceTsiAmountsAndPremiumAmounts();
		setPerilNameLov();
	}catch(e){
		//showErrorMessage("ERROR occured in: showPerilInformationSubpage()" + e);
		setPerilNameLov();
	}
}