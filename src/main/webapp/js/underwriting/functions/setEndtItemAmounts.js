//mrobes 07.8.10
function setEndtItemAmounts(itemNo, objEndtPerils, objPolPerils){
	var itemTsiAmt = 0;
	var itemPremAmt = 0;
	var itemAnnTsiAmt = 0;
	var itemAnnPremAmt = 0;
	var exists = false;
	
	if(objCurrItem != undefined){
		objCurrItem.tsiAmt = formatCurrency(nvl($F("tsiAmt"), 0));
		objCurrItem.premAmt = formatCurrency(nvl($F("premAmt"), 0));			
		objCurrItem.annTsiAmt = formatCurrency(nvl($F("annTsiAmt"), 0));
		objCurrItem.annPremAmt = formatCurrency(nvl($F("annPremAmt"), 0));
		
		$("itemTsiAmt").value 		 = objCurrItem.tsiAmt;
		$("itemPremiumAmt").value 	 = objCurrItem.premAmt;
		$("itemAnnPremiumAmt").value = objCurrItem.annPremAmt;
		$("itemAnnTsiAmt").value 	 = objCurrItem.annTsiAmt;
	} else {
		$("itemTsiAmt").value 		 = "0.00";
		$("itemPremiumAmt").value 	 = "0.00";
		$("itemAnnTsiAmt").value 	 = "0.00";
		$("itemAnnPremiumAmt").value = "0.00";
	}
}