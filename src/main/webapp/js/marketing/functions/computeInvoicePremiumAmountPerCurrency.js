/**
 * Computes the premiumAmount of perils having the same currency and currency rate
 * - ignore deleted perils
 * @param currency code
 * @param currency rate
 * @return
 */
function computeInvoicePremiumAmountPerCurrency(currencyCode, currencyRate){
	var premiumAmountSum = 0;
	for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
		var peril = objGIPIQuoteItemPerilSummaryList[i];
		if(peril.recordStatus != -1 ){
			if(	/*peril.perilType == "B" &&*/ // comment out by andrew - 10.21.2011 
				peril.currencyCd == currencyCode && 
				formatToNineDecimal(peril.currencyRate) == formatToNineDecimal(currencyRate)){
				premiumAmountSum = parseFloat(premiumAmountSum) + parseFloat(peril.premiumAmount); 
			}
		}
	}

	return premiumAmountSum;
}