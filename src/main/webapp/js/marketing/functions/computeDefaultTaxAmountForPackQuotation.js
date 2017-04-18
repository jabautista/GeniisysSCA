/**
 * Computes the default tax amount of a selected quote invoice tax.
 * @param perilSw - perilSw
 * @param rate - invoice tax rate
 * @param perilCd - the peril code
 * @return defaultTaxAmt - the computed invoice tax amount
 */

function computeDefaultTaxAmountForPackQuotation(perilSw, rate, perilCd){
	var defaultTaxAmt = 0;
	var premAmt = 0;
	
	if(perilSw == "Y"){
		for(var i=0; i<objPackQuoteItemPerilList.length; i++){
			if(objPackQuoteItemPerilList[i].quoteId == objCurrPackQuote.quoteId &&
			   objPackQuoteItemPerilList[i].perilCd == perilCd &&
			   objPackQuoteItemPerilList[i].recordStatus != -1){
				premAmt = parseFloat(premAmt) + parseFloat(objPackQuoteItemPerilList[i].premiumAmount);
			}
		}
		defaultTaxAmt = parseFloat(nvl(premAmt, 0)) * (parseFloat(nvl(rate, 0) / 100));
	}else{
		var selectedItemRow = getSelectedRow("row");
		var currQuoteInvoice = getCurrPackQuoteInvoice(selectedItemRow);
		premAmt = currQuoteInvoice.premAmt;
		defaultTaxAmt = parseFloat(nvl(premAmt, 0)) * (parseFloat(nvl(rate, 0) / 100));
	}
	
	defaultTaxAmt = formatCurrency(defaultTaxAmt);
	return defaultTaxAmt;
}