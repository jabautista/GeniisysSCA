/**
 * Creates a new object for quote mortgagee
 * @return objMortgagee - quote mortgagee object
 */

function setQuoteMortgageeObject(){
	try{
		var objMortgagee = new Object();
		objMortgagee.quoteId 	= objCurrPackQuote.quoteId;
		objMortgagee.issCd 		= objCurrPackQuote.issCd;
		objMortgagee.itemNo  	= $("txtMortgageeItemNo").value;
		objMortgagee.mortgCd 	= escapeHTML2($F("selMortgagee"));
		objMortgagee.mortgName  = escapeHTML2($("txtMortgageeDisplay").value);
		objMortgagee.amount 	= unformatCurrencyValue($("txtMortgageeAmount").value);
		return objMortgagee;
	}catch(e){
		showErrorMessage("setQuoteMortgageeObject", e);
		return null;
	}
}