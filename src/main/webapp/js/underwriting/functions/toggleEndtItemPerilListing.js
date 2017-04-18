function toggleEndtItemPerilListing(objCurrItem){
	try {
		$("itemAnnTsiAmt").value = formatCurrency(objCurrItem.annTsiAmt);
		$("itemAnnPremiumAmt").value = formatCurrency(objCurrItem.annPremAmt);
	} catch (e){
		showErrorMessage("toggleEndtItemPerilListing", e);
	}
}