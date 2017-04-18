/**
 * Computes the annualized amounts(tsi, premAmt) and total tsiAmount and premAmt of all the perils under the quotation in context.
 * - ignores Allied perils
 * - disregards itemNo of the perils
 * @return
 */
function computeTotalTSIAndPremiumForGIPIQuote(){
	var tsiTotal = 0;
	var premiumAmountTotal = 0;
	for(var i=0; i<objGIPIQuoteItemPerilSummaryList.length; i++){
		var perilObj = objGIPIQuoteItemPerilSummaryList[i];
		if(perilObj.recordStatus != -1){
			if(perilObj.perilType == "B" || perilObj.perilType == null){ // SOME ROWS IN GIPI_QUOTE_ITMPERIL HAVE NO PERIL_TYPE DATA / MAY CAUSE ERRORS IN COMPUTATION
				tsiTotal = tsiTotal + parseFloat(perilObj.tsiAmount);
			}
			premiumAmountTotal = premiumAmountTotal + parseFloat(perilObj.premiumAmount);
		}
	}
}