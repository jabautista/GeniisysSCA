/**
 * Compute total tsiAmt, annTsiAmt, premAmt, annPremAmt of current objGIPIQuote
 * - used within quotationInformationMain page only
 * @return
 */
function computeAllTsiAndPrems(){
	var currencyObject = getDefaultCurrencyCdInQuoteInfo();
	var tmpPremAmt = 0;
	//var tmpAnnPremAmt = 0;
	var tmpTsiAmt = 0;
	//var tmpAnnTsiAmt = 0;
	
	var tmpTotalTsi = 0;
	var tmpTotalPrem = 0;
	
	for(var i = 0; i < objGIPIQuoteItemPerilSummaryList.length; i++){
		var peril = objGIPIQuoteItemPerilSummaryList[i];
		if(peril.recordStatus != -1){
			var rate = 1;
			if(formatCurrency(peril.currencyCd) != formatCurrency(currencyObject.currencyCd)){
				// if not equal to Peso, on the assumption that Peso is the primary currency
				// var currencyRate = peril.currencyRate;
				rate = peril.currencyRate;
			}
			
			tmpPremAmt	= peril.premiumAmount * rate;
			tmpTsiAmt 	= peril.tsiAmount * rate;
			
			tmpTotalPrem	= tmpTotalPrem + tmpPremAmt;
			tmpTotalTsi		= tmpTotalTsi + tmpTsiAmt;
		}
	}
	objGIPIQuote.premAmt = tmpTotalPrem;	//objGIPIQuote.annPremAmt;
	objGIPIQuote.tsiAmt	= tmpTotalTsi;	//objGIPIQuote.annTsiAmt;
}